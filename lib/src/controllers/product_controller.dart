import 'package:dmart/DmState.dart';

import '../models/review.dart';
import '../models/brand.dart';
import '../models/category.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';
import 'controller.dart';

class ProductController extends Controller {
  Product product;
  List<Product> relatedProducts;
  List<Product> bestSaleProducts;
  List<Product> newArrivalProducts;
  List<Product> special4UProducts;
  List<Cart> carts = [];
//  Favorite favorite;
  List<Review> reviews = <Review>[];
  List<Product> brandsProducts;
  List<Product> boughtProducts;
  List<Product> promotionProducts;
  List<Product> categoriesProducts;
//  List<Favorite> favorites = <Favorite>[];

  // ProductController() {
  //   this.scaffoldKey = new GlobalKey<ScaffoldState>();
  // }

  selectBrandById(List<Brand> brands, int id) {
    brands.forEach((Brand brand) {
      brand.selected = false;
      if (brand.id == id) {
        brand.selected = true;
      }
    });
  }

  selectCategoryById( List<Category> categories, int id) {
    categories.forEach((Category category) {
      category.selected = false;
      if (category.id == id) {
        category.selected = true;
      }
    });
  }

  int _bestSalePageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [bestSaleProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [bestSaleProducts].
  void listenForBestSaleProducts({bool nextPage = false}) async {
    _bestSalePageIdx = nextPage == false ? 1 : _bestSalePageIdx + 1;

    var pros = await getBestSale2(_bestSalePageIdx);
    if(this.bestSaleProducts == null)
      bestSaleProducts = [];
    pros.forEach((p) {
      setState(() {
        if(p.isValid)
          bestSaleProducts.add(p);
      });
    });
  }

  int _newArrivalPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [newArrivalProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [newArrivalProducts].
  Future<bool> listenForNewArrivals({bool nextPage = false}) async {
      _newArrivalPageIdx = nextPage == false ? 1 : _newArrivalPageIdx + 1;

      final List<Product> ps = await getNewArrivals2(_newArrivalPageIdx);
      if(this.newArrivalProducts == null)
        newArrivalProducts = [];
      setState(() {
        ps.forEach((element) {newArrivalProducts.add(element);});
      });
      return true;
//    final Stream<Product> stream = await getNewArrivals(_newArrivalPageIdx);
//    stream.listen((Product _product) {
//      setState(() {
//        if(_product.isValid)
//          newArrivalProducts.add(_product);
//      });
////      print('new arrival, pro id =${_product.id}, name=${_product.name}');
//    }, onError: (a) {
//      print(a);
//    }, onDone: () {});
//    return true;
  }

  int _spe4UPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [special4UProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [special4UProducts].
  void listenForSpecial4U({bool nextPage = false}) async {
    _spe4UPageIdx = nextPage == false ? 1 : _spe4UPageIdx + 1;
    final List<Product> ps = await getSpecial4U2(_spe4UPageIdx);
    if(this.special4UProducts == null)
      special4UProducts = [];
    setState(() {
      ps.forEach((element) {special4UProducts.add(element);});
    });

//    final Stream<Product> stream = await getSpecial4U(_spe4UPageIdx);
//    stream.listen((Product _product) {
//      setState(() {
//        if(_product.isValid) {
//          _product.isSpecial4U = true;
//          special4UProducts.add(_product);
//        }
//      });
////      print('special for U, pro id = ${_product.id}');
//    }, onError: (a) {
//      print(a);
//    }, onDone: () {
//      print('getSpecial4U special4UProducts.length = ${special4UProducts.length}');
//    });
  }

  int _favPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [favorites] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [favorites].
  /// NO NEED TO PAGING here. server returns 100 items.
  void listenForFavorites({String message, bool nextPage = false}) async {
//    _favPageIdx = nextPage == false ? 1 : _favPageIdx + 1;
    DmState.favorites.clear();
    final Stream<Favorite> stream = await getFavorites(_favPageIdx);
    stream.listen((Favorite _favorite) {
      if(_favorite != null && _favorite.isValid) {
        setState(() {
          DmState.favorites.add(_favorite);
          print('listenForFavorites favorites {id: ${_favorite.id} product ${_favorite.product.toStringIdName()}');
        });
      }
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verifyYourInternetConnection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  ///Get related products of one product [id], the results is stored on [relatedProducts] property of this object.
  void listenForRelatedProducts({int productId}) async {
    try {
//      final List<Product> stream = await getRelatedProducts2(productId);
      var ps = await getRelatedProducts2(productId);
      if(this.relatedProducts == null)
        relatedProducts = [];
      setState((){
        this.relatedProducts.clear();
        ps.forEach((element) {
          if(element.isValid) {
            relatedProducts.add(element);
          } else {
            print('-------------INVALID---------------');
            print(element);
          }
        });
      });
//      relatedProducts.a
//      stream.listen((Product _product) {
//        if (_product!= null && _product.isValid) {
//          setState(() => relatedProducts.add(_product));
//        }
//      }, onError: (a) {
//        print(a);
//      }, onDone: () {});
    } catch (e, trace) {
      print('$e, $trace');
    }
  }

  ///Listen for full inform from server, and the result will be store on [product] property of this controller.
  void listenForProduct({int productId, String message, Function() onComplete}) async {
    final Stream<Product> stream = await getProduct(productId);
    stream.listen((Product _product) {
      setState(() => product = _product);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verifyYourInternetConnection),
      ));
    }, onDone: onComplete);
  }

  void listenForProductsByBrand({int id, String message}) async {
    final Stream<Product> stream = await getProductsByBrand(id);
    stream.listen((Product _product) {
      setState(() {
        brandsProducts.add(_product);
      });
    }, onError: (a) {
      print(a);
    });
  }

  int _promoPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [promotionProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [promotionProducts].
  void listenForPromoProducts(int promoId, {bool nextPage = false}) async {
    _promoPageIdx = nextPage == false ? 1 : _promoPageIdx + 1;
    final List<Product> ps = await getProductsByPromotion2(promoId, _promoPageIdx);
    if(this.promotionProducts == null)
      promotionProducts = [];
    setState(() {
      ps.forEach((element) {promotionProducts.add(element);});
    });
  }

  int _cateProductsPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [categoriesProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [categoriesProducts].
  ///if [id] is less then 0, then load all products
  Future<bool> listenForProductsByCategory({int id, String message,bool nextPage = false}) async {
    _cateProductsPageIdx = nextPage == false ? 1 : _cateProductsPageIdx + 1;
    final List<Product> ps = await getProductsByCategory2(id, _cateProductsPageIdx);
    if(this.categoriesProducts == null)
      categoriesProducts = [];
    setState(() {
      ps.forEach((element) {categoriesProducts.add(element);});
    });
    return true;
//    if(id > 0) {
//      final Stream<Product> stream = await getProductsByCategory(id, _cateProductsPageIdx);
//      stream.listen((Product _product) {
//        setState(() {
//          if (_product.isValid)
//            categoriesProducts.add(_product);
//        });
//      }, onError: (a) {
//        print(a);
//      });
//    } else {
//      final Stream<Product> stream = await getProducts(page: _cateProductsPageIdx);
//      stream.listen((Product _product) {
//        setState(() {
//          if (_product.isValid)
//            categoriesProducts.add(_product);
//        });
//      }, onError: (a) {
//        print(a);
//      });
//    }
  }

  ///Listen for all carts from server.
  ///Then update to [carts] property of this controller and refreshCart of [DmState.refreshCart].
  ///This will also refresh [DmState.amountInCart] value
  void listenForCarts() async {
    try {
      final Stream<Cart> stream = await getCarts();
      carts.clear();
      stream.listen((Cart _cart) {
        if(_cart != null && _cart.isValid)
          carts.add(_cart);
      }).onDone(() {
        setState(() {
          DmState.refreshCart(carts);
        });
      });
    } catch (e, trace) {
      print(e);
      print(trace);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.generalErrorMessage),
      ));
    }
  }

  void addToCart(int productId, {int quality = 1, Function(bool) onDone}) async {
    try {
      addCart(productId, quality: quality).then((newCart) {
        setState(() {
          carts.clear();
          carts.addAll(newCart);
          DmState.refreshCart(carts);
        });
      }).whenComplete(() {
        if(onDone != null) onDone(true);
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.current.productAdded2Cart),
        ));
      });
    }  catch (e, trace) {
      print('$e \n $trace');
      if(onDone != null) onDone(false);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.generalErrorMessage),
      ));
    }
  }

  void updateToCart(Cart c, {Function(bool) onDone}){
    try {
      updateCart(c).then((newCart) {
        setState(() {
          carts.clear();
          carts.addAll(newCart);
          DmState.refreshCart(carts);
        });
      }).whenComplete(() {
        if(onDone != null) onDone(true);
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.current.productAdded2Cart),
        ));
      });
    }  catch (e, trace) {
      print('$e \n $trace');
      if(onDone != null) onDone(false);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.generalErrorMessage),
      ));
    }
  }

  void removeFromCart(Cart c, {Function(bool) onDone}){
    try {
      removeCart(c).then((newCart) {
        setState(() {
          carts.clear();
          carts.addAll(newCart);
          DmState.refreshCart(carts);
        });
      }).whenComplete(() {
        if(onDone != null) onDone(true);

        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.current.productAdded2Cart),
        ));
      });
    } catch (e, trace) {
      print('$e \n $trace');
      if(onDone != null) onDone(false);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.generalErrorMessage),
      ));
    }
  }

  void addCartGeneral(int productId, int quantity, {Function(bool) onDone}) {
    print("add to cart, productid: $productId, quantity: $quantity");
    if(quantity > 0) {
      addToCart(productId, quality: quantity, onDone: onDone);
    } else {
      Cart c = DmState.findCart(productId);
      if(c!= null) {
        c.quantity += quantity;
        if(c.quantity > 0) {
          updateToCart(c, onDone: onDone);
        } else {
          removeFromCart(c, onDone: onDone);
          c.quantity = 0;
        }
      }
    }
  }

  ///Add one [product] to favorites. function [onDone] is call to inform the result with [isOK] parameter.
  void addToFavorite(Product product, {Function(bool) onDone}) async {
    var _favorite = new Favorite();
    _favorite.product = product;
//    _favorite.options = product.options.where((Option _option) {
//      return _option.checked;
//    }).toList();

    addFavorite(product.id).then((value) {
      if(value != null && value.isValid) {
        setState(() {
          DmState.favorites.add(value);
        });
        if(onDone != null) onDone(true);
      } else {
        if(onDone != null) onDone(false);
      }
//      scaffoldKey.currentState.showSnackBar(SnackBar(
//        content: Text('This product was added to favorite'),
//      ));
    }
    );
  }

  void removeFromFavorite(Favorite _favorite, {Function(bool) onDone}) async {
    DmState.favorites.remove(_favorite);
    await removeFavorite(_favorite);

    //todo do something to handle onDone.
    if(onDone != null) onDone(true);
  }

  void listenForProductReviews({int id, String message}) async {
    final Stream<Review> stream = await getProductReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> refreshProduct() async {
    var _id = product.id;
    product = new Product();
    listenForProduct(productId: _id, message: 'Product refreshed successfully');
  }

}
