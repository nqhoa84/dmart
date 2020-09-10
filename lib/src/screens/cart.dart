import 'package:dmart/buidUI.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../widgets/CartItemWidget.dart';
import '../widgets/EmptyCart.dart';
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

  @override
  Future<void> onRefresh() async{
//    proCon.newArrivalProducts?.clear();
    proCon.listenForCarts();
  }

  @override
  Widget buildContent(BuildContext context) {
    if (DmState.carts.isEmpty) {
      return EmptyCartGrid();
//      return ProductsGridViewLoading(isList: true);
    } else {
//      print('DmState.carts ${DmState.carts.length}');
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
  void loadMore() {
//    int pre = proCon.newArrivalProducts != null ? proCon.newArrivalProducts.length : 0;
//    proCon.listenForNewArrivals(nextPage: true);
//    canLoadMore = proCon.newArrivalProducts != null
//        && proCon.newArrivalProducts.length > pre;
  }
}


class _CartsScreenStateOld extends StateMVC<CartsScreen>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartController _con;
  _CartsScreenStateOld() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget buildContent(BuildContext context) {
    if(_con.carts.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
       EmptyCartGrid();
    } else {
      print('_con.carts ${_con.carts.length}');
      List<Product>  ps = [];
      _con.carts.forEach((cart) {
        if(!ps.contains(cart.product)) {
          ps.add(cart.product);
        }
      });
      return ProductGridView(products: ps, heroTag: 'myCart');
      return _createProductsGrid2(context, products: ps);
      return ProductGridView(products: ps);
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
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          createSliverSearch(context),
          createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).myCart),
          SliverList(
            delegate: SliverChildListDelegate([
              buildContent(context),
            ]),
          )
        ]),
      ),
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: createAppBar(context, widget.scaffoldKey),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        body: RefreshIndicator(
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty ? EmptyCartGrid() : _createProductsGrid(context),
        ),
      ),
    );
  }

  void onPressedOnRemoveIcon(int productId) {
    print('$productId need to be remove from cart');
  }

  Widget _createProductsGrid2(BuildContext context, {List<Product> products}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        GridView.count(
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          crossAxisCount: 1,
          crossAxisSpacing: 1.5,
          childAspectRatio: 337.0 / 120,
          children: List.generate( _con.carts.length + 1, (index) {
            if(index == _con.carts.length) {
              return SizedBox(height: 100);
            }
            Cart c = _con.carts.elementAt(index);
            Product product = c.product;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductItemWide(
                product: product,
                heroTag: 'productOnCart$index',
                showRemoveIcon: true,
                onPressedOnRemoveIcon: onPressedOnRemoveIcon,
              ),
            );
          },
          ),
        ),
      ],
    );
  }

  Stack _createProductsGrid(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //display list of product on gridView.
        Container(
//          margin: EdgeInsets.only(bottom: 50),
          padding: EdgeInsets.only(bottom: 15),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 1,
                  crossAxisSpacing: 1.5,
                  childAspectRatio: 337.0 / 120,
                  children: List.generate( _con.carts.length + 1, (index) {
                      if(index == _con.carts.length) {
                        return SizedBox(height: 100);
                      }
                      Cart c = _con.carts.elementAt(index);
                      Product product = c.product;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProductItemWide(
                          product: product,
                          heroTag: 'productOnCart$index',
                          showRemoveIcon: true,
                          onPressedOnRemoveIcon: onPressedOnRemoveIcon,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        //Bottom Process order space.
        Positioned(
          bottom: 0,
          child: CartBottomButton(countItem: DmState.amountInCart.value, grandTotalMoney:_con.subTotal,
              title: S.of(context).processOrder,
              onPressed: () {
                _con.goCheckout(context);
              }),
        )
      ],
    );
  }

  Widget _createListOfProduct() {
    return ListView.separated(
//                            padding: EdgeInsets.symmetric(vertical: 15),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: _con.carts.length,
      separatorBuilder: (context, index) {
        return Divider(thickness: 1, height: 3);
      },
      itemBuilder: (context, index) {
        Cart c = _con.carts.elementAt(index);
        return Container(
          color: Colors.red,
        );
        return ProductItemWide(
          product: c.product,
          heroTag: 'productOnCart',
        );
        return CartItemWidget(
          cart: _con.carts.elementAt(index),
          heroTag: 'cart',
          taxAmount: _con.taxAmount,
          increment: () {
            _con.incrementQuantity(_con.carts.elementAt(index));
          },
          decrement: () {
            _con.decrementQuantity(_con.carts.elementAt(index));
          },
          onDismissed: () {
            _con.removeFromCart(_con.carts.elementAt(index));
          },
        );
      },
    );
  }
}
