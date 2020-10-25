
import 'package:dmart/constant.dart';
import 'package:flutter/material.dart';

import '../../src/models/product.dart';
import 'ProductItemWide.dart';

class HomeProductsListView extends StatelessWidget {
  final List<Product> products;
  final String hero;
  final Animation animationOpacity;

  HomeProductsListView({this.products = const [], this.hero = 'home',
    this.animationOpacity
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double space = DmConst.masterHorizontalPad;
    return FadeTransition(
      opacity: animationOpacity,
      child: Container(
          height: width / 3 * 2 + 20,
          width: double.infinity,
          child: GridView.count(
              padding: EdgeInsets.symmetric(horizontal: space, vertical: space),
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              crossAxisSpacing: space,
              mainAxisSpacing: space,
              childAspectRatio: 120 / 337,
              children: List.generate(products.length, (index) {
                Product product = products.elementAt(index);
                return Container(
                  child: ProductItemWide(
                    product: product,
                    heroTag: hero,
//                        amountInCart: 10,
                  ),
                );
              },
              ))),
    );
  }
}

class HomeProductsListViewLoading extends StatelessWidget {

  HomeProductsListViewLoading( );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double space = DmConst.masterHorizontalPad;
    return Container(
        height: width / 3 * 2 + 20,
        width: double.infinity,
        child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: space, vertical: space),
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            crossAxisSpacing: space,
            mainAxisSpacing: space,
            childAspectRatio: 120 / 337,
            children: List.generate(4, (index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: DmConst.accentColor),
                    image: DecorationImage(
                        image: AssetImage('assets/img/loading.gif'), fit: BoxFit.cover
                    )
                ),
              );
            },
            )));
  }
}
