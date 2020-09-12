import 'package:dmart/constant.dart';

import '../helpers/helper.dart';
import '../models/route_argument.dart';

import '../../generated/l10n.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/helpers/ui_icons.dart';
import '../../src/models/product.dart';
import '../../src/widgets/FlashSalesCarouselWidget.dart';
import 'package:flutter/material.dart';

import 'DmRelatedProductsWidget.dart';


///Dispplay product description in Html and load related products.
class ProductDetailsTabWidget extends StatefulWidget {
  Product product;

  ProductDetailsTabWidget({this.product});

  @override
  ProductDetailsTabWidgetState createState() => ProductDetailsTabWidgetState();
}

class ProductDetailsTabWidgetState extends StateMVC<ProductDetailsTabWidget> {
  ProductController _con;
  ProductDetailsTabWidgetState() :super(ProductController()){
    _con = controller;
  }
  @override
  void initState() {
//    _con.listenForFeaturedProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon( UiIcons.file_2),
            title: Text(S.of(context).description,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child:Helper.applyHtml(context, widget.product.description)
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Divider(thickness: 2),
                ),
              ),
              Text(S.of(context).relatedProducts,
                  style: Theme.of(context).textTheme.headline6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Divider(thickness: 2),
                ),
              ),
            ],
          ),
        ),
        DmRelatedProductsWidget(productsList: _con.relatedProducts),
      ],
    );
  }
}

