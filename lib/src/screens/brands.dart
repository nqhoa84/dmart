import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';

import '../../buidUI.dart';
import '../../src/controllers/brand_controller.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import '../../generated/l10n.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/widgets/BrandGridWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/SearchBar.dart';
import '../../src/widgets/ShoppingCartButton.dart';
import 'package:flutter/material.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class BrandsWidget extends StatefulWidget {
  const BrandsWidget({
    Key key,
  }) : super(key: key);

  @override
  _BrandsWidgetState createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends StateMVC<BrandsWidget> {
  BrandController _con;

  _BrandsWidgetState() : super(BrandController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForBrands();
    super.initState();
  }

  Widget buildContent(BuildContext context) {
    if (_con.brands.isEmpty)  {
      return CategoriesGridLoading();
    } else
    {
      return CategoriesGridView(categories: _con.brands);
//      CategoriesGrid(parentScaffoldKey: widget.scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
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
          createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).brands),
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
