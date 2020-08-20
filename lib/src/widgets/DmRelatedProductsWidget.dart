
import 'package:dmart/src/models/product.dart';
import 'package:flutter/material.dart';

import 'ProductItemWide.dart';
import 'ProductsGridLoadingWidget.dart';

class DmRelatedProductsWidget extends StatelessWidget {
  List<Product> productsList;
  final Animation animationOpacity;

  DmRelatedProductsWidget({
    Key key,
    this.productsList,
    this.animationOpacity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return productsList == null || productsList.isEmpty ?
    ProductsGridLoadingWidget():
    Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        height: width / 3 * 2,
        width: double.infinity,
        child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            crossAxisSpacing: 1.5,
            childAspectRatio: 120 / 337,
            children: List.generate(productsList.length, (index) {
              Product product = productsList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ProductItemWide(
                    product: product,
                    heroTag: 'related_products',
//                        amountInCart: 10,
                  ),
                ),
              );
            },
            )));
  }

}
