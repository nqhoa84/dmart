import 'package:badges/badges.dart';

import '../../DmState.dart';
import '../../route_generator.dart';
import '../../src/controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:flutter/material.dart';

class ShoppingCartButton extends StatefulWidget {
  const ShoppingCartButton({
    Key? key,
  }) : super(key: key);

  @override
  _ShoppingCartButtonWidget createState() => _ShoppingCartButtonWidget();
}

class _ShoppingCartButtonWidget extends StateMVC<ShoppingCartButton> {
  CartController _con = CartController();

  _ShoppingCartButtonWidget() : super(CartController()) {
    _con = controller as CartController;
  }

  @override
  void initState() {
//  _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//      if (_con.cartCount > 0) {
//        return InkWell(
//          onTap: () => RouteGenerator.gotoCart(context),
//          child: Badge(
//            position: BadgePosition.topRight(top: 0, right: 3),
//            animationDuration: Duration(milliseconds: 300),
//            animationType: BadgeAnimationType.slide,
//            badgeContent: Text('${_con.cartCount}', style: TextStyle(color: Colors.black)),
//            child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
//          ),
//        );
//      } else {
//        return InkWell(
//            onTap: () => RouteGenerator.gotoCart(context),
//            child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown));
//      }
    return InkWell(
      onTap: () => RouteGenerator.gotoCart(context),
      child: ValueListenableBuilder(
          valueListenable: DmState.amountInCart,
          builder: (context, value, child) {
            if (DmState.amountInCart.value > 0) {
              return Badge(
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent: Text('${DmState.amountInCart.value}',
                    style: TextStyle(color: Colors.white)),
                child:
                    Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
              );
            } else {
              return Image.asset('assets/img/H_Cart.png',
                  fit: BoxFit.scaleDown);
            }
          }),
    );
  }
}
