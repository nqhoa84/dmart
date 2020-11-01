import 'dart:async';

import 'package:dmart/constant.dart';

import '../../src/helpers/custom_trace.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'controller.dart';

class SplashScreenController extends Controller with ChangeNotifier {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  SplashScreenController({GlobalKey<ScaffoldState> scaffoldKey}) : super(scaffoldKey: scaffoldKey);

  @override
  void _initState() {
    super.initState();
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    configureFirebase(firebaseMessaging);
    settingRepo.setting.addListener(() {
      if (settingRepo.setting.value.appName != null && settingRepo.setting.value.appName != '' && settingRepo.setting.value.mainColor != null) {
        progress.value["Setting"] = 50;
        progress?.notifyListeners();
      }
    });
    userRepo.currentUser.addListener(() {
      if (userRepo.currentUser.value.isLogin) {
        progress.value["User"] = 100;
        progress?.notifyListeners();
      }
    });
    Timer(Duration(seconds: 20), () {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    });
  }

  void initFireBase() {
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    configureFirebase(firebaseMessaging);
    FirebaseMessaging().getToken().then((String _deviceToken) {
      DmConst.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured $e');
    });
  }

  void configureFirebase(FirebaseMessaging _firebaseMessaging) {
    try {
      _firebaseMessaging.configure(
        onMessage: notificationOnMessage,
        onLaunch: notificationOnLaunch,
        onResume: notificationOnResume,
      );
    } catch (e, trace) {
      print('$e, $trace');
    }
  }

  Future notificationOnResume(Map<String, dynamic> message) async {
    print(message['data']['id']);
    try {
      if (message['data']['id'] == "orders") {
        settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
      }
    } catch (e, trace) {
      print(e);
      print(trace);
    }
  }

  Future notificationOnLaunch(Map<String, dynamic> message) async {
    String messageId = await settingRepo.getMessageId();
    try {
      if (messageId != message['google.message_id']) {
        if (message['data']['id'] == "orders") {
          await settingRepo.saveMessageId(message['google.message_id']);
          settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 3);
        }
      }
    } catch (e, trace) {
      print(trace);
    }
  }

  Future notificationOnMessage(Map<String, dynamic> message) async {
    print('OnMessage: $message');
    Fluttertoast.showToast(
      msg: message['notification']['title'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 5,
    );
  }

  // ignore: missing_return
  /*static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      //final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      //final dynamic notification = message['notification'];
    }
  }*/
}
