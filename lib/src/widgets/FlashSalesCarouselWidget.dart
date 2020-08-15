import '../../src/models/product.dart';
import '../../src/widgets/FlashSalesCarouselItemWidget.dart';
import 'package:flutter/material.dart';

import 'DmProductItem.dart';
import 'ProductsCarouselLoaderWidget.dart';
import 'ProductsGridLoadingWidget.dart';

class FlashSalesCarouselWidget extends StatelessWidget {
  List<Product> productsList;
  String heroTag;

  FlashSalesCarouselWidget({
    Key key,
    this.productsList,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productsList.isEmpty
    ? ProductsCarouselLoaderWidget()
    :Container(
        height: 300,
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: productsList.length,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            return FlashSalesCarouselItemWidget(
              heroTag: this.heroTag+UniqueKey().toString(),
              marginLeft: _marginLeft,
              product: productsList.elementAt(index),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }

}
