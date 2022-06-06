import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/language.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:dmart/src/widgets/BottomRightMenu.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class BottomRightMenuScreen extends StatelessWidget {
  static const double _iconSize = 25.0;

  Widget buildContent(BuildContext context) {
    return Column(
      children: <Widget>[
//          _createUserInfo(context),
        Container(
          width: double.infinity,
          color: Colors.grey.shade400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(S.current.groceries1,
                style: Theme.of(context).textTheme.headline5),
          ),
        ),
        ListTile(
//            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          onTap: () => RouteGenerator.gotoHome(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Shop_All_Groceries.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Shop_All_Groceries.png',
              width: _iconSize, height: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.shopAllGroceries),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoPromotions(context),
//            leading: ImageIcon(AssetImage('assets/img/F_Promotion_01.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/F_Promotion_01.png',
              width: _iconSize, height: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.promotions),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoMyFavorites(context),
//            leading: Icon(UiIcons.favorites, color: DmConst.primaryColor),
          leading: Image.asset('assets/img/Favourite.png',
              width: _iconSize, height: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myFavorite),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoSpecial4U(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Special_4_U.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Special_4_U.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.specialForYou),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoMyOrders(context),
//            leading: ImageIcon(AssetImage('assets/img/M_My_order.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_My_order.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myOrders),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoCart(context),
//            leading: ImageIcon(AssetImage('assets/img/H_Cart.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/H_Cart.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myCart),
        ),

        Container(
          width: double.infinity,
          color: Colors.grey.shade400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(S.current.domainDmart,
                style: Theme.of(context).textTheme.headline5),
          ),
        ),

        ListTile(
          onTap: () {
            if (currentUser.value.isLogin)
              RouteGenerator.gotoProfileInfo(context);
            else
              RouteGenerator.gotoLogin(context);
          },
//            leading: ImageIcon(AssetImage('assets/img/H_User_Icon.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/H_User_Icon.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myAccount),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoContactUs(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Contact_us.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Contact_us.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.contactUs),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/Help');
          },
          leading: Icon(Icons.help_outline, color: DmConst.accentColor),
          title: Text(S.current.help),
        ),
        ListTile(
          onTap: () {
            settingRepo.setDefaultLanguage(Language.khmer.code);
          },
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Cambodia.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Flag_Cambodia.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.langKhmer),
        ),
        ListTile(
          onTap: () {
            settingRepo.setDefaultLanguage(Language.english.code);
          },
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Eng.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Flag_Eng.png',
              width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.langEnglish),
        ),
        setting.value.enableVersion!
            ? ListTile(
                dense: true,
                title: Text(S.current.version + " " + setting.value.appVersion!,
                    style: Theme.of(context).textTheme.bodyText2),
                trailing: Icon(Icons.remove,
                    color: Theme.of(context).focusColor.withOpacity(0.3)),
              )
            : SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: 4),
      body: DoubleBackToCloseApp(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              createSliverTopBar(context),
              createSliverSearch(context),
              SliverList(
                delegate: SliverChildListDelegate([
                  BottomRightMenu(),
//                SliverToBoxAdapter(child: BottomRightMenu()),
                ]),
              )
            ],
          ),
        ),
        snackBar: SnackBar(
          content: Text(S.current.tapBackAgainToQuit),
        ),
      ),
    );
  }
}
