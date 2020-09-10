import 'package:dmart/DmState.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/PromotionGroups.dart';
import 'package:flutter/material.dart';

import '../../buidUI.dart';
import '../Widgets/DrawerWidget.dart';
import '../models/route_argument.dart';
import '../screens/home.dart';
import '../widgets/FilterWidget.dart';

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

  void _selectTab(int tabIndex) {
    setState(() {
      DmState.bottomBarSelectedIndex = tabIndex;
      widget.currentTab = tabIndex;
      switch (tabIndex) {
        case 0:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;

        case 1:
//          widget.currentPage = AccountWidget(parentScaffoldKey: widget.scaffoldKey);
//          break;
          widget.currentPage = CategoriesGrid(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
//          widget.currentPage = FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          widget.currentPage = PromotionGroups(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
//          widget.currentPage = NotificationsScreen(parentScaffoldKey: widget.scaffoldKey);
          break;

        case 4:
//          widget.currentPage = BottomRightMenMenu();
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
//        appBar: createAppBar(context, widget.scaffoldKey),
//        appBar: DmAppBar(),
        drawer: DrawerWidget(),
        endDrawer: FilterWidget(onFilter: (filter) {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: widget.currentTab);
        }),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: widget.currentTab, onTap: this._selectTab),
        body: SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            SliverList(
              delegate: SliverChildListDelegate([
                widget.currentPage,
              ]),
            )
          ]),
        ),
      ),
    );
  }
}


