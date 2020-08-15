import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/notification.dart' as model;
import '../repository/notification_repository.dart';

class NotificationController extends ControllerMVC
{
  List<model.Notification> notifications = <model.Notification>[];
  model.Notification notification;
  GlobalKey<ScaffoldState> scaffoldKey;

  NotificationController () {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications();
  }

  void listenForNotifications ({String message}) async {
    final Stream<model.Notification> stream = await getNotifications();
    stream.listen((model.Notification _notification) {
      setState(() {
        notifications.add(_notification);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null)
      {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshNotifications () async {
    notifications.clear();
    listenForNotifications(
        message: S.of(context).notifications_refreshed_successfuly);
  }

  void removeFromNotification (model.Notification _notification) async {
    /* removeNotification(_notification).then((value) {
      setState(() {
        this.notification = new model.Notification();
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This notification was removed '),
      ));
    });
  }*/
    setState(() {
      this.notifications.remove(_notification);
    });
    removeNotification(_notification).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S
              .of(context)
              .this_notification_was_removed))
      );
    });
  }
}
