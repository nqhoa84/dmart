import 'package:dmart/DmState.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/models/promotion.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/DrawerWidget.dart';
import 'abs_product_mvc.dart';

class PromotionScreen extends StatefulWidget {
  RouteArgument routeArgument;
  Promotion promotion;

  PromotionScreen({Key key, this.routeArgument}) {
    promotion = this.routeArgument.param[0] as Promotion;
  }

  @override
  _PromotionScreenState createState() => _PromotionScreenState(promo: promotion);
}

class _PromotionScreenState extends ProductStateMVC<PromotionScreen> {
  Promotion promo;
  _PromotionScreenState({this.promo}) : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForPromoProducts(promo.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return '${promo?.name}';
  }

  @override
  Future<void> onRefresh() async {
    proCon.promotionProducts?.clear();
    proCon.listenForPromoProducts(promo.id);
    canLoadMore = true;
  }

//  @override
//  Widget buildContent(BuildContext context) {
//    if (proCon.promotionProducts.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
//    } else {
//      return FadeTransition(
//        opacity: this.animationOpacity,
//        child: ProductGridView(products: proCon.promotionProducts, heroTag: 'promo.${promo.id}'),
//      );
//    }
//  }

  @override
  Future<void> loadMore() async {
    int pre = proCon.promotionProducts != null ? proCon.promotionProducts.length : 0;
    await proCon.listenForPromoProducts(promo.id, nextPage: true);
    canLoadMore = proCon.promotionProducts != null && proCon.promotionProducts.length > pre;
  }

  @override
  List<Product> get lstProducts => proCon.promotionProducts;
}

class _PromotionScreenStateOld extends StateMVC<PromotionScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProductController _con;

//  ProductController _pCon = ProductController();
  _PromotionScreenStateOld() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForPromoProducts(widget.promotion.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    return _con.promotionProducts.isNotEmpty
        ? createGridViewOfProducts(context, _con.promotionProducts,
        heroTag: '${widget.routeArgument.heroTag}')
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, _scaffoldKey),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: <Widget>[
        createSilverTopMenu(context, haveBackIcon: true, title: widget.promotion?.name),
        SliverList(
          delegate: SliverChildListDelegate([
            buildContent(context),
//            ProductsByCategory(category: widget._category)

          ]),
        )
      ]),
    );
  }
}
