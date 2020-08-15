

import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:dmart/src/widgets/CategoryGridWidget.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DmCategoriesWidget.dart';
import 'package:dmart/src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
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



class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage = HomeWidget();

  PagesWidget({
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
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
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
          //TODO must be promotions Widget
          widget.currentPage = FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;

        case 4:
          //TODO must be Menu(personal)Widget
          widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
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
        appBar: createAppBar(),
        drawer: DrawerWidget(),

        endDrawer: FilterWidget(onFilter: (filter) {
          Navigator.of(context).pushReplacementNamed('/Pages',
              arguments: widget.currentTab);
        }),
        body: widget.currentPage,
//        bottomNavigationBar: _bottomBar(),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: widget.currentTab,
        onTap: this._selectTab),
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
                child: Text('$title',
                    textAlign: TextAlign.right),
              )),
        ),
      ],
    );
  }

  PreferredSize createAppBar(){
    User user = currentUser.value;
    return PreferredSize(
      preferredSize: Size.fromHeight(110),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

//          centerTitle: true,
//          title: Column(
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//
//                Expanded(
//                  child: Row(
//                    children: <Widget>[
//                      CircleAvatar(
//                        backgroundColor: Colors.transparent,
//                        backgroundImage: AssetImage('assets/img/H_User_Icon.png'),
////                child: Image.asset('assets/img/H_User_Icon.png',
////                    width: 80,
////                    fit: BoxFit.scaleDown),
//                      ),
//                      Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                        Text('Username'),
//                        Text('Credit'),
//                      ],),
//                    ],
//                  ),
//                ),
//                Container(
//                  child: Image.asset(
//                    'assets/img/H_Logo_Dmart.png',
//                    width: 44, height: 44,
//                    fit: BoxFit.scaleDown,
//                  ),
//                ),
//                  Expanded(
//                    child: Align(
//                      alignment: Alignment.centerRight,
//                      child: Container(
//                        padding: EdgeInsets.only(right: 30),
//                        height: 40,
//                        child: Image.asset('assets/img/H_Cart.png',
//                            fit: BoxFit.scaleDown),
//                      ),
//                    ),
//                  ),
//              ],),
////              Divider(thickness: 2, color: DmConst.primaryColor)
//            ],
//          ),
//          bottom: PreferredSize(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: SearchBarWidget( onClickFilter: (event) {
//                  widget.parentScaffoldKey.currentState.openEndDrawer();
//                }),
//              ),
//              preferredSize: Size.fromHeight(40)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: this._createUserInfoRowOnTopBar(user),
                  ),
                  Container(
                    child: Image.asset(
                      'assets/img/H_Logo_Dmart.png',
                      width: 46,
                      height: 46,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        height: 40,
                        child: Image.asset('assets/img/H_Cart.png',
                            fit: BoxFit.scaleDown),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 4, thickness: 2, color: DmConst.primaryColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                child: SearchBarWidget(onClickFilter: (event) {
                  widget.scaffoldKey.currentState.openEndDrawer();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createUserInfoRowOnTopBar(User user){
    if(user.isLogin) {
      return Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(user.image?.thumb,
              loadingBuilder: (ctx, wid, event) {
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (ctx, obj, trace) {
                return Image.asset('assets/img/H_User_Icon.png',
                    width: 40, height: 40, fit: BoxFit.scaleDown);
              },
            ),
//            Image.asset('assets/img/H_User_Icon.png',
//                width: 40, height: 40, fit: BoxFit.scaleDown),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user.name?? S.of(context).unknown),
              Text('${S.of(context).topBar_credit}: ${currentUser.value.credit}',
                  style: TextStyle(color: DmConst.textColorForTopBarCredit)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/img/H_User_Icon.png',
                width: 40, height: 40, fit: BoxFit.scaleDown),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).guest),
              Text('${S.of(context).topBar_credit}:'),
            ],
          ),
        ],
      );
    }
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
                  BoxShadow(
                      color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
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
