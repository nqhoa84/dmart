import 'package:dmart/DmState.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/DrawerWidget.dart';
import 'abs_product_mvc.dart';

class BestSaleScreen extends StatefulWidget {
  RouteArgument routeArgument;

//  Category _category;

  BestSaleScreen({Key key, RouteArgument argument}) {
    this.routeArgument = argument;
//    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _BestSaleScreenState createState() => _BestSaleScreenState();
}

class _BestSaleScreenState extends ProductStateMVC<BestSaleScreen> {
  _BestSaleScreenState() : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForBestSaleProducts();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return S.of(context).bestSale;
  }

  @override
  Future<void> onRefresh() async {
    proCon.bestSaleProducts?.clear();
    proCon.listenForBestSaleProducts();
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (proCon.bestSaleProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
      print('_con.bestSaleProducts ${proCon.bestSaleProducts.length}');
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: proCon.bestSaleProducts, heroTag: 'bestSale'),
      );
    }
  }

  @override
  void loadMore() {
    int pre = proCon.bestSaleProducts != null ? proCon.bestSaleProducts.length : 0;
    proCon.listenForBestSaleProducts(nextPage: true);
    canLoadMore = proCon.bestSaleProducts != null && proCon.bestSaleProducts.length > pre;
  }
}


class _BestSaleScreenStateOld extends StateMVC<BestSaleScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ProductController _con;

  _BestSaleScreenStateOld() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForBestSaleProducts();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    if (_con.bestSaleProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
      print('_con.bestSaleProducts ${_con.bestSaleProducts.length}');
      return ProductGridView(products: _con.bestSaleProducts, heroTag: 'bestSale');
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
            context, haveBackIcon: true, title: S.of(context).bestSale,
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
