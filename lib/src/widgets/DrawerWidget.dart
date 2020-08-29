import 'package:dmart/src/models/language.dart';
import 'package:dmart/src/widgets/BottomRightMenu.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../../constant.dart';
import '../../route_generator.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.isLogin
                  ? Navigator.of(context).pushNamed('/Pages', arguments: 1)
                  : RouteGenerator.gotoLogin(context);
            },
            child: currentUser.value.isLogin
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1)
                    ),
                    accountName: Text(
                      currentUser.value.name,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    accountEmail: Text(
                      currentUser.value.email,
                      style: Theme.of(context).textTheme.caption
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      backgroundImage: NetworkImage(currentUser.value.image.thumb),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(0.1),
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 32,
                          color: Theme.of(context).accentColor.withOpacity(1)
                        ),
                        SizedBox(width: 30),
                        Text(
                          S.of(context).guest,
                          style: Theme.of(context).textTheme.headline6
                        ),
                      ],
                    ),
                  ),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(S.of(context).groceries1, style: Theme.of(context).textTheme.headline5),
            ),
          ),
          ListTile(
//            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            onTap: () => RouteGenerator.gotoHome(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Shop_All_Groceries.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Shop_All_Groceries.png', width: _iconSize, height: _iconSize,
                fit: BoxFit.scaleDown),
            title: Text(S.of(context).shopAllGroceries),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoPromotions(context),
//            leading: ImageIcon(AssetImage('assets/img/F_Promotion_01.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/F_Promotion_01.png', width: _iconSize, height: _iconSize,
                fit: BoxFit.scaleDown),
            title: Text(S.of(context).promotions),
          ),
          ListTile(
            onTap: () => RouteGenerator.gotoMyFavorites(context),
//            leading: Icon(UiIcons.favorites, color: DmConst.primaryColor),
            leading: Image.asset('assets/img/Favourite.png', width: _iconSize, height: _iconSize,
                fit: BoxFit.scaleDown),
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
            title: Text(S.of(context).myOrders),
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
            onTap: () => RouteGenerator.gotoContactUs(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Contact_us.png'), color: DmConst.primaryColor),
            leading: Image.asset('assets/img/M_Contact_us.png', width: _iconSize, fit: BoxFit.scaleDown),
            title: Text(S.of(context).contactUs),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(Icons.help_outline, color: DmConst.accentColor),
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

  double _iconSize = 25;
  Widget buildMenu() {
    return ListView(
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
//            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          onTap: () => RouteGenerator.gotoHome(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Shop_All_Groceries.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Shop_All_Groceries.png', width: _iconSize, height: _iconSize,
              fit: BoxFit.scaleDown),
          title: Text(S.of(context).shopAllGroceries),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoPromotions(context),
//            leading: ImageIcon(AssetImage('assets/img/F_Promotion_01.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/F_Promotion_01.png', width: _iconSize, height: _iconSize,
              fit: BoxFit.scaleDown),
          title: Text(S.of(context).promotions),
        ),
        ListTile(
          onTap: () => RouteGenerator.gotoMyFavorites(context),
//            leading: Icon(UiIcons.favorites, color: DmConst.primaryColor),
          leading: Image.asset('assets/img/Favourite.png', width: _iconSize, height: _iconSize,
              fit: BoxFit.scaleDown),
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
          title: Text(S.of(context).myOrders),
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
          onTap: () => RouteGenerator.gotoContactUs(context),
//            leading: ImageIcon(AssetImage('assets/img/M_Contact_us.png'), color: DmConst.primaryColor),
          leading: Image.asset('assets/img/M_Contact_us.png', width: _iconSize, fit: BoxFit.scaleDown),
          title: Text(S.of(context).contactUs),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/Help');
          },
          leading: Icon(Icons.help_outline, color: DmConst.accentColor),
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
    );
  }
  Widget _build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentUser.value.isLogin
                  ? Navigator.of(context).pushNamed('/Pages', arguments: 1)
                  : RouteGenerator.gotoLogin(context);
            },
            child: currentUser.value.apiToken != null
                ? UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).hintColor.withOpacity(0.1)
              ),
              accountName: Text(
                currentUser.value.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              accountEmail: Text(
                  currentUser.value.email,
                  style: Theme.of(context).textTheme.caption
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: NetworkImage(currentUser.value.image.thumb),
              ),
            )
                : Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                      Icons.person,
                      size: 32,
                      color: Theme.of(context).accentColor.withOpacity(1)
                  ),
                  SizedBox(width: 30),
                  Text(
                      S.of(context).guest,
                      style: Theme.of(context).textTheme.headline6
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              UiIcons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              UiIcons.bell,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).notifications,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            leading: Icon(
              UiIcons.inbox,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).myOrders,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 4);
            },
            leading: Icon(
              UiIcons.heart,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).favoriteProducts,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Categories');
            },
            leading: Icon(
              UiIcons.folder_1,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).categories,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Brands');
            },
            leading: Icon(
              UiIcons.folder_1,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).brands,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            dense: true,
            title: Text('application_preferences',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              UiIcons.information,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).helpAndSupports,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Settings');
              } else {
                Navigator.of(context).pushReplacementNamed('/Login');
              }
            },
            leading: Icon(
              UiIcons.settings_1,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              UiIcons.planet_earth,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (Theme.of(context).brightness == Brightness.dark) {
                setBrightness(Brightness.light);
                DynamicTheme.of(context).setBrightness(Brightness.light);
              } else {
                setBrightness(Brightness.dark);
                DynamicTheme.of(context).setBrightness(Brightness.dark);
              }
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark ? 'light_mode' : 'dark_mode',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                logout().then((value) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/Pages', (Route<dynamic> route) => false, arguments: 2);
                });
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              currentUser.value.apiToken != null ? S.of(context).logout : S.of(context).login,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          currentUser.value.apiToken == null
              ? ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/SignUp');
            },
            leading: Icon(
              Icons.person_add,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).register,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          )
              : SizedBox(height: 0),
          setting.value.enableVersion
              ? ListTile(
            dense: true,
            title: Text(
              S.of(context).version + " " + setting.value.appVersion,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }
}
