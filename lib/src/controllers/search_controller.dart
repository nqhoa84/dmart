import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
import '../models/store.dart';
import '../models/product.dart';
import '../repository/store_repository.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';

class SearchController extends ControllerMVC {
  List<Store> stores = <Store>[];
  List<Product> products = <Product>[];

  SearchController() {
    //listenForStores();
    listenForProducts();
  }

  /*void listenForStores({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Store> stream = await searchStores(search, _address);
    stream.listen((Store _store) {
      setState(() => stores.add(_store));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }*/

  void listenForProducts({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    //Address _address = deliveryAddress.value;
    final Stream<Product> stream = await searchProducts(search);
    stream.listen((Product _product) {
      setState(() => products.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      stores = <Store>[];
      products = <Product>[];
    });
    //listenForStores(search: search);
    listenForProducts(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
