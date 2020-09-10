import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsByCategory.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../repository/user_repository.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/FavoriteGridItemWidget.dart';
import '../widgets/FavoriteListItemWidget.dart';
import '../widgets/PermissionDenied.dart';
import '../widgets/SearchBar.dart';
import 'abs_product_mvc.dart';

class Special4UScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Special4UScreen({Key key}) : super(key: key);

  @override
  _Special4UScreenState createState() => _Special4UScreenState();
}

class _Special4UScreenState extends ProductStateMVC<Special4UScreen> {
  _Special4UScreenState() : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForSpecial4U();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return S.of(context).specialForYou;
  }

  @override
  Future<void> onRefresh() async {
    proCon.special4UProducts?.clear();
    proCon.listenForSpecial4U();
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (proCon.special4UProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
      print('_con.special4UProducts ${proCon.special4UProducts.length}');
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: proCon.special4UProducts, heroTag: 'spe4U'),
      );
    }
  }

  @override
  void loadMore() {
    print('loadMore on Spec4U');
    int pre = proCon.special4UProducts != null ? proCon.special4UProducts.length : 0;
    proCon.listenForSpecial4U(nextPage: true);
    canLoadMore = proCon.special4UProducts != null && proCon.special4UProducts.length > pre;
  }
}

class _Special4UScreenStateOld extends StateMVC<Special4UScreen> {
  ProductController _con;

  _Special4UScreenStateOld() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForSpecial4U();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    if (_con.special4UProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
      print('_con.newArrivalProducts ${_con.special4UProducts.length}');
      return ProductGridView(products: _con.special4UProducts, heroTag: 'spe4U');
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
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          createSliverSearch(context),
          createSilverTopMenu(
            context, haveBackIcon: true, title: S.of(context).specialForYou,
//              types: [ProductType()],
//              cates: [Category()],
//              sorts: [SortBy.nameAsc],
//              brands: [Brand()]
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildContent(context),
//              ProductsByCategory(category: widget._category),
//              Text('this is the best sale screen')
            ]),
          )
        ]),
      ),
    );
  }
}
