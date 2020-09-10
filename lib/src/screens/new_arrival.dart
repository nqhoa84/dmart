import 'package:dmart/DmState.dart';
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
      print('_con.newArrivalProducts ${proCon.newArrivalProducts.length}');
      return FadeTransition(
          opacity: this.animationOpacity,
          child: ProductGridView(products: proCon.newArrivalProducts, heroTag: 'newArrivals'),);
    }
  }

  @override
  void loadMore() {
    int pre = proCon.newArrivalProducts != null ? proCon.newArrivalProducts.length : 0;
    proCon.listenForNewArrivals(nextPage: true);
    canLoadMore = proCon.newArrivalProducts != null
        && proCon.newArrivalProducts.length > pre;
  }
}

class _NewArrivalsScreenStateOld extends StateMVC<NewArrivalsScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollCon = ScrollController();
  bool _isLoading = false, _canLoadMore = true;
  static const double _endReachedThreshold = 100;

  ProductController _con;

  _NewArrivalsScreenStateOld() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForNewArrivals();
    _scrollCon.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!_scrollCon.hasClients || _isLoading || !_canLoadMore) return; // Chỉ chạy những dòng dưới nếu như controller đã được mount vào widget và đang không loading

    final thresholdReached = _scrollCon.position.extentAfter < _endReachedThreshold; // Check xem đã đạt tới _endReachedThreshold chưa

    if (thresholdReached) {
      _isLoading = true;
      int preLen = _con.newArrivalProducts.length;
      _con.listenForNewArrivals(nextPage: true);

      _canLoadMore = _con.newArrivalProducts.length > preLen;
      _isLoading = false;
    }
  }

  void dispose() {
    _scrollCon.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _isLoading = true;
    _canLoadMore = true;
    _con.newArrivalProducts?.clear();
    _con.listenForNewArrivals();
    _isLoading = false;
  }

  Widget buildContent(BuildContext context) {
    if (_con.newArrivalProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
      print('_con.newArrivalProducts ${_con.newArrivalProducts.length}');
      return ProductGridView(products: _con.newArrivalProducts, heroTag: 'newArrivals');
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
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollCon,
            slivers: <Widget>[
              createSliverTopBar(context),
              createSliverSearch(context),
              createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).newArrival),
              SliverList(
                delegate: SliverChildListDelegate([
                  buildContent(context),
//              ProductsByCategory(category: widget._category),
//              Text('this is the best sale screen')
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
