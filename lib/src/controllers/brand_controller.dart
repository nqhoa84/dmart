import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/brand.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../repository/brand_repository.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';

class BrandController extends ControllerMVC {
  List<Product>? products = <Product>[];
  late GlobalKey<ScaffoldState> scaffoldKey;
  Brand? brand;
  bool? loadCart = false;
  List<Cart>? carts = [];
  List<Brand>? brands = [];

  BrandController({
    this.products,
    this.brand,
    this.loadCart,
    this.carts,
    this.brands,
  }) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForBrands();
    listenForProductsByBrand();
  }

  /*selectById(List<Brand> brands, int id) {
    brands.forEach((Brand brand) {
      brand.selected = false;
      if (brand.id == id) {
        brand.selected = true;
      }
    });
  }*/
  void listenForBrands() async {
    final Stream<Brand> stream = await getBrands();
    stream.listen((Brand _brand) {
      setState(() => brands!.add(_brand));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForProductsByBrand({int? id, String? message}) async {
    final Stream<Product> stream = await getProductsByBrand(id);
    stream.listen((Product _product) {
      setState(() {
        products!.add(_product);
      });
    }, onError: (a) {
      SnackBar snackBar = SnackBar(
        content: Text(S.current.verifyYourInternetConnection),
      );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      scaffoldKey.currentState!.showSnackBar(snackBar);
    }, onDone: () {
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(message!),
      ));
    });
  }

  void listenForBrand({int? id, required String message}) async {
    final Stream<Brand> stream = await getBrand(id!);
    stream.listen((Brand _brand) {
      setState(() => brand = _brand);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(S.current.verifyYourInternetConnection),
      ));
    }, onDone: () {
      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
  }

  void listenForCart() async {
    final Stream<Cart?> stream = await getCarts();
    stream.listen((Cart? _cart) {
      carts!.add(_cart!);
    });
  }

  bool isSameStores(Product product) {
    if (carts!.isNotEmpty) {
      return carts![0].product?.store?.id == product.store?.id;
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

  Future<void> refreshBrand() async {
    products!.clear();
    brand = new Brand();
    listenForProductsByBrand(message: S.current.brandRefreshedSuccessfully);
    listenForBrand(message: S.current.brandRefreshedSuccessfully);
  }
}
