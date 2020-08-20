import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/language.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class BottomRightMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  BottomRightMenu({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _BottomRightMenuState createState() => _BottomRightMenuState();
}

class _BottomRightMenuState extends StateMVC<BottomRightMenu> {
  static const double _iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
//          _createUserInfo(context),
          Container(
            width: double.infinity,
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(S.of(context).groceries1, style: Theme.of(context).textTheme.headline5),
            ),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoHome(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Shop_All_Groceries.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Shop_All_Groceries.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).shopAllGroceries),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoPromotions(context),
//            leading: ImageIcon(AssetImage('assets/img/F_Promotion_01.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/F_Promotion_01.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).promotions),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoMyFavorites(context),
//            leading: Icon(UiIcons.favorites, color: DmConst.primaryColor),
            leading: Image.asset('assets/img/Favourite.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).myFavorite),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoSpecial4U(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Special_4_U.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Special_4_U.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).specialForYou),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoMyOrders(context),
//            leading: ImageIcon(AssetImage('assets/img/M_My_order.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_My_order.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).my_orders),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoCart(context),
//            leading: ImageIcon(AssetImage('assets/img/H_Cart.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/H_Cart.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).myCart),
          ),

          Container(
            width: double.infinity,
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(S.of(context).domainDmart, style: Theme.of(context).textTheme.headline5),
            ),
          ),

          ListTile(
            onTap: () => RouteGenerator.gotoHelp(context),
//            leading: ImageIcon(AssetImage('assets/img/H_User_Icon.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/H_User_Icon.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).myAccount),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.isLogin) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushReplacementNamed('/Login');
              }
            },
//            leading: ImageIcon(AssetImage('assets/img/M_Contact_us.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Contact_us.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).contactUs),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(Icons.help_outline, color: DmConst.primaryColor),
            title: Text(S.of(context).help),
          ),
          ListTile(
            onTap: () {
              settingRepo.setDefaultLanguage(Language.khmer.code);
            },
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Cambodia.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Flag_Cambodia.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).langKhmer),
          ),
          ListTile(
            onTap: () {
              settingRepo.setDefaultLanguage(Language.english.code);
            },
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Eng.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Flag_Eng.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).langEnglish),
          ),
          setting.value.enableVersion
              ? ListTile(
                  dense: true,
                  title: Text(S.of(context).version + " " + setting.value.appVersion,
                      style: Theme.of(context).textTheme.bodyText2),
                  trailing: Icon(Icons.remove, color: Theme.of(context).focusColor.withOpacity(0.3)),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
