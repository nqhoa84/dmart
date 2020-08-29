//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/controllers/promotion_controller.dart';
import 'package:dmart/src/models/promotion.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/repository/user_repository.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/CategoryHomeTabWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByCategory.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromotionScreen extends StatefulWidget {
  RouteArgument routeArgument;
  Promotion _category;

  PromotionScreen({Key key, this.routeArgument}) {
    _category = this.routeArgument.param[0] as Promotion;
  }

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends StateMVC<PromotionScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProductController _con;

//  ProductController _pCon = ProductController();
  _PromotionScreenState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForPromoProducts(widget._category.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, _scaffoldKey),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: <Widget>[
        createSilverAppBar(context, haveBackIcon: true, title: widget._category?.name),
        SliverList(
          delegate: SliverChildListDelegate([
//            ProductsByCategory(category: widget._category)
            _con.promotionProducts.isNotEmpty
            ? createGridViewOfProducts(context, _con.promotionProducts, heroTag: '${widget.routeArgument.heroTag}')
                : Center(child: CircularProgressIndicator())
          ]),
        )
      ]),
    );
  }
}
