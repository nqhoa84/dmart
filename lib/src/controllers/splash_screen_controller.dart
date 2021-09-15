import 'dart:async';

import 'package:dmart/constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../DmState.dart';
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

  final firebaseMessaging = FirebaseMessaging();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  SplashScreenController({GlobalKey<ScaffoldState> scaffoldKey}) : super();

  void init() {
    _initFireBase();
  }

  void _initFireBase() {
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _configureFirebase(firebaseMessaging);
    firebaseMessaging.getToken().then((String _deviceToken) {
      DmConst.deviceToken = _deviceToken;
      print(' DmConst.deviceToken--${DmConst.deviceToken}');
    }).catchError((e) {
      print('Notification not configured $e');
    });
  }

  void _configureFirebase(FirebaseMessaging _firebaseMessaging) {
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
    print('==notificationOnResume: $message');
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
    print('==notificationOnLaunch: $message');
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
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await DmState.flutterLocalNotificationsPlugin?.show(
        0, 'plain title', '$message', platformChannelSpecifics,
        payload: 'the payload ');

//     Fluttertoast.showToast(
// //      msg: message['notification']['title'],
//       msg: '$message',
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.TOP,
//       timeInSecForIosWeb: 5,
//     );
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
