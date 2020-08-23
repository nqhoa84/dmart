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
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  List<Review> reviews = <Review>[];
  List<Product> brandsProducts=[];
  List<Product> categoriesProducts=[];
  List<Favorite> favorites = <Favorite>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  selectBrandById(List<Brand> brands, String id) {
    brands.forEach((Brand brand) {
      brand.selected = false;
      if (brand.id == id) {
        brand.selected = true;
      }
    });
  }

  selectCategoryById( List<Category> categories, String id) {
    categories.forEach((Category category) {
      category.selected = false;
      if (category.id == id) {
        category.selected = true;
      }
    });
  }
  Future<void> refreshFavorites() async {
    favorites.clear();
    listenForFavorites(message: 'Favorites refreshed successfuly');
  }

  void listenForFavorites({String message}) async {
    final Stream<Favorite> stream = await getFavorites();
    stream.listen((Favorite _favorite) {
      setState(() {
        favorites.add(_favorite);

      });
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

  void listenForProduct({String productId, String message}) async {
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

  void listenForProductsByBrand({String id, String message}) async {
    final Stream<Product> stream = await getProductsByBrand(id);
    stream.listen((Product _product) {
      setState(() {
        brandsProducts.add(_product);
      });
    }, onError: (a) {
      print(a);
    });
  }

  void listenForProductsByCategory({String id, String message}) async {
    final Stream<Product> stream = await getProductsByCategory(id);
    stream.listen((Product _product) {
      setState(() {
        categoriesProducts.add(_product);
      });
    }, onError: (a) {
      print(a);
    });
  }

  void listenForFavorite({String productId}) async {
    final Stream<Favorite> stream = await isFavoriteProduct(productId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
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

  void addToCart(Product product, {bool reset = false}) async {

    var _newCart = new Cart();
    _newCart.quantity = this.quantity;
    // if quantity more than Items Available
    if(double.parse(product.itemsAvailable) >=_newCart.quantity){
      setState(() {
        this.loadCart = true;
      });
      _newCart.product = product;
      if(product.options !=null){
        _newCart.options = product.options.where((element) => element.checked).toList();
        // if product exist in the cart then increment quantity
        var _oldCart = isExistInCart(_newCart);
        if (_oldCart != null) {
          if(_oldCart.quantity+this.quantity <= double.parse(product.itemsAvailable)){
            _oldCart.quantity += this.quantity;
            updateCart(_oldCart).then((value) {
              setState(() {
                this.loadCart = false;
              });
            }).whenComplete(() {
              scaffoldKey?.currentState?.showSnackBar(SnackBar(
                content: Text(S.of(context).productAdded2Cart),
              ));
            });
          }else{
            setState(() {
              this.loadCart = false;
            });
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text('No items available '),

            ));
          }

        } else {
          // the product doesnt exist in the cart add new one
          addCart(_newCart, reset).then((value) {
            setState(() {
              this.loadCart = false;
            });
          }).whenComplete(() {
            scaffoldKey?.currentState?.showSnackBar(SnackBar(
              content: Text(S.of(context).productAdded2Cart),
            ));
          });
        }
      }
    }else{
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('No items available '),
      ));
    }




  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart), orElse: () => null);
  }

  void addToFavorite(Product product) async {
    var _favorite = new Favorite();
    _favorite.product = product;
    _favorite.options = product.options.where((Option _option) {
      return _option.checked;
    }).toList();
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

  void listenForProductReviews({String id, String message}) async {
    final Stream<Review> stream = await getProductReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> refreshProduct() async {
    var _id = product.id;
    product = new Product();
    listenForFavorite(productId: _id);
    listenForProduct(productId: _id, message: 'Product refreshed successfuly');
  }

  void calculateTotal() {
    total = product?.price ?? 0;
    product.options.forEach((option) {
      total += option.checked ? option.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity < double.parse(product.itemsAvailable)) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
