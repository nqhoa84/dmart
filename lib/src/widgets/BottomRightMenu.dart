import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/language.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart';
import '../repository/user_repository.dart' as userRepo;


class BottomRightMenu extends StatefulWidget {
  @override
  _BottomRightMenuState createState() => _BottomRightMenuState();
}

class _BottomRightMenuState extends State<BottomRightMenu> {

  final double _iconSize = 25;
  @override
  Widget build(BuildContext context) {
    return userRepo.currentUser.value.isLogin
    ? buildLogin(context)
    : buildLogout(context);
  }

  Padding buildLogin(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: <Widget>[
//          _createUserInfo(context),
        Container(
          width: double.infinity,
          color: Colors.grey.shade400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(S.current.groceries1, style: Theme.of(context).textTheme.headline5),
          ),
        ),
        ListTile(
//            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          onTap: () => RouteGenerator.gotoHome(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Shop_All_Groceries.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Shop_All_Groceries.png', width: _iconSize, height: _iconSize,
              fit: BoxFit.scaleDown),
          title: Text(S.current.shopAllGroceries, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoPromotions(context),
//            leading: ImageIcon(AssetImage('assets/img/F_Promotion_01.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/F_Promotion_01.png', width: _iconSize, height: _iconSize,
              fit: BoxFit.scaleDown),
          title: Text(S.current.promotions, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoMyFavorites(context),
//            leading: Icon(UiIcons.favorites, color: DmConst.primaryColor),
          leading: Image.asset('assets/img/Favourite.png', width: _iconSize, height: _iconSize,
              fit: BoxFit.scaleDown),
          title: Text(S.current.myFavorite, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoSpecial4U(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Special_4_U.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Special_4_U.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.specialForYou, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoMyOrders(context),
//            leading: ImageIcon(AssetImage('assets/img/M_My_order.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_My_order.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myOrders, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoCart(context),
//            leading: ImageIcon(AssetImage('assets/img/H_Cart.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/H_Cart.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myCart, style: TextStyle(color: DmConst.accentColor)),
        ),

        Container(
          width: double.infinity,
          color: Colors.grey.shade400,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(S.current.domainDmart, style: Theme.of(context).textTheme.headline5),
          ),
        ),

        ListTile(
          onTap: () {
            if(currentUser.value.isLogin)
              RouteGenerator.gotoProfileInfo(context);
            else
              RouteGenerator.gotoLogin(context);
          },
//            leading: ImageIcon(AssetImage('assets/img/H_User_Icon.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/H_User_Icon.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.myAccount, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoContactUs(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Contact_us.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Contact_us.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.contactUs, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () => RouteGenerator.gotoHelp(context),
          leading: Icon(Icons.help_outline, color: DmConst.accentColor),
          title: Text(S.current.help, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: onPressOnKhmer,
          leading: Image.asset('assets/img/M_Flag_Cambodia.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.langKhmer, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: onPressOnEnglish,
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Eng.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Flag_Eng.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.langEnglish, style: TextStyle(color: DmConst.accentColor)),
        ),
        Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
        ListTile(
          onTap: () {
            logout();
            RouteGenerator.gotoHome(context);
          },
          leading: Image.asset('assets/img/H_User_Icon.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.current.logout, style: TextStyle(color: DmConst.accentColor)),
        ),
        setting.value.enableVersion
            ? ListTile(
          dense: true,
          title: Text(S.current.version + " " + setting.value.appVersion, style: TextStyle(color: DmConst.accentColor)),
          trailing: Icon(Icons.remove, color: Theme.of(context).focusColor.withOpacity(0.3)),
        )
            : SizedBox(),
      ],
    ),
  );
  }


  Padding buildLogout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
//          _createUserInfo(context),
          Container(
            width: double.infinity,
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(S.current.groceries1, style: Theme.of(context).textTheme.headline5),
            ),
          ),
          ListTile(
//            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            onTap: () => RouteGenerator.gotoHome(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Shop_All_Groceries.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Shop_All_Groceries.png', width: _iconSize, height: _iconSize,
                fit: BoxFit.scaleDown),
            title: Text(S.current.shopAllGroceries, style: TextStyle(color: DmConst.accentColor)),
          ),
          Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
          ListTile(
            onTap: () => RouteGenerator.gotoPromotions(context),
//            leading: ImageIcon(AssetImage('assets/img/F_Promotion_01.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/F_Promotion_01.png', width: _iconSize, height: _iconSize,
                fit: BoxFit.scaleDown),
            title: Text(S.current.promotions, style: TextStyle(color: DmConst.accentColor)),
          ),

          Container(
            width: double.infinity,
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(S.current.domainDmart, style: Theme.of(context).textTheme.headline5),
            ),
          ),

          ListTile(
            onTap: () => RouteGenerator.gotoContactUs(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Contact_us.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Contact_us.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.current.contactUs, style: TextStyle(color: DmConst.accentColor)),
          ),
          Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(Icons.help_outline, color: DmConst.accentColor),
            title: Text(S.current.help, style: TextStyle(color: DmConst.accentColor)),
          ),
          Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
          ListTile(
            onTap: () {
              print('---------PRESS ON KHMER');


              setState(() {
                settingRepo.setDefaultLanguage(Language.khmer.code);
                S.load(Locale.fromSubtags(languageCode: 'fr'));
              });


//            AppLocalization
            },
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Cambodia.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Flag_Cambodia.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.current.langKhmer, style: TextStyle(color: DmConst.accentColor)),
          ),
          Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
          ListTile(
            onTap: () {
              print('---------PRESS ON ENGLISH');

              setState(() {
                settingRepo.setDefaultLanguage(Language.english.code);
                S.load(Locale.fromSubtags(languageCode: 'en'));
              });


            },
//            leading: ImageIcon(AssetImage('assets/img/M_Flag_Eng.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Flag_Eng.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.current.langEnglish, style: TextStyle(color: DmConst.accentColor)),
          ),
          Divider(height: 1,thickness: 1, color: Colors.grey.shade400),
          ListTile(
            onTap: () {
              RouteGenerator.gotoLogin(context);
            },
            leading: Image.asset('assets/img/H_User_Icon.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.current.login, style: TextStyle(color: DmConst.accentColor)),
          ),
          setting.value.enableVersion
              ? ListTile(
            dense: true,
            title: Text('${S.current.version} ${setting.value.appVersion}', style: TextStyle(color: DmConst.accentColor)),
            trailing: Icon(Icons.remove, color: Theme.of(context).focusColor.withOpacity(0.3)),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  void onPressOnKhmer() {
    print('---------PRESS ON KHMER');
    setState(() {
//      DmState.isKhmer = true;
      settingRepo.setDefaultLanguage(Language.khmer.code);
      S.load(Locale.fromSubtags(languageCode: Language.khmer.code));
    });
  }

  void onPressOnEnglish() {
    print('---------PRESS ON ENGLISH');

    setState(() {
//      DmState.isKhmer = false;

      settingRepo.setDefaultLanguage(Language.english.code);
      S.load(Locale.fromSubtags(languageCode: Language.english.code));
    });
  }
}

