import 'package:audioplayers/audioplayers.dart';
import 'package:dmart/src/models/RadioItem.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:dmart/src/models/language.dart';
import 'package:dmart/src/models/noti.dart';
import 'package:dmart/src/models/order_setting.dart';
import 'package:dmart/src/repository/radio_repository.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import './src/repository/user_repository.dart' as userRepo;

class DmState {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  // static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();
  static bool isRadioOn = true;
  static ValueNotifier<Locale> mobileLanguage =
      ValueNotifier(Locale(Language.english.code));

  static RadioItem? currentRadio;

  static RadioItem? nextRadio;

  static List<Noti>? notifications;

  static Noti? pendingNoti;

  static bool get isKhmer {
    return mobileLanguage.value.languageCode != Language.english.code;
  }

  static bool isLoggedIn() {
    return userRepo.currentUser.value.apiToken != null &&
        userRepo.currentUser.value.apiToken!.length > 10;
  }

  static List<String>? recentSearches;
  static int bottomBarSelectedIndex = 0;
  static ValueNotifier<int> amountInCart = ValueNotifier(0);
  static ValueNotifier<double> cartsValue = ValueNotifier(0.0);
  static List<Cart> carts = [];

  static List<Favorite> favorites = [];

  static OrderSetting orderSetting = OrderSetting();

  static void refreshCart(List<Cart> _carts) {
    carts.clear();
    _carts.forEach((element) {
      Cart c = findCart(element.product!.id);
      if (c.isValid) {
        c.quantity += element.quantity;
      } else {
        carts.add(element);
      }
    });

    double am = 0;
    double value = 0;
    carts.forEach((element) {
//      print('this is currently in cart: $element');
      am += element.quantity;
      value += element.product!.paidPrice * element.quantity;
    });
    cartsValue.value = value;
    amountInCart.value = am.round();
//    print('current cart amountInCart = ${amountInCart.value} ');
  }

  static Cart findCart(int productId) {
    Cart? c;
    carts.forEach((element) {
      if (element.product?.id == productId) {
        c = element;
        return;
      }
    });
    return c!;
  }

  static int countQuantityInCarts(int productId) {
    int re = 0;
    carts.forEach((c) {
      if (c.product!.id == productId) {
        re += c.quantity.round();
      }
    });
    return re;
  }

  static bool isFavorite({required int productId}) {
    bool re = false;
    favorites.forEach((element) {
      if (element.product!.id == productId) {
        re = true;
        return;
      }
    });
    return re;
  }

  static void refreshFav({required List<Favorite> fav}) {
    favorites.clear();
    favorites.addAll(fav);
  }

  static Favorite? findFav(int productId) {
    Favorite? f;
    favorites.forEach((element) {
      if (element.product?.id == productId) {
        f = element;
        return;
      }
    });
    return f;
  }

  static void insertRecentSearch(String currentUserInput) {
    if (DmUtils.isNullOrEmptyStr(currentUserInput)) return;

    if (recentSearches == null) {
      recentSearches = [];
    }

    String s = currentUserInput.trim();

    if (!recentSearches!.contains(s)) {
      if (recentSearches!.isNotEmpty)
        recentSearches!.insert(0, currentUserInput);
      else
        recentSearches!.add(currentUserInput);
    }
  }

  static String getCurrentLanguage() => isKhmer ? 'kh' : 'en';

  static AudioPlayer? _audioPlayer;

  static void loadRadioFromServerAndPlay() {
    if (isRadioOn) {
      print('=======loadRadioFromServerAndPlay');
      loadCurrentRadio().then((loadResult) {
        if (loadResult == true) {
          currentRadio = DmState.currentRadio;
          nextRadio = DmState.nextRadio;
          _calPosition2PlayOrWaitForNextReload();
        }
      });
    }
  }

  static Future<void> _playRadio(RadioItem currentRadio,
      {int seekToMs = 0}) async {
    _releasePlayer();
    _audioPlayer = AudioPlayer();
    print(currentRadio);
    print('seek to ' + seekToMs.toString());

    _audioPlayer?.onPlayerCompletion.listen((event) {
      print("audioPlayer.onPlayerCompletion:");
      var now = DateTime.now();
      var toEndMs = currentRadio.endTime!.millisecondsSinceEpoch -
          now.millisecondsSinceEpoch;
      print("audioPlayer.onPlayerCompletion: $toEndMs");
      if (!currentRadio.isRepeat()) {
        //1. if not repeat >> wait for next file.
        print("not repeat >> wait for next file toEndMs. $toEndMs");
        var toNextRadio = nextRadio!.startTime!.millisecondsSinceEpoch -
            now.millisecondsSinceEpoch;
        Future.delayed(Duration(milliseconds: toNextRadio + 100),
            loadRadioFromServerAndPlay);
      } else {
        if (toEndMs > 5000) {
          _playRadio(currentRadio);
        } else {
          Future.delayed(Duration(milliseconds: toEndMs + 500),
              loadRadioFromServerAndPlay);
        }
      }
    });

    await _audioPlayer!.setUrl(currentRadio.mediaUrl!);
    await _audioPlayer!.seek(Duration(milliseconds: seekToMs));
    await _audioPlayer!.resume();

    // await audioPlayer.play(currentRadio.mediaUrl, position: Duration(milliseconds: seekToMs));
  }

  static void _calPosition2PlayOrWaitForNextReload() {
    print(
        "_calPosition2PlayOrWaitForNextReload: $currentRadio, next $nextRadio");
    DateTime now = DateTime.now();

    if (currentRadio == null) {
      //wait until next radio and reload from server.
      var now2Next = nextRadio!.startTime!.millisecondsSinceEpoch -
          now.millisecondsSinceEpoch;
      Future.delayed(
          Duration(milliseconds: now2Next + 500), loadRadioFromServerAndPlay);
      return;
    }

    int start2Now = now.millisecondsSinceEpoch -
        currentRadio!.startTime!.millisecondsSinceEpoch;
    if ((start2Now < currentRadio!.duration! * 1000) ||
        (start2Now > currentRadio!.duration! * 1000 &&
            currentRadio!.isRepeat())) {
      int seekTo = start2Now % (DmState.currentRadio!.duration! * 1000);
      _playRadio(currentRadio!, seekToMs: seekTo);
    } else {
      //no need to play current file. Wait for next radio.
      var now2Next = nextRadio!.startTime!.millisecondsSinceEpoch -
          now.millisecondsSinceEpoch;
      Future.delayed(
          Duration(milliseconds: now2Next + 500), loadRadioFromServerAndPlay);
    }
  }

  static void _releasePlayer() {
    print("release the player");
    _audioPlayer!.stop();
    _audioPlayer!.release();
    _audioPlayer = null;
  }

  static void setRadioStatus({bool on = true}) {
    var preState = isRadioOn;
    isRadioOn = on;
    if (isRadioOn == false) {
      print('turn OFF radio');
      _releasePlayer();
    } else {
      // turn on Radio
      if (!preState) {
        //from off status
        print('turn on radio');
        _releasePlayer();
        loadRadioFromServerAndPlay();
      }
    }
  }

  static void stopRadio() {
    if (isRadioOn) {
      //from off status
      _releasePlayer();
    }
  }

  static void resumeRadio() {
    if (isRadioOn) {
      //from off status
      _releasePlayer();
      loadRadioFromServerAndPlay();
    }
  }
}
