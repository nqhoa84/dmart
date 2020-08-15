
import 'package:flutter/material.dart';
import '../../src/models/brand.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../repository/category_repository.dart';
import '../repository/brand_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
class HomeController extends ControllerMVC
{
  List<Category> categories = <Category>[];
  List<Brand> brands = <Brand>[];
  List<Product> trendingProducts = <Product>[];
  Category categorySelected;
  Brand brandSelected;
  HomeController () ;

  Future<void> listenForCategories () async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      setState((){
        categorySelected=categories.elementAt(0)..selected=true;
      });
    });
  }

  Future<void> listenForBrands () async {
    final Stream<Brand> stream = await getBrands();
    stream.listen((Brand _brand) {
      setState(() => brands.add(_brand));
    }, onError: (a) {
      print(a);
    }, onDone: () {
      setState((){
        brandSelected=brands.elementAt(0)..selected=true;
      });

    });
  }

  /*Future<void> listenForTopStores () async {
    final Stream<Store> stream = await getNearStores(
        deliveryAddress.value, deliveryAddress.value);
    stream.listen((Store _store) {
      setState(() => topStores.add(_store));
    }, onError: (a) {}, onDone: () {});
  }
*/
  /*Future<void> listenForPopularStores () async {
    final Stream<Store> stream = await getPopularStores(deliveryAddress.value);
    stream.listen((Store _store) {
      setState(() => popularStores.add(_store));
    }, onError: (a) {}, onDone: () {});
  }*/

  /*Future<void> listenForRecentReviews () async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }*/
  Future<void> listenForTrendingProducts () async {
    final Stream<Product> stream = await getTrendingProducts();
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }





  void requestForCurrentLocation (BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome () async {
    setState(() {
      trendingProducts = <Product>[];
      categories = <Category>[];
      brands = <Brand>[];
      //topStores = <Store>[];
      //popularStores = <Store>[];
      //recentReviews = <Review>[];
    });
    await listenForTrendingProducts();
    await listenForCategories();
    await listenForBrands();
  }

}



