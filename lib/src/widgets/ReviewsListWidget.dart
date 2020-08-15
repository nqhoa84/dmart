import '../../src/controllers/product_controller.dart';
import '../../src/controllers/reviews_controller.dart';
import '../../src/models/product.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/widgets/ReviewItemWidget.dart';

import '../../src/models/review.dart';

import '../../src/widgets/ReviewItemWidget.dart';
import 'package:flutter/material.dart';

import 'CircularLoadingWidget.dart';

// ignore: must_be_immutable
class ReviewsListWidget extends StatefulWidget {
  Product product;
  ReviewsListWidget({
    Key key,this.product
  }) : super(key: key);

  @override
  _ReviewsListWidget createState() => _ReviewsListWidget();
}

class _ReviewsListWidget extends StateMVC<ReviewsListWidget> {
  ProductController _con;

  _ReviewsListWidget() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.product.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.product.productReviews.isEmpty
        ? CircularLoadingWidget(height: 200)
        : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (context, index) {
              return ReviewItemWidget(
                  review: widget.product.productReviews.elementAt(index)
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 30,
              );
            },
            itemCount: widget.product.productReviews.length,
            primary: false,
            shrinkWrap: true,
          );
  }
}
