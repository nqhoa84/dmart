import 'dart:async';
import 'dart:io';

import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/noti.dart';
import 'package:dmart/src/repository/notification_repository.dart';
import 'package:dmart/src/repository/settings_repository.dart';
import 'package:dmart/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

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
  BuildContext context;
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());

  // final firebaseMessaging = FirebaseMessaging();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  SplashScreenController({GlobalKey<ScaffoldState> scaffoldKey}) : super();

  void init() {
    _initFireBase();
  }

  void _initFireBase() {
    // firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    //
    // _configureFirebase(firebaseMessaging);
    // firebaseMessaging.getToken().then((String _deviceToken) {
    //   DmConst.deviceToken = _deviceToken;
    //   print(' DmConst.deviceToken--${DmConst.deviceToken}');
    // }).catchError((e) {
    //   print('Notification not configured $e');
    // });
  }

  void _configureFirebase(FirebaseMessaging _firebaseMessaging) {
    //TODO unrem to enable FCM
    // try {
    //   _firebaseMessaging.(
    //     onMessage: notificationOnMessage,
    //     onLaunch: notificationOnLaunch,
    //     onResume: notificationOnResume,
    //   );
    // } catch (e, trace) {
    //   print('$e, $trace');
    // }
  }

  // Future notificationOnResume(Map<String, dynamic> message) async {
  //   print('==notificationOnResume: $message');
  //   Noti n = saveNotiToLocal(message);
  //   int id = toInt(n.data);
  //   switch(n.type) {
  //     case NotiType.product:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoProductDetailPage(DmState.navState.currentContext, productId: id);
  //       });
  //       break;
  //     case NotiType.category:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoCategoryPage(DmState.navState.currentContext, cateId: id);
  //       });
  //       break;
  //     case NotiType.order:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoOrderDetailPage(DmState.navState.currentContext, orderId: id);
  //       });
  //       break;
  //     case NotiType.promotion:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoPromotionPage(DmState.navState.currentContext, promotionId: id);
  //       });
  //       break;
  //     case NotiType.bestSale:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoBestSale(DmState.navState.currentContext);
  //       });
  //       break;
  //     case NotiType.newArrival:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoNewArrivals(DmState.navState.currentContext);
  //       });
  //       break;
  //     case NotiType.special4U:
  //       SchedulerBinding.instance.addPostFrameCallback((_) {
  //         RouteGenerator.gotoSpecial4U(DmState.navState.currentContext);
  //       });
  //       break;
  //   }
  // }
  //
  // Future notificationOnLaunch(Map<String, dynamic> message) async {
  //   print('==notificationOnLaunch: $message');
  //   Noti n = await saveNotiToLocal(message);
  //   DmState.pendingNoti = n;
  // }
  //
  // Future notificationOnMessage(Map<String, dynamic> message) async {
  //   print('OnMessage===========: $message');
  //   var noti = await saveNotiToLocal(message);
  //
  //   _showMaterialDialog(noti: noti);
  //
  // }

  void _showMaterialDialog({Noti noti}) {
    print('_showMaterialDialog $noti');
    void onPressOnCancel() {
      Navigator.pop(DmState.navState.currentContext);
    }
    void onPressOnView() {
      Navigator.pop(DmState.navState.currentContext);
      int id = toInt(noti.data);
      switch (noti.type) {
        case NotiType.product:
          RouteGenerator.gotoProductDetailPage(
              DmState.navState.currentContext, productId: id);
          break;
        case NotiType.category:
          RouteGenerator.gotoCategoryPage(
              DmState.navState.currentContext, cateId: id);
          break;
        case NotiType.order:
          RouteGenerator.gotoOrderDetailPage(
              DmState.navState.currentContext, orderId: id);
          break;
        case NotiType.promotion:
          RouteGenerator.gotoPromotionPage(
              DmState.navState.currentContext, promotionId: id);
          break;
        case NotiType.bestSale:
          RouteGenerator.gotoBestSale(DmState.navState.currentContext);
          break;
        case NotiType.newArrival:
          RouteGenerator.gotoNewArrivals(DmState.navState.currentContext);
          break;
        case NotiType.special4U:
          RouteGenerator.gotoSpecial4U(DmState.navState.currentContext);
          break;
      }
    }

    showDialog(
        context: DmState.navState.currentContext,
        builder: (context) {
          return AlertDialog(
            title: Text('${noti.title}'),
            content: Text('${noti.body}'),
            actions: <Widget>[
              TextButton(
                  onPressed: onPressOnCancel,
                  child: Text(S.current.close),),
              noti.tapable ?
              TextButton(
                onPressed: onPressOnView,
                child: Text(S.current.detail),
              ) : SizedBox()

            ],
          );
        });
  }

  Noti saveNotiToLocal(Map<String, dynamic> message) {
    Noti noti = Noti();
    if(Platform.isAndroid) {
      if(message.containsKey('data') && message['data'] is Map) {
        Map data = message['data'];
        noti.title = data['title'];
        noti.body = data['body'];
        if (data.containsKey('object_type'))
          noti.type = getType(data['object_type']);
        if (data.containsKey('object_id'))
          noti.data = data['object_id'];
      } else if (message.containsKey('notification')){
        noti.title = message['notification']['title'];
        noti.body = message['notification']['body'];
      }
    } else if (Platform.isIOS) {
      noti.title = message['title'];
      noti.body = message['body'];
      if(message.containsKey('object_type'))
        noti.type = getType(message['object_type']);
      if(message.containsKey('object_id'))
        noti.data = message['object_id'];
    }
    saveNoti(noti);
    return noti;
  }

  NotiType getType(op) {
    if(op == null) return NotiType.broadcast;
    var re = NotiType.broadcast;
    NotiType.values.forEach((element) {
      print('---${element.toString().toLowerCase()} --- ${op.toString().trim().toLowerCase()}');
      if(element.toString().trim().toLowerCase().endsWith(op.toString().trim().toLowerCase())) {
        re = element;
      }
    });
    return re;
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
