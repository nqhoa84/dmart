import 'package:dmart/src/widgets/BottomRightMenu.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../repository/user_repository.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {

  Widget buildUserInfo(BuildContext context) {
    if(currentUser.value.isLogin) {
      return ListTile(
        title: Text(currentUser.value.name,
          style: TextStyle(color: Colors.white),),
        subtitle: Text('${S.current.credit}: ${currentUser.value.credit.toStringAsFixed(2)}',
        style: TextStyle(color: DmConst.textColorForTopBarCredit),),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          backgroundImage: NetworkImage(currentUser.value.avatarUrl),
        ),
      );
    } else {
      return ListTile(
        title: Text(S.current.guest),
        subtitle: Text('${S.current.credit}: 0.00'),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          backgroundImage: AssetImage('assets/img/H_User_Icon.png'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title: GestureDetector(
              onTap: () {
                currentUser.value.isLogin
                    ? RouteGenerator.gotoHome(context)
                    : RouteGenerator.gotoLogin(context);
              },
              child: buildUserInfo(context)
          ),
          leading: null,
          automaticallyImplyLeading: false,
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BottomRightMenu(),
          ),
        ),
      ),
    );
  }
}
