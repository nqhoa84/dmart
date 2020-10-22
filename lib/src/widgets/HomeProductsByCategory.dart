
import '../../src/controllers/product_controller.dart';
import '../../src/models/category.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/models/product.dart';
import '../../src/widgets/ProductItemHigh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'CircularLoadingWidget.dart';
import '../../src/widgets/ProductsGridViewLoading.dart';
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
    return FadeTransition(
      opacity: animationOpacity,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          height: width / 3 * 2,
          width: double.infinity,
          child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 2,
              crossAxisSpacing: 1.5,
              childAspectRatio: 120 / 337,
              children: List.generate(products.length, (index) {
                Product product = products.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: ProductItemWide(
                      product: product,
                      heroTag: hero,
//                        amountInCart: 10,
                    ),
                  ),
                );
              },
              ))),
    );
  }
}


//class HomeProductsByCategory extends StatefulWidget {
//
//  final Animation animationOpacity;
//  final Category category;
//
//  const HomeProductsByCategory (
//      {Key key,  this.animationOpacity,  this.category}) :super(key: key);
//
//  @override
//  State<StatefulWidget> createState () => _CategorizedProductsWidget();
//
//}
//
//class _CategorizedProductsWidget extends StateMVC<HomeProductsByCategory>{
//    ProductController _con;
//
//    _CategorizedProductsWidget() : super(ProductController()) {
//      _con = controller;
//    }
//
//
//    @override
//    void initState() {
////      _con.listenForProductsByCategory(id: widget.category.id);
//      super.initState();
//    }
//
//  @override
//  Widget build(BuildContext context) {
//    double width = MediaQuery.of(context).size.width;
//    return _con.categoriesProducts.isEmpty ?
//      ProductsGridViewLoading():
//      FadeTransition(
//          opacity: widget.animationOpacity,
//          child: Container(
//              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//              height: width / 3 * 2,
//              width: double.infinity,
//              child: GridView.count(
//                scrollDirection: Axis.horizontal,
//                crossAxisCount: 2,
//                crossAxisSpacing: 1.5,
//                childAspectRatio: 120 / 337,
//                children: List.generate(_con.categoriesProducts.length, (index) {
//                  Product product = _con.categoriesProducts.elementAt(index);
//                  return Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Container(
//                      child: ProductItemWide(
//                        product: product,
//                        heroTag: 'categorized_products_grid',
////                        amountInCart: 10,
//                      ),
//                    ),
//                  );
//                },
//              ))),
//    );
//  }
//}
