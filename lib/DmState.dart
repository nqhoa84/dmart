import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:flutter/material.dart';

class DmState {
  static int bottomBarSelectedIndex = 0;

  static ValueNotifier<int> amountInCart = ValueNotifier(0);
  static ValueNotifier<double> cartsValue = ValueNotifier(0.0);
  static List<Cart> carts = [];

  static void refreshCart(List<Cart> _carts) {
    carts.clear();
    _carts.forEach((element) {
      Cart c = findCart(element.product?.id);
      if(c != null && c.isValid) {
        c.quantity += element.quantity;
      } else {
        carts.add(element);
      }
    });

    double am = 0;
    double value = 0;
    carts.forEach((element) {
//      print('this is currently in cart: $element');
      am += element.quantity;
      value += element.product.paidPrice * element.quantity;
    });
    cartsValue.value = value;
    amountInCart.value = am.round();
//    print('current cart amountInCart = ${amountInCart.value} ');
  }

  static Cart findCart(int productId) {
    Cart c;
    carts.forEach((element) {
      if(element.product?.id == productId) {
        c = element;
        return;
      }
    });
    return c;
  }

  static int countQuantityInCarts(int productId) {
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

  static Favorite findFav(int productId) {
    Favorite f;
    favorites.forEach((element) {
      if(element.product?.id == productId) {
        f = element;
        return;
      }
    });
    return f;
  }

  static double calculateTotalMoneyOnCarts() {
    double re = 0;
    carts.forEach((element) {
      re += element.quantity * element.product.paidPrice;
    });
    return re;
  }
}
