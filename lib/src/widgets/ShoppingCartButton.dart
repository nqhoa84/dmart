import 'dart:ui';

import 'package:badges/badges.dart';

import '../../DmState.dart';
import '../../route_generator.dart';
import '../../src/controllers/cart_controller.dart';
import '../../src/models/product.dart';
import '../../src/models/route_argument.dart';
import '../../src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';

class ShoppingCartButton extends StatefulWidget
{
  const ShoppingCartButton ({
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

  class _ShoppingCartButtonWidget extends StateMVC<ShoppingCartButton>{

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
      if (_con.cartCount > 0) {
        return InkWell(
          onTap: () => RouteGenerator.gotoCart(context),
          child: Badge(
            position: BadgePosition.topRight(top: 0, right: 3),
            animationDuration: Duration(milliseconds: 300),
            animationType: BadgeAnimationType.slide,
            badgeContent: Text('${_con.cartCount}', style: TextStyle(color: Colors.white)),
            child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
          ),
        );
      } else {
        return InkWell(
            onTap: () => RouteGenerator.gotoCart(context),
            child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown));
      }
      return ValueListenableBuilder(
          valueListenable: DmState.amountInCart,
          builder: (context, value, child) {
            if(value > 0) {
              return Badge(
                position: BadgePosition.topRight(top: 0, right: 3),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent: Text('$value', style: TextStyle(color: Colors.white)),
                child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
              );
            } else {
              return Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown);
            }
          }
      );
      return FlatButton(
        onPressed: () {
          if (currentUser.value.isLogin) {
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


