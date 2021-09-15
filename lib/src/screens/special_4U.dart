import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
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
    return S.current.specialForYou;
  }

  @override
  Future<void> onRefresh() async {
    proCon.special4UProducts?.clear();
    proCon.listenForSpecial4U();
    canLoadMore = true;
  }

//  @override
//  Widget buildContent(BuildContext context) {
//    if (proCon.special4UProducts.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
//    } else {
////      print('_con.special4UProducts ${proCon.special4UProducts.length}');
//      return FadeTransition(
//        opacity: this.animationOpacity,
//        child: ProductGridView(products: proCon.special4UProducts, heroTag: 'spe4U'),
//      );
//    }
//  }

  @override
  Future<void> loadMore() async {
//    print('loadMore on Spec4U');
    int pre = proCon.special4UProducts != null ? proCon.special4UProducts.length : 0;
    await proCon.listenForSpecial4U(nextPage: true);
    canLoadMore = proCon.special4UProducts != null && proCon.special4UProducts.length > pre;
  }

  @override
  List<Product> get lstProducts => proCon.special4UProducts;
}
