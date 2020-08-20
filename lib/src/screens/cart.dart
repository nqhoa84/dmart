import 'package:dmart/buidUI.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';

import '../../DmState.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../widgets/CartItemWidget.dart';
import '../widgets/EmptyCart.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
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
          child: _con.carts.isEmpty
              ? EmptyCart()
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 150),
                      padding: EdgeInsets.only(bottom: 15),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 10),
                              //padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  UiIcons.shopping_cart,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  S.of(context).shopping_cart,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                                subtitle: Text(
                                  S.of(context).verify_your_quantity_and_click_checkout,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                            ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: _con.carts.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 15);
                              },
                              itemBuilder: (context, index) {
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

                                /*CartItemWidget(
                                  cart: _con.carts.elementAt(index),
                                  heroTag: 'cart',
                                  increment: () {
                                    _con.incrementQuantity(_con.carts.elementAt(index));
                                  },
                                  decrement: () {
                                    _con.decrementQuantity(_con.carts.elementAt(index));
                                  },
                                  onDismissed: () {
                                    _con.removeFromCart(_con.carts.elementAt(index));
                                  },
                                  onChanged: _con.calculateSubtotal,
                                );*/
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 140,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).focusColor.withOpacity(0.15),
                                  offset: Offset(0, -2),
                                  blurRadius: 5.0)
                            ]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).subtotal,
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              SizedBox(height: 5),
                              /*Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).delivery_fee,

                                    ),
                                  ),
                                  Helper.getPrice(_con.carts[0].product.store.deliveryFeestyle: Theme.of(context).textTheme.body2,, context, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '${S.of(context).tax} (${_con.carts[0].product.store.defaultTax}%)',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                  ),
                                  Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subhead)
                                ],
                              ),*/
                              SizedBox(height: 10),
                              Stack(
                                fit: StackFit.loose,
                                alignment: AlignmentDirectional.centerEnd,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width - 40,
                                    child: FlatButton(
                                      onPressed: () {
                                        _con.goCheckout(context);
                                      },
                                      disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      color: Theme.of(context).accentColor,
                                      shape: StadiumBorder(),
                                      child: Text(
                                        S.of(context).checkout,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Helper.getPrice(
                                      _con.total,
                                      context,
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
