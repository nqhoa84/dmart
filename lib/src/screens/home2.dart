import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../../src/widgets/HomeProductsByCategory.dart';
import '../../src/widgets/HomePromotionsSlider.dart';
import '../../src/widgets/ProductsGridViewLoading.dart';

class Home2Screen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _Home2ScreenState createState() => _Home2ScreenState();
}

class _Home2ScreenState extends StateMVC<Home2Screen> with SingleTickerProviderStateMixin {
  Animation animationOpacity;
  AnimationController animationController;
  ProductController _con;

  _Home2ScreenState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForBestSaleProducts();
    _con.listenForNewArrivals();
    _con.listenForSpecial4U();
    _con.listenForCarts();
    _con.listenForFavorites();

//    _con.listenForBrands();
    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    super.initState();

  }

  Future<void> onRefresh() async{
    print('onRefresh on home CALLED');
    _con.bestSaleProducts.clear();
    _con.newArrivalProducts.clear();
    _con.special4UProducts.clear();
    _con.listenForBestSaleProducts();
    _con.listenForNewArrivals();
    _con.listenForSpecial4U();
    _con.listenForCarts();

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  Widget _buildContent(BuildContext context) {
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _createHeader(
            title: S.of(context).promotions,
            backgroundColor: DmConst.homePromotionColor,
            onTap: () {
              RouteGenerator.gotoPromotions(context, replaceOld: true);
            }),

        HomePromotionsSlider(),

//              // Heading (bestSale)
        _createHeader(
            title: S.of(context).bestSale,
            onTap: () {
//              Navigator.of(context).pushNamed('/Category',
//                  arguments: new RouteArgument(
//                      id: '1',
//                      param: [Category(id: '1', name: S.of(context).bestSale)],
//                      heroTag: "bestSale_"));
              RouteGenerator.gotoBestSale(context);
            }),
        _con.bestSaleProducts.isEmpty
            ? ProductsGridViewLoading()
            : HomeProductsListView(products: _con.bestSaleProducts, animationOpacity: animationOpacity,
              hero: 'home_best_sale',
        ),
//            : HomeProductsByCategory(animationOpacity: animationOpacity, category: _con.categorySelected),
        // Heading (Brands)
        _createHeader(
            title: S.of(context).newArrival,
            onTap: () {
//              Navigator.of(context).pushNamed('/Category',
//                  arguments: new RouteArgument(
//                      id: '1',
//                      param: [Category(id: '2', name: S.of(context).newArrival)],
//                      heroTag: "newArival_"));
              RouteGenerator.gotoNewArrivals(context);
            }),
        _con.newArrivalProducts.isEmpty
            ? ProductsGridViewLoading()
            : HomeProductsListView(products: _con.newArrivalProducts, animationOpacity: animationOpacity,
          hero: 'home_new_arrival',),
        //specialForYou
        _createHeader(
            title: S.of(context).specialForYou,
            onTap: () {
              RouteGenerator.gotoSpecial4U(context);
            }),
        _con.special4UProducts.isEmpty
            ? ProductsGridViewLoading()
            : HomeProductsListView(products: _con.special4UProducts, animationOpacity: animationOpacity,
          hero: 'home_spe4U',),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: 0),
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(onFilter: (Filter f) {
        print('selected filter: $f');
      }),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            SliverList(
              delegate: SliverChildListDelegate([
                _buildContent(context)
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Widget _createHeader({String title, Color backgroundColor = DmConst.accentColor, Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: DmConst.appBarHeight * 0.7,
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(
                  child: Text(title, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
            ),
            Stack(
              children: [
                Positioned(child: Icon(Icons.arrow_forward_ios, color: Colors.white)),
                Positioned(child: Icon(Icons.arrow_forward_ios, color: Colors.white), left: -7)
              ],
            )
          ],
        ),
      ),
    );
  }
}
