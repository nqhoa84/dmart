import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:dmart/src/models/language.dart';
import 'package:dmart/src/models/order_setting.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:dmart/src/repository/settings_repository.dart' as settingRepo;

class DmState {
  static ValueNotifier<Locale> mobileLanguage = ValueNotifier(Locale(Language.english.code));
  static bool get isKhmer {
    return  mobileLanguage.value.languageCode != Language.english.code;
  }
  static List<String> recentSearches;
  static int bottomBarSelectedIndex = 0;
  static ValueNotifier<int> amountInCart = ValueNotifier(0);
  static ValueNotifier<double> cartsValue = ValueNotifier(0.0);
  static List<Cart> carts = [];

  static List<Favorite> favorites = [];

  static OrderSetting orderSetting = OrderSetting();

  static void refreshCart(List<Cart> _carts) {
    carts.clear();
    _carts.forEach((element) {
      Cart c = findCart(element.product?.id);
      if(c != null && c.isValid) {
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
      value += element.product.paidPrice * element.quantity;
    });
    cartsValue.value = value;
    amountInCart.value = am.round();
//    print('current cart amountInCart = ${amountInCart.value} ');
  }

  static Cart findCart(int productId) {
    Cart c;
    carts.forEach((element) {
      if(element.product?.id == productId) {
        c = element;
        return;
      }
    });
    return c;
  }

  static int countQuantityInCarts(int productId) {
    int re = 0;
    carts.forEach((c) {
      if(c.product.id == productId) {
        re += c.quantity.round();
      }
    });
    return re;
  }

  static bool isFavorite({int productId}) {
    bool re = false;
    favorites.forEach((element) {
      if(element.product.id == productId) {
        re = true;
        return;
      }
    });
    return re;
  }

  static void refreshFav({List<Favorite> fav}) {
    favorites.clear();
    if(fav != null) favorites.addAll(fav);
  }

  static Favorite findFav(int productId) {
    Favorite f;
    favorites.forEach((element) {
      if(element.product?.id == productId) {
        f = element;
        return;
      }
    });
    return f;
  }

  static void insertRecentSearch(String currentUserInput) {
    if(DmUtils.isNullOrEmptyStr(currentUserInput)) return;

    if(recentSearches == null) {
      recentSearches = [];
    }

    String s = currentUserInput.trim();

    if(!recentSearches.contains(s)) {
      if(recentSearches.isNotEmpty)
        recentSearches.insert(0, currentUserInput);
      else
        recentSearches.add(currentUserInput);
    }
  }

  static String getCurrentLanguage() => isKhmer ? 'kh' : 'en';

}
