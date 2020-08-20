import '../../generated/l10n.dart';
import '../../src/repository/user_repository.dart';
import '../../src/widgets/PermissionDenied.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';

import '../controllers/notification_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/widgets/EmptyNotificationsWidget.dart';
import '../../src/widgets/NotificationItem.dart';
import '../../src/widgets/SearchBar.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import 'package:flutter/material.dart';

class NotificationsWidget extends StatefulWidget {

  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const NotificationsWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends StateMVC<NotificationsWidget> {
  NotificationController _con;

  _NotificationsWidgetState() : super(NotificationController()){
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.listenForNotifications(onDone: (){
      setState(() { });
      print('Now noti count = ${_con.notifications.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_con.scaffoldKey,
        body: currentUser.value.isLogin == true
        ? PermissionDenied()
        : RefreshIndicator(
            onRefresh: _con.refreshNotifications,
            child:SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Column(
                children: <Widget>[
                  //ListView of empty
                  Offstage(
                    offstage: _con.notifications.isEmpty,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.notifications.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 7);
                      },
                      itemBuilder: (context, index) {
                        var noti = _con.notifications.elementAt(index);
//                        return Text('${noti?.id} - ${noti?.type}');
                        return NotificationItem(
                          notification: noti,
                          onDismissed: (notification) {
                            setState(() {
//                              _con.removeFromNotification(_con.notifications.elementAt(index));
                                _con.notifications.removeAt(index);
                            });
                          },
                        );
                      },
                    )
                  ),
                  //EmptyNotificationWidget
                  Offstage(
                    offstage: _con.notifications.isNotEmpty,
                    child: EmptyNotificationsWidget()
                  )
              ],
            ),
          ),
        )
    );
  }
}
