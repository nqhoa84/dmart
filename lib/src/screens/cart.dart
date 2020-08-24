import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/IconWithText.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../widgets/CartItemWidget.dart';
import '../widgets/EmptyCart.dart';
import 'delivery_to.dart';

class CartsScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  CartsScreen({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartsScreenState createState() => _CartsScreenState();
}

class _CartsScreenState extends StateMVC<CartsScreen> {
  CartController _con;

  _CartsScreenState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  int _countCart() {
    int re = 0;
    _con.carts.forEach((element) {
      re += element.quantity?.round();
    });
    return re;
  }

  @override
  Widget build(BuildContext context) {
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

  void onPressedOnRemoveIcon(String productId) {
    print('$productId need to be remove from cart');
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
                createTitleRowWithBack(context, title: S.of(context).myCart),
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
          child: CartBottomButton(countItem: _countCart(), grandTotalMoney:_con.subTotal,
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
          amountInCart: c.quantity?.round(),
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
