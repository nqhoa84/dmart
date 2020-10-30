import 'package:dmart/constant.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:flutter/material.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../models/route_argument.dart';
import '../widgets/EmptyCart.dart';
import '../widgets/cart_bottom_button.dart';
import 'abs_product_mvc.dart';
import 'delivery_to.dart';

class CartsScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CartsScreen({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartsScreenState createState() => _CartsScreenState();
}

class _CartsScreenState extends ProductStateMVC<CartsScreen>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _CartsScreenState() : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForCarts();
    canLoadMore = false;
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return S.of(context).myCart;
  }

  Future<void> _refresh() async {
    isLoading = true;
    onRefresh();
    isLoading = false;
    canLoadMore = true;
  }

  @override
  Future<void> onRefresh() async{
//    proCon.newArrivalProducts?.clear();
    proCon.listenForCarts();
  }

  @override
  Widget buildContent(BuildContext context) {
    if (DmState.carts.isEmpty) {
      return EmptyCartGrid();
    } else {
      List<Product>  ps = [];
      DmState.carts.forEach((cart) {
        if(!ps.contains(cart.product)) {
          ps.add(cart.product);
        }
      });
//      return ProductGridView(products: ps, heroTag: 'myCart');
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: ps, heroTag: 'myCart',
          showRemoveIcon: true,
        ));
    }
  }

  @override
  Future<void> loadMore() async {
//    int pre = proCon.newArrivalProducts != null ? proCon.newArrivalProducts.length : 0;
//    proCon.listenForNewArrivals(nextPage: true);
//    canLoadMore = proCon.newArrivalProducts != null
//        && proCon.newArrivalProducts.length > pre;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: bottomIdx),
//      drawer: DrawerWidget(),
      body: SafeArea(
        child: Stack (
          children: [
            RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
//            controller: _scrollCon,
                slivers: <Widget>[
                  createSliverTopBar(context),
                  createSliverSearch(context),
                  createSilverTopMenu(context, haveBackIcon: true, title: getTitle(context)),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding: EdgeInsets.all(DmConst.masterHorizontalPad),
                          child: buildContent(context)),
                      SizedBox(height: 80),
                    ]),
                  )
                ],
              ),
            ),
            buildBottom(context),
          ],
        ),
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: CartBottomButton(
          title: S.of(context).processOrder,
          onPressed: _onPressProcessOrder
      ),
    );
  }
  void _onPressProcessOrder() {
    if(DmState.amountInCart.value <= 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('${S.of(context).yourCartEmpty}',
              style: TextStyle(color: Colors.red))));
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DeliveryToScreen()));
  }
}
