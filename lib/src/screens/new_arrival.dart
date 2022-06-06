import 'package:dmart/DmState.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../src/models/route_argument.dart';
import 'abs_product_mvc.dart';

class NewArrivalsScreen extends StatefulWidget {
  RouteArgument? routeArgument;

  NewArrivalsScreen({Key? key, RouteArgument? argument}) {
    this.routeArgument = argument;
//    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _NewArrivalsScreenState createState() => _NewArrivalsScreenState();
}

class _NewArrivalsScreenState extends ProductStateMVC<NewArrivalsScreen> {
  _NewArrivalsScreenState() : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForNewArrivals();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return S.current.newArrival;
  }

  @override
  Future<void> onRefresh() async {
    proCon.newArrivalProducts!.clear();
    proCon.listenForNewArrivals();
    canLoadMore = true;
  }

  @override
//  Widget buildContent(BuildContext context) {
//    if (proCon.newArrivalProducts.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
//    } else {
//      return FadeTransition(
//          opacity: this.animationOpacity,
//          child: ValueListenableBuilder(
//              valueListenable: this.filterNotifier,
//              builder: (context, filter, widget) {
////                List<Product> ftPros = filter.haveCondition ?
////                doFilter(products: proCon.newArrivalProducts, conditions: filter)
////                    : proCon.newArrivalProducts;
//
//                return ProductGridView(products: filteredProducts, heroTag: 'newArrivals');
//              }));
//    }
//  }

  @override
  Future<void> loadMore() async {
    int pre = proCon.newArrivalProducts != null
        ? proCon.newArrivalProducts!.length
        : 0;
    await proCon.listenForNewArrivals(nextPage: true);
    canLoadMore = proCon.newArrivalProducts!.length > pre;
  }

  @override
  List<Product> get lstProducts => proCon.newArrivalProducts!;
}
