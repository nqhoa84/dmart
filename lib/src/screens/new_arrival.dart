import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/DrawerWidget.dart';
import 'abs_product_mvc.dart';

class NewArrivalsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  RouteArgument routeArgument;

  NewArrivalsScreen({Key key, RouteArgument argument}) {
    this.routeArgument = argument;
//    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _NewArrivalsScreenState createState() => _NewArrivalsScreenState();
}

class _NewArrivalsScreenState extends ProductStateMVC<NewArrivalsScreen>
{
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
    return S.of(context).newArrival;
  }

  @override
  Future<void> onRefresh() async{
    proCon.newArrivalProducts?.clear();
    proCon.listenForNewArrivals();
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (proCon.newArrivalProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
      return FadeTransition(
          opacity: this.animationOpacity,
          child: ProductGridView(products: proCon.newArrivalProducts, heroTag: 'newArrivals'),);
    }
  }

  @override
  Future<void> loadMore() async {
    int pre = proCon.newArrivalProducts != null ? proCon.newArrivalProducts.length : 0;
    await proCon.listenForNewArrivals(nextPage: true);
    canLoadMore = proCon.newArrivalProducts != null
        && proCon.newArrivalProducts.length > pre;
  }
}
