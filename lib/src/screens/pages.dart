import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DmCategoriesWidget.dart';
import 'package:dmart/src/widgets/BottomRightMenu.dart';
import 'package:dmart/src/widgets/DmPromotionGroupsWidget.dart';
import 'package:dmart/src/widgets/SearchBar.dart';
import 'package:flutter/material.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../Widgets/DrawerWidget.dart';
import '../widgets/FilterWidget.dart';
import '../models/route_argument.dart';
import '../screens/home.dart';
import '../screens/account.dart';
import '../screens/notifications.dart';
import '../screens/orders.dart';
import '../screens/favorites.dart';
import '../../src/helpers/ui_icons.dart';

class PagesScreen extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage = HomeWidget();

  PagesScreen({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _PagesScreenState createState() {
    return _PagesScreenState();
  }
}

class _PagesScreenState extends State<PagesScreen> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesScreen oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;

        case 1:
          //TODO must be CategoriesWidget
//          widget.currentPage = AccountWidget(parentScaffoldKey: widget.scaffoldKey);
//          break;
          widget.currentPage = DmCategoriesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
//          widget.currentPage = FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          widget.currentPage = DmPromotionGroupsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;

        case 4:
          //TODO must be Menu(personal)Widget
          widget.currentPage = BottomRightMenu(parentScaffoldKey: widget.scaffoldKey);
//          widget.scaffoldKey.currentState.openDrawer();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: widget.scaffoldKey,
        appBar: createAppBar(context, widget.scaffoldKey),
        drawer: DrawerWidget(),

        endDrawer: FilterWidget(onFilter: (filter) {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: widget.currentTab);
        }),
        body: widget.currentPage,
//        bottomNavigationBar: _bottomBar(),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: widget.currentTab, onTap: this._selectTab),
      ),
    );
  }

  Widget _createHeader(String title) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: DmConst.homePromotionColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$title', textAlign: TextAlign.right),
              )),
        ),
      ],
    );
  }

  Widget _bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).accentColor,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      iconSize: 22,
      elevation: 0,
      backgroundColor: Colors.transparent,
      selectedIconTheme: IconThemeData(size: 25),
      unselectedItemColor: Theme.of(context).hintColor.withOpacity(1),
      currentIndex: widget.currentTab,
      onTap: (int i) {
        this._selectTab(i);
      },
      // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          icon: Icon(UiIcons.bell),
          title: new Container(height: 0.0),
        ),
        BottomNavigationBarItem(
          icon: Icon(UiIcons.user_1),
          title: new Container(height: 0.0),
        ),
        BottomNavigationBarItem(
            title: new Container(height: 5.0),
            icon: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                  BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                ],
              ),
              child: new Icon(UiIcons.home, color: Theme.of(context).primaryColor),
            )),
        BottomNavigationBarItem(
          icon: new Icon(UiIcons.inbox),
          title: new Container(height: 0.0),
        ),
        BottomNavigationBarItem(
          icon: new Icon(UiIcons.heart),
          title: new Container(height: 0.0),
        ),
      ],
    );
  }
}
