import 'package:dmart/src/models/noti.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../repository/notification_repository.dart';

class NotificationController extends ControllerMVC {
  List<Noti>? notifications;
  Noti? notification;
  GlobalKey<ScaffoldState>? scaffoldKey;

  NotificationController({this.notifications, this.notification}) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications();
  }

  void listenForNotifications({String? message, Function()? onDone}) async {
    var notis = await loadNoties();
    setState(() {
      this.notifications = notis;
    });

    // final Stream<model.Notification> stream = await getNotifications();
    // stream.listen((model.Notification _notification) {
    //   setState(() {
    //     if(_notification != null && _notification.isValid)
    //       notifications.add(_notification);
    //   });
    // }, onError: (a) {
    //   print(a);
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(S.current.verifyYourInternetConnection),
    //   ));
    // }, onDone: () {
    //   if (message != null) {
    //     scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    //   }
    // });
  }

  Future<void> refreshNotifications() async {
    notifications!.clear();
    listenForNotifications(
        message: S.current.notificationsRefreshedSuccessfully);
  }

  void removeFromNotification(Noti _notification) async {
    //   removeNotification(_notification).then((value) {
    //     setState(() {
    //       this.notification = new model.Notification();
    //     });
    //     scaffoldKey.currentState.showSnackBar(SnackBar(
    //       content: Text('This notification was removed '),
    //     ));
    //   });
    // }
    await removeNoti(_notification);

    setState(() {
      this.notifications!.remove(_notification);
    });
//    removeNotification(_notification).then((value) {
//      scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(S.current.this_notification_was_removed)));
//    });
  }
}
