import 'package:dmart/DmState.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/brand_controller.dart';
import '../../src/widgets/DrawerWidget.dart';

class BrandsWidget extends StatefulWidget {
  const BrandsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _BrandsWidgetState createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends StateMVC<BrandsWidget> {
  BrandController _con = BrandController();

  _BrandsWidgetState() : super(BrandController()) {
    _con = controller as BrandController;
  }

  @override
  void initState() {
    _con.listenForBrands();
    super.initState();
  }

  Widget buildContent(BuildContext context) {
    if (_con.brands!.isEmpty) {
      return NameImageItemGridViewLoading();
    } else {
      return CategoriesGridView(items: _con.brands!);
//      CategoriesGrid(parentScaffoldKey: widget.scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
//      endDrawer: FilterWidget(onFilter: (Filter f) {
//        print('selected filter: $f');
//      }),
      endDrawerEnableOpenDragGesture: true,
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          createSliverSearch(context),
          createSilverTopMenu(context,
              haveBackIcon: true, title: S.current.brands),
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
