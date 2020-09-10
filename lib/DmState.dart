import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:flutter/material.dart';

class DmState {
  static int bottomBarSelectedIndex = 0;

  static ValueNotifier<int> amountInCart = ValueNotifier(0);
  static List<Cart> carts = [];

  static void refreshCart(List<Cart> _carts) {
//    print('current _carts.length = ${_carts.length} ');

    carts.clear();
    _carts.forEach((element) {
      Cart c = _findCart(element.product?.id);
      if(c != null) {
        c.quantity += element.quantity;
      } else {
        carts.add(element);
      }
    });
//    carts.addAll(_carts);

    double am = 0;
    carts.forEach((element) {
      print('this is currently in cart: $element');
      am += element.quantity;
    });
    amountInCart.value = am.round();
//    print('current cart amountInCart = ${amountInCart.value} ');
  }

  static Cart _findCart(int productId) {
    Cart c;
    carts.forEach((element) {
      if(element.product?.id == productId) {
        c = element;
        return;
      }
    });
    return c;
  }

  static int countQualityInCarts(int productId) {
    int re = 0;
    carts.forEach((c) {
      if(c.product.id == productId) {
        re += c.quantity.round();
      }
    });
    return re;
  }

  static bool isFavorite({int productId}) {
    bool re = false;
    favorites.forEach((element) {
      if(element.product.id == productId) {
        re = true;
        return;
      }
    });
    return re;
  }

  static List<Favorite> favorites = [];
  static void refreshFav({List<Favorite> fav}) {
    favorites.clear();
    if(fav != null) favorites.addAll(fav);
  }
}
