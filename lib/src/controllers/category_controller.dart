import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/product_repository.dart';

class CategoryController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Category category;
  bool loadCart = false;
  List<Cart> carts = [];
  List<Category> categories = [];


  CategoryController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForProductsByCategory();
    listenForCategories();
  }

  void listenForCategories ({Function() onDone }) async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: onDone != null ? onDone : (){});
  }

  void listenForProductsByCategory({int id, String message}) async {

    print('listenForProductsByCategory called.........');

//    final Stream<Product> stream = await getProductsByCategory(id, 1);
//    stream.listen((Product _product) {
//      setState(() {
//        products.add(_product);
//      });
//    }, onError: (a) {
//      scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text(S.current.verifyYourInternetConnection),
//      ));
//    }, onDone: () {
//      if (message != null) {
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(message),
//        ));
//      }
//    });
  }

  void listenForCategory({int id, String message}) async {
    final Stream<Category> stream = await getCategory(id);
    stream.listen((Category _category) {
      setState(() => category = _category);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verifyYourInternetConnection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCarts();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }

  bool isSameStores(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product?.store?.id == product.store?.id;
    }
    return true;
  }

  /*void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _cart = new Cart();
    _cart.product = product;
    _cart.options = [];
    _cart.quantity = 1;
    addCart(_cart, reset).then((value) {
      setState(() {
        this.loadCart = false;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.productAdded2Cart),
      ));
    });
  }*/

  void addToCart(Product product, {bool reset = false}) async {
    print('================== NOT YET IMPLEMENTED');
//    setState(() {
//      this.loadCart = true;
//    });
//    var _newCart = new Cart();
//    _newCart.product = product;
//    _newCart.options = [];
//    _newCart.quantity = 1;
//    // if product exist in the cart then increment quantity
//    var _oldCart = isExistInCart(_newCart);
//    if (_oldCart != null) {
//      _oldCart.quantity++;
//      updateCart(_oldCart).then((value) {
//        setState(() {
//          this.loadCart = false;
//        });
//      }).whenComplete(() {
//        scaffoldKey?.currentState?.showSnackBar(SnackBar(
//          content: Text(S.current.productAdded2Cart),
//        ));
//      });
//    } else {
//      // the product doesnt exist in the cart add new one
//      addCart(_newCart, reset).then((value) {
//        setState(() {
//          this.loadCart = false;
//        });
//      }).whenComplete(() {
//        scaffoldKey?.currentState?.showSnackBar(SnackBar(
//          content: Text(S.current.productAdded2Cart),
//        ));
//      });
//    }
  }


  Future<void> refreshCategory() async {
    products.clear();
    category = new Category();
    listenForProductsByCategory(message: S.current.categoryRefreshedSuccessfully);
    listenForCategory(message: S.current.categoryRefreshedSuccessfully);
  }
}
