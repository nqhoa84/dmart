import 'dart:convert';

import 'package:dmart/DmState.dart';
import 'package:dmart/utils.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/address.dart';
import '../models/store.dart';
import '../models/product.dart';
import '../repository/store_repository.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';
import 'controller.dart';

class SearchController extends Controller {
  List<Product> products = <Product>[];

  SearchController() {
//    listenForProducts();
  }

  Future<List<String>> getRecentSearchStr() async {
    if (DmState.recentSearches != null) return DmState.recentSearches;
    DmState.recentSearches = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('recent_searches')) {
      List ls = json.decode(await prefs.get('recent_searches')) as List;
      setState(() {
        ls.forEach((element) {
          DmState.recentSearches.add(element.toString());
        });
      });
    }

    return DmState.recentSearches;
  }

  Future<void> saveRecentSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('recent_searches', json.encode(DmState.recentSearches));
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

  void saveSearch(String search) {
    setRecentSearch(search);
  }

  int searchIdx = 0;

  Future<void> search(String search, {Function() onDone, bool nextPage = false}) async {
    if (DmUtils.isNullOrEmptyStr(search)) return;

    if (nextPage) {
      searchIdx++;
    } else {
      searchIdx = 1;
      products.clear();
      DmState.insertRecentSearch(search);
      saveRecentSearch();
    }

    final List<Product> stream = await searchProducts2(search, page: searchIdx);
    setState((){
      stream.forEach((element) {
        if(element.isValid)
          products.add(element);
      });
    });

    if (onDone != null) onDone();

//    stream.listen(
//      (Product _product) {
//        print('search result ${_product.toStringIdName()}');
//        if (_product.isValid) {
//          print('search result ${_product.toStringIdName()} is VALID');
//          products.add(_product);
////        setState(() => products.add(_product));
//        }
//      },
//      onError: (a) {
//        print(a);
//      },
//      onDone: () {
//        print("_con.products 1 == ${products.length}");
//        if (onDone != null) onDone();
//      },
//    );
  }

  void listenForProducts({String search, Function() onComplete}) async {
    final List<Product> stream = await searchProducts2(search);
    setState((){
      stream.forEach((element) {
        if(element.isValid)
          products.add(element);
      });
    });
//    stream.listen(
//      (Product _product) {
//        print('search result ${_product.toStringIdName()}');
//        if (_product.isValid) {
//          print('search result ${_product.toStringIdName()} is VALID');
//          products.add(_product);
////        setState(() => products.add(_product));
//        }
//      },
//      onError: (a) {
//        print(a);
//      },
//      onDone: () {
//        print("_con.products 1 ${products?.length}");
//        if (onComplete != null) onComplete();
//      },
//    );
  }
}
