import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/gallery.dart';
import '../models/store.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/gallery_repository.dart';
import '../repository/store_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';

class StoreController extends ControllerMVC {
  Store store;
  List<Gallery> galleries = <Gallery>[];
  List<Product> products = <Product>[];
  List<Product> trendingProducts = <Product>[];
  List<Product> featuredProducts = <Product>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  StoreController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForStore({String id, String message}) async {
    final Stream<Store> stream = await getStore(id, deliveryAddress.value);
    stream.listen((Store _store) {
      setState(() => store = _store);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForGalleries(String idStore) async {
    final Stream<Gallery> stream = await getGalleries(idStore);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForStoreReviews({String id, String message}) async {
    final Stream<Review> stream = await getStoreReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForProducts(String idStore) async {
    final Stream<Product> stream = await getProductsOfStore(idStore);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForTrendingProducts(String idStore) async {
    final Stream<Product> stream = await getTrendingProductsOfStore(idStore);
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForFeaturedProducts(String idStore) async {
    final Stream<Product> stream = await getFeaturedProductsOfStore(idStore);
    stream.listen((Product _product) {
      setState(() => featuredProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshStore() async {
    var _id = store.id;
    store = new Store();
    galleries.clear();
    reviews.clear();
    featuredProducts.clear();
    listenForStore(id: _id, message: 'store_refreshed_successfuly');
    listenForStoreReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedProducts(_id);
  }
}
