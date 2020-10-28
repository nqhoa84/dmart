import 'package:dmart/DmState.dart';
import 'package:dmart/route_generator.dart';

import '../helpers/ui_icons.dart';
import 'package:flutter/material.dart';

class DmBottomNavigationBar extends StatelessWidget {
  int currentIndex;
  Function(int i) onTap;

  DmBottomNavigationBar({this.currentIndex, this.onTap, Key key}) : super(key: key) {
    if(currentIndex == null) {
      currentIndex = DmState.bottomBarSelectedIndex;
    } else {
      DmState.bottomBarSelectedIndex = currentIndex;
    }

  }

  void _defaultOnTap(int selectedIndex, BuildContext context) {
    if(selectedIndex == DmState.bottomBarSelectedIndex) {
      return;
    } else {
      DmState.bottomBarSelectedIndex = selectedIndex;
      if(selectedIndex == 0) {
        RouteGenerator.gotoHome(context);
      } else if(selectedIndex == 1) {
        RouteGenerator.gotoCategories(context);
      } else if(selectedIndex == 2) {
        RouteGenerator.gotoPromotions(context);
      } else if(selectedIndex == 3) {
        RouteGenerator.gotoNotifications(context);
      } else if(selectedIndex == 4) {
        RouteGenerator.gotoMenu(context);
      } else {
        RouteGenerator.gotoHome(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = 40.0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.symmetric(vertical: BorderSide(color: Theme.of(context).accentColor)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
//        selectedItemColor: Theme.of(context).accentColor,
//      unselectedItemColor: Colors.transparent,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 22,
        elevation: 0,
        backgroundColor: Colors.transparent,

//      selectedIconTheme: IconThemeData(size: 25),
//        unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
//        currentIndex: currentIndex != null ? currentIndex : DmState.bottomBarSelectedIndex,
        currentIndex: currentIndex,
        onTap: onTap != null ? onTap : (int i) {_defaultOnTap (i, context);},
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
//          icon: currentIndex == 0 ? ImageIcon( new AssetImage("assets/img/F_Home_01.png")) :
//          ImageIcon( new AssetImage("assets/img/F_Home.png")),
            icon: currentIndex == 0
                ? Image.asset('assets/img/F_Home_01.png', width: size, fit: BoxFit.scaleDown)
                : Image.asset('assets/img/F_Home.png', width: size, fit: BoxFit.scaleDown),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Image.asset("assets/img/F_Categories_01.png", width: size, fit: BoxFit.scaleDown)
                : Image.asset("assets/img/F_Categories.png", width: size, fit: BoxFit.scaleDown),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? Image.asset("assets/img/F_Promotion_01.png", width: size * 1.15, fit: BoxFit.scaleDown)
                : Image.asset("assets/img/F_Promotion.png", width: size * 1.15, fit: BoxFit.scaleDown),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Image.asset("assets/img/F_Notificaiton_01.png", width: size, fit: BoxFit.scaleDown)
                : Image.asset("assets/img/F_Notificaiton.png", width: size, fit: BoxFit.scaleDown),
            title: new Container(height: 0.0),
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 4
                ? Image.asset("assets/img/F_Menu_01.png", width: size, fit: BoxFit.scaleDown)
                : Image.asset("assets/img/F_Menu.png", width: size, fit: BoxFit.scaleDown),
            title: new Container(height: 0.0),
          ),
        ],
      ),
    );
  }
}
