import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/noti.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/repository/user_repository.dart';
import '../../src/widgets/EmptyDataLoginWid.dart';
import '../../src/widgets/NotificationItem.dart';
import '../../src/widgets/PermissionDenied.dart';
import '../../utils.dart';
import '../controllers/notification_controller.dart';
import '../repository/user_repository.dart' as userRepo;

class NotificationsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool canBack;

  NotificationsScreen({Key key, this.canBack = false}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends StateMVC<NotificationsScreen> {
  NotificationController _con;
  User user = userRepo.currentUser.value;

  _NotificationsScreenState() : super(NotificationController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.listenForNotifications(message: '', onDone: null);
  }

  Widget buildContent(BuildContext context) {
//    if(user== null || !user.isLogin) {
//      RouteGenerator.gotoLogin(context);
//      return Container();
//    } else
    if (_con.notifications == null) {
      return Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _con.refreshNotifications,
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
                  if (!noti.tapable) {
                    return NotificationItem(
                      notification: noti,
                      onDismissed: onRemoveNoti,
                    );
                  } else {
                    return InkWell(
                      child: NotificationItem(
                        notification: noti,
                        onDismissed: onRemoveNoti,
                      ),
                      onTap: () {
                        onTapOnNoti(noti);
                      },
                    );
                  }
                },
              )),
          //EmptyNotificationWidget
          Offstage(
              offstage: _con.notifications.isNotEmpty,
              child: EmptyDataLoginWid(
                message: S.current.yourNotificationEmpty,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: 3),
      drawer: DrawerWidget(),
      drawerEnableOpenDragGesture: true,
      body: DoubleBackToCloseApp(
        child: SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(context,
                haveBackIcon: widget.canBack, title: S.current.notifications),
            SliverList(
              delegate: SliverChildListDelegate([
                buildContent(context),
              ]),
            )
          ]),
        ),
        snackBar: SnackBar(
          content: Text(S.current.tapBackAgainToQuit),
        ),
      ),
    );
  }

  @override
  Widget _build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: currentUser.value.isLogin == false
          ? PermissionDenied()
          : buildContent(context),
    );
  }

  void onRemoveNoti(Noti notification) {
    _con.removeFromNotification(notification);
    setState(() {
      _con.notifications.remove(notification);
    });
  }

  void onTapOnNoti(Noti n) {
    print('onTapOnNoti $n');
    int id = toInt(n.data);
    switch (n.type) {
      case NotiType.product:
        RouteGenerator.gotoProductDetailPage(this.context, productId: id);
        break;
      case NotiType.category:
        RouteGenerator.gotoCategoryPage(this.context, cateId: id);
        break;
      case NotiType.order:
        RouteGenerator.gotoOrderDetailPage(this.context, orderId: id);
        break;
      case NotiType.promotion:
        RouteGenerator.gotoPromotionPage(this.context, promotionId: id);
        break;
      case NotiType.bestSale:
        RouteGenerator.gotoBestSale(context);
        break;
      case NotiType.newArrival:
        RouteGenerator.gotoNewArrivals(context);
        break;
      case NotiType.special4U:
        RouteGenerator.gotoSpecial4U(context);
        break;
    }
  }
}
