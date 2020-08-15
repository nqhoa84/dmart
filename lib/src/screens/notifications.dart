import '../../generated/l10n.dart';
import '../../src/repository/user_repository.dart';
import '../../src/widgets/PermissionDeniedWidget.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';

import '../controllers/notification_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/widgets/EmptyNotificationsWidget.dart';
import '../../src/widgets/NotificationItemWidget.dart';
import '../../src/widgets/SearchBarWidget.dart';
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
    _con =controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              S.of(context).notifications,
              style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor
          ),
        ],
      ),
        body: currentUser.value.apiToken == null
        ? PermissionDeniedWidget()
        : RefreshIndicator(
            onRefresh: _con.refreshNotifications,
            child:SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchBarWidget(
                      onClickFilter: (event) {
                        widget.parentScaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                  ),
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
                        return NotificationItemWidget(
                          notification: _con.notifications.elementAt(index),
                          onDismissed: (notification) {
                            setState(() {
                              _con.removeFromNotification(_con.notifications.elementAt(index));
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Offstage(
                    offstage: _con.notifications.isNotEmpty,
                    child: EmptyNotificationsWidget(),
                  )
              ],
            ),
          ),
        )
    );
  }
}
