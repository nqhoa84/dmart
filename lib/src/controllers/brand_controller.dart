
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/brand.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/brand_repository.dart';
import '../repository/product_repository.dart';

class BrandController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Brand brand;
  bool loadCart = false;
  List<Cart> carts = [];
  List<Brand> brands = [];

  BrandController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForBrands();
    listenForProductsByBrand();
  }

  /*selectById(List<Brand> brands, String id) {
    brands.forEach((Brand brand) {
      brand.selected = false;
      if (brand.id == id) {
        brand.selected = true;
      }
    });
  }*/
  void listenForBrands () async {
    final Stream<Brand> stream = await getBrands();
    stream.listen((Brand _brand) {
      setState(() => brands.add(_brand));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }


  void listenForProductsByBrand({String id, String message}) async {
    final Stream<Product> stream = await getProductsByBrand(id);
    stream.listen((Product _product) {
      setState(() {
        products.add(_product);
      });
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForBrand({String id, String message}) async {
    final Stream<Brand> stream = await getBrand(id);
    stream.listen((Brand _brand) {
      setState(() => brand = _brand);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
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
    final Stream<Cart> stream = await getCart();
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
        content: Text(S.current.this_product_was_added_to_cart),
      ));
    });
  }*/

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.product = product;
    _newCart.options = [];
    _newCart.quantity = 1;
    // if product exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity++;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_product_was_added_to_cart),
        ));
      });
    } else {
      // the product doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_product_was_added_to_cart),
        ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart),
        orElse: () => null);
  }

  Future<void> refreshBrand() async {
    products.clear();
    brand = new Brand();
    listenForProductsByBrand(message: S.of(context).brand_refreshed_successfuly);
    listenForBrand(message: S.of(context).brand_refreshed_successfuly);
  }
}
