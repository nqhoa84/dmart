import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/category_repository.dart';
import '../repository/product_repository.dart';

class PromotionController extends ControllerMVC {
  List<Product> products = <Product>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Category> promoGroups = [];


  PromotionController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForProductsByPromoGroup();
    listenForGroups();
  }

  ///Listen for all PromotionGroups. When finish, the groups are stored on promoGroups property.
  void listenForGroups ({Function() onDone }) async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => promoGroups.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: onDone != null ? onDone : (){});
  }

  ///Listen for all Products of one promoGroup. When finish, the products are stored on products property.
  void listenForProductsByPromoGroup({String id, String message}) async {
    final Stream<Product> stream = await getProductsByCategory(id);
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

}
