import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/widgets/DrawerWidget.dart';

abstract class ProductStateMVC<T extends StatefulWidget>
    extends StateMVC<StatefulWidget> with SingleTickerProviderStateMixin {
  Animation animationOpacity;
  AnimationController animationController;

  ProductController proCon;
  final ScrollController _scrollCon = ScrollController();
  bool isLoading = false, canLoadMore = true;
  static const double _endReachedThreshold = 100;
  final int bottomIdx;
  ProductStateMVC({
    @required this.bottomIdx,
  }) : super(new ProductController()) {
    proCon = controller;
  }

  @override
  void initState() {
    _scrollCon.addListener(_onScroll);

    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();

    super.initState();
  }

  void dispose() {
    animationController.dispose();
    _scrollCon.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (!_scrollCon.hasClients || isLoading || !canLoadMore) return;
    final thresholdReached =
        _scrollCon.position.extentAfter < _endReachedThreshold;
    if (thresholdReached) {
      isLoading = true;
      await loadMore();
      isLoading = false;
    }
  }

  String getTitle(BuildContext context);

  void loadMore();

  Future<void> _refresh() async {
    isLoading = true;
    onRefresh();
    isLoading = false;
    canLoadMore = true;
  }

  Future<void> onRefresh();

//  Widget buildContent(BuildContext context);
  Widget buildContent(BuildContext context) {
    if (this.lstProducts == null) {
      return ProductsGridViewLoading(isList: true);
    } else if (this.lstProducts.isEmpty) {
      return EmptyDataLoginWid(message: S.current.productListEmpty);
    } else {
      return FadeTransition(
          opacity: this.animationOpacity,
          child: ValueListenableBuilder(
              valueListenable: this.filterNotifier,
              builder: (context, filter, widget) {
                var filteredProducts = doFilter(
                    products: lstProducts, conditions: filterNotifier.value);
                if (DmUtils.isNullOrEmptyList(filteredProducts)) {
                  return EmptyDataLoginWid(
                      message: S.current.filteredProductListEmpty);
                } else {
                  return ProductGridView(
                      products: filteredProducts, heroTag: '');
                }
              }));
    }
  }

  ValueNotifier<FilterCondition> filterNotifier =
      ValueNotifier(FilterCondition());

  List<Product> get lstProducts;

//  List<Product> get filteredProducts => doFilter(products: lstProducts, conditions: filterNotifier.value);

  List<Product> doFilter({List<Product> products, FilterCondition conditions}) {
    List<Product> re = [];
    if (products == null) return re;
    products.forEach((p) {
      if (p.match(conditions)) {
        re.add(p);
      }
    });
    if (conditions.isPriceUp != null) {
      re.sort(conditions.isPriceUp
          ? Product.priceComparatorUp
          : Product.priceComparatorDown);
    }

    if (conditions.isLatest != null) {
      re.sort(conditions.isLatest
          ? Product.dateComparatorDown
          : Product.dateComparatorUp);
    }
    return re;
  }

  Widget _buildFilter(BuildContext context) {
    return FilterWidget(
        products: lstProducts, filterNotifier: this.filterNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: bottomIdx),
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(
          products: lstProducts, filterNotifier: this.filterNotifier),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollCon,
            slivers: <Widget>[
              createSliverTopBar(context),
              createSliverSearch(context),
              createSilverTopMenu(context,
                  haveBackIcon: true, haveFilter: true, title: getTitle(context)),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      padding:
                          const EdgeInsets.all(DmConst.masterHorizontalPad),
                      child: buildContent(context)),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
