import 'package:dmart/DmState.dart';

import '../helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/user_repository.dart';

class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message, bool isRefresh = true}) async {
    if(isRefresh) {
      carts.clear();
    }
    final Stream<Cart> stream = await getCarts();
    stream.listen((Cart _cart) {
      if (_cart.isValid) {
        setState(() {
          carts.add(_cart);
        });
      } else {
        print('Cart $_cart is Invalid');
      }
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verifyYourInternetConnection),
      ));
    }, onDone: () {
//      if (carts.isNotEmpty) {
//        calculateSubtotal();
//      }
//      if (message != null) {
//        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),
//        ));
//      }
    });
  }


  Future<void> refreshCarts() async {
    listenForCarts(message: S.current.cartsRefreshedSuccessfully);
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      listenForCarts();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(_cart.product.name),
      ));
    });
  }

  void calculateSubtotal() async {
    subTotal = 0;
    total = 0;
    taxAmount = 0;
    carts.forEach((cart) {
      subTotal += cart.quantity * cart.product.price; //if(cart.product.store.)
      if (Helper.canDelivery(carts: carts)) {
        deliveryFee = cart.product.store.deliveryFee;
      }
      //deliveryFee += cart.product.store.deliveryFee;
      taxAmount = (subTotal + deliveryFee) * cart.product.store.defaultTax / 100;
    });
    //deliveryFee = carts[0].product.store.deliveryFee;
    //taxAmount = (subTotal + deliveryFee) * carts[0].product.store.defaultTax / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity < cart.product.itemsAvailable) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

}
