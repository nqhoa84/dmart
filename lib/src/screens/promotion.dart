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
