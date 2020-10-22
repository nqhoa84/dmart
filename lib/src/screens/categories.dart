import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/category_controller.dart';
import '../../src/widgets/DrawerWidget.dart';

class CategoriesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool canBack;

  CategoriesScreen({
    Key key, this.canBack = false
  }) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends StateMVC<CategoriesScreen> {
  CategoryController _con;

  _CategoriesScreenState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
//    _con.listenForCategories();
    super.initState();
  }

  Widget buildContent(BuildContext context) {
    if (_con.categories.isEmpty)  {
      return NameImageItemGridViewLoading();
    } else
    {
      return NameImageItemGridView(items: _con.categories);
//      CategoriesGrid(parentScaffoldKey: widget.scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: 1),
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(onFilter: (Filter f) {
        print('selected filter: $f');
      }),
      endDrawerEnableOpenDragGesture: true,
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          createSliverSearch(context),
          createSilverTopMenu(context, haveBackIcon: widget.canBack, title: S.of(context).categories),
          SliverList(
            delegate: SliverChildListDelegate([
              buildContent(context),
              ]),
          )
        ]),
      ),
    );
  }
}
