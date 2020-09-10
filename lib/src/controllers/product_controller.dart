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

class ProductController extends ControllerMVC {
  Product product;
  List<Product> featuredProducts = [];
  List<Product> bestSaleProducts = [];
  List<Product> newArrivalProducts = [];
  List<Product> special4UProducts = [];
  List<Cart> carts = [];
  Favorite favorite;
  List<Review> reviews = <Review>[];
  List<Product> brandsProducts=[];
  List<Product> boughtProducts=[];
  List<Product> promotionProducts=[];
  List<Product> categoriesProducts=[];
  List<Favorite> favorites = <Favorite>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

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
  Future<void> refreshFavorites() async {
    favorites.clear();
    listenForFavorites(message: 'Favorites refreshed successfully');
  }

  int _bestSalePageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [bestSaleProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [bestSaleProducts].
  void listenForBestSaleProducts({bool nextPage = false}) async {
    _bestSalePageIdx = nextPage == false ? 1 : _bestSalePageIdx + 1;
    final Stream<Product> stream = await getBestSale(_bestSalePageIdx);
    stream.listen((Product _product) {
      setState(() {
        if(_product.isValid)
          bestSaleProducts.add(_product);
      });
//      print('best sale, pro id = ${_product.id}');
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  int _newArrivalPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [newArrivalProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [newArrivalProducts].
  void listenForNewArrivals({bool nextPage = false}) async {
      _newArrivalPageIdx = nextPage == false ? 1 : _newArrivalPageIdx + 1;

    final Stream<Product> stream = await getNewArrivals(_newArrivalPageIdx);
    stream.listen((Product _product) {
      setState(() {
        if(_product.isValid)
          newArrivalProducts.add(_product);
      });
//      print('new arrival, pro id =${_product.id}, name=${_product.name}');
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  int _spe4UPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [special4UProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [special4UProducts].
  void listenForSpecial4U({bool nextPage = false}) async {
    _spe4UPageIdx = nextPage == false ? 1 : _spe4UPageIdx + 1;

    final Stream<Product> stream = await getSpecial4U(_spe4UPageIdx);
    stream.listen((Product _product) {
      setState(() {
        if(_product.isValid) {
          _product.isSpecial4U = true;
          special4UProducts.add(_product);
        }
      });
//      print('special for U, pro id = ${_product.id}');
    }, onError: (a) {
      print(a);
    }, onDone: () {
      print('getSpecial4U special4UProducts.length = ${special4UProducts.length}');
    });
  }

  int _favPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [special4UProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [special4UProducts].
  void listenForFavorites({String message, bool nextPage = false}) async {
    _favPageIdx = nextPage == false ? 1 : _favPageIdx + 1;

    final Stream<Favorite> stream = await getFavorites(_favPageIdx);
    stream.listen((Favorite _favorite) {
      if(_favorite != null && _favorite.isValid) {
        setState(() {
          favorites.add(_favorite);
          print('listenForFavorites favorites {id: ${_favorite.id} product ${_favorite.product.toStringIdName()}');
        });
      }
    }, onError: (a) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
      print('listenForFavorites favorites.length = ${favorites.length}');
      DmState.refreshFav(fav: this.favorites);
    });
  }

  void listenForFeaturedProducts () async {
    final Stream<Product> stream = await getProducts();
    stream.listen((Product _product) {
      if (_product.featured) {
        setState(() => featuredProducts.add(_product));
      }
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForProduct({int productId, String message}) async {
    final Stream<Product> stream = await getProduct(productId);
    stream.listen((Product _product) {
      setState(() => product = _product);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
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

  //todo need api and change to that new api.
  void listenForBoughtProducts({Function() onDone}) async {
    print('listenForBoughtProducts called');
  }

  int _promoPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [promotionProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [promotionProducts].
  Future<void> listenForPromoProducts(int id, {bool nextPage = false}) async {
    _promoPageIdx = nextPage == false ? 1 : _promoPageIdx + 1;
    final Stream<Product> stream = await getProductsByPromotion(id, _promoPageIdx);
    promotionProducts.clear();
    stream.listen((Product _product) {
      setState(() {
        promotionProducts.add(_product);
      });
    }, onError: (a) {
      print(a);
    }, onDone: (){
      print(' onDone boughtProducts ${promotionProducts.length}');
    }
    );
  }

  int _cateProductsPageIdx = 1;
  ///if [nextPage] is true, this will load the next page, store on [categoriesProducts] and move pageIndex one step up.
  ///if [nextPage] is FALSE, this will refresh the [categoriesProducts].
  void listenForProductsByCategory({int id, String message,bool nextPage = false}) async {
    _cateProductsPageIdx = nextPage == false ? 1 : _cateProductsPageIdx + 1;
    final Stream<Product> stream = await getProductsByCategory(id, _cateProductsPageIdx);
    stream.listen((Product _product) {
      setState(() {
        if(_product.isValid)
          categoriesProducts.add(_product);
      });
    }, onError: (a) {
      print(a);
    });
  }

  void listenForFavorite({int productId}) async {
    final Stream<Favorite> stream = await isFavoriteProduct(productId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  ///Listen for all carts from server.
  ///Then update to [carts] property of this controller and refreshCart of [DmState.refreshCart].
  ///This will also refresh [DmState.amountInCart] value
  void listenForCarts() async {
    final Stream<Cart> stream = await getCarts();
    carts.clear();
    stream.listen((Cart _cart) {
      if(_cart != null && _cart.isValid)
        carts.add(_cart);
    }).onDone(() {
      DmState.refreshCart(carts);
    });
  }

  bool isSameStores(Product product) {
    if (carts.isNotEmpty) {
      return carts[0].product?.store?.id == product.store?.id;
    }
    return true;
  }

  void addToCart(Product product, {bool reset = false}) async {
    print('================== NOT YET IMPLEMENTED');
//
//    var _newCart = new Cart();
//    _newCart.quantity = this.quantity;
//    // if quantity more than Items Available
//    if(double.parse(product.itemsAvailable) >=_newCart.quantity){
//      setState(() {
//        this.loadCart = true;
//      });
//      _newCart.product = product;
//      if(product.options !=null){
//        _newCart.options = product.options.where((element) => element.checked).toList();
//        // if product exist in the cart then increment quantity
//        var _oldCart = isExistInCart(_newCart);
//        if (_oldCart != null) {
//          if(_oldCart.quantity+this.quantity <= double.parse(product.itemsAvailable)){
//            _oldCart.quantity += this.quantity;
//            updateCart(_oldCart).then((value) {
//              setState(() {
//                this.loadCart = false;
//              });
//            }).whenComplete(() {
//              scaffoldKey?.currentState?.showSnackBar(SnackBar(
//                content: Text(S.of(context).productAdded2Cart),
//              ));
//            });
//          }else{
//            setState(() {
//              this.loadCart = false;
//            });
//            scaffoldKey?.currentState?.showSnackBar(SnackBar(
//              content: Text('No items available '),
//
//            ));
//          }
//
//        } else {
//          // the product doesnt exist in the cart add new one
//          addCart(_newCart, reset).then((value) {
//            setState(() {
//              this.loadCart = false;
//            });
//          }).whenComplete(() {
//            scaffoldKey?.currentState?.showSnackBar(SnackBar(
//              content: Text(S.of(context).productAdded2Cart),
//            ));
//          });
//        }
//      }
//    }else{
//      scaffoldKey?.currentState?.showSnackBar(SnackBar(
//          content: Text('No items available '),
//      ));
//    }
  }

  void addToFavorite(Product product) async {
    var _favorite = new Favorite();
    _favorite.product = product;
//    _favorite.options = product.options.where((Option _option) {
//      return _option.checked;
//    }).toList();

    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This product was added to favorite'),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    setState(() {
      this.favorites.remove(_favorite);
    });
    removeFavorite(_favorite).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(_favorite.product.name))
      );
    });
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
    listenForFavorite(productId: _id);
    listenForProduct(productId: _id, message: 'Product refreshed successfully');
  }

  void calculateTotal() {
//    total = product?.price ?? 0;
//    product.options.forEach((option) {
//      total += option.checked ? option.price : 0;
//    });
//    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
//    if (this.quantity < double.parse(product.itemsAvailable)) {
//      ++this.quantity;
//      calculateTotal();
//    }
  }

  decrementQuantity() {
//    if (this.quantity > 1) {
//      --this.quantity;
//      calculateTotal();
//    }
  }

}
