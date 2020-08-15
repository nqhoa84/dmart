import 'dart:ui';

import '../../src/controllers/cart_controller.dart';
import '../../src/models/product.dart';
import '../../src/models/route_argument.dart';
import '../../src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';

class ShoppingCartButtonWidget extends StatefulWidget
{
  const ShoppingCartButtonWidget ({
    this.iconColor,
    this.labelColor,
    this.product,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;
  final Product product;

  @override
  _ShoppingCartButtonWidget createState () => _ShoppingCartButtonWidget();

}

  class _ShoppingCartButtonWidget extends StateMVC<ShoppingCartButtonWidget>{

  CartController _con;

  _ShoppingCartButtonWidget() : super(CartController()) {
  _con = controller;
  }

  @override
  void initState() {
  _con.listenForCartsCount();
  super.initState();
  }
    @override
    Widget build(BuildContext context) {
      return FlatButton(
        onPressed: () {
          if (currentUser.value.apiToken != null) {
            if(widget.product!=null){
              Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: '/Product', id: widget.product.id));

            }else{
              Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: '/Pages', id: '2'));
            }

          } else {
            Navigator.of(context).pushNamed('/Login');
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
//              child: Icon(
//                UiIcons.shopping_cart,
//                color: widget.iconColor,
//                size: 28,
//              ),
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  height: 40,
                  child: Image.asset('assets/img/H_Cart.png',
                      fit: BoxFit.scaleDown),
                ),
            ),
            Container(
              child: Text(
                _con.cartCount.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(color: Theme.of(context).primaryColor, fontSize: 9),
                    ),
              ),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(color: widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
              constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
            ),
          ],
        ),
        color: Colors.transparent,
      );
    }
  }


