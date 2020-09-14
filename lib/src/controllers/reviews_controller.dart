import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../repository/store_repository.dart' as brandRepo;
import '../repository/order_repository.dart';
import '../repository/product_repository.dart' as productRepo;

class ReviewsController extends ControllerMVC {
  Review storeReview;
  Review productReview;
  List<Review> productsReviews = [];
  Order order;
  List<Product> productsOfOrder = [];
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ReviewsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.storeReview = new Review.init("0");
    this.productReview = new Review.init("0");
  }

  void listenForOrder({int orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        productsReviews = List.generate(order.productOrders.length, (_) => new Review.init("0"));
      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    }, onDone: () {
      getProductsOfOrder();
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addProductReview(Review _review, Product _product) async {
    productRepo.addProductReview(_review, _product).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('the_product_has_been_rated_successfully'),
      ));
    });
  }

  void addStoreReview(Review _review) async {
    brandRepo.addStoreReview(_review, this.order.productOrders[0].product.store).then((value) {
      refreshOrder();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('the_store_has_been_rated_successfully'),
      ));
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(orderId: order.id, message: 'reviews_refreshed_successfully');
  }

  void getProductsOfOrder() {
    this.order.productOrders.forEach((_productOrder) {
      if (!productsOfOrder.contains(_productOrder.product)) {
        productsOfOrder.add(_productOrder.product);
      }
    });
  }
}
