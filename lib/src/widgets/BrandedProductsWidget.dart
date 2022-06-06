import 'package:dmart/src/widgets/ProductItemHigh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../src/controllers/product_controller.dart';
import '../../src/models/brand.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/models/product.dart';
import 'package:flutter/material.dart';

import 'ProductItemWide.dart';
import 'ProductsGridViewLoading.dart';

class BrandedProductsWidget extends StatefulWidget {
  final String? heroTag;
  final Animation<double> animationOpacity;
  final Brand? brand;

  const BrandedProductsWidget(
      {Key? key,
      required this.animationOpacity,
      required this.brand,
      this.heroTag = 'brand'})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BrandedProductsWidget();
}

class _BrandedProductsWidget extends StateMVC<BrandedProductsWidget> {
  ProductController _con = ProductController();

  _BrandedProductsWidget() : super(ProductController()) {
    _con = controller as ProductController;
  }

  @override
  void initState() {
    _con.listenForProductsByBrand(id: widget.brand!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return _con.brandsProducts!.isEmpty
        ? ProductsGridViewLoading()
        : FadeTransition(
            opacity: widget.animationOpacity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: width / 3 * 2,
              width: double.infinity,
              child: GridView.count(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                crossAxisCount: 2,
                crossAxisSpacing: 1.5,
                childAspectRatio: 120 / 337,
                children: List.generate(
                  _con.brandsProducts!.length,
                  (index) {
                    Product product = _con.brandsProducts!.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
//                  height: 100,
//                  width: 100*550/192,
                        child: ProductItemWide(
                          product: product,
                          heroTag: '${widget.heroTag}_${product.id}',
//                        amountInCart: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
  }

  Widget _build(BuildContext context) {
    return _con.brandsProducts!.isEmpty
        ? ProductsGridViewLoading()
        : FadeTransition(
            opacity: widget.animationOpacity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: new StaggeredGrid.count(
                crossAxisCount: 4,
                children: [
                  ListView.builder(
                    itemCount: _con.brandsProducts!.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Product product = _con.brandsProducts!.elementAt(index);
                      return ProductItemHigh(
                        product: product,
                        heroTag: 'branded_products_grid',
                      );
                    },
                  )
                ],
                // itemCount: _con.brandsProducts.length,
                // itemBuilder: (BuildContext context, int index) {
                //   Product product = _con.brandsProducts.elementAt(index);
                //   return ProductItemHigh(
                //     product: product,
                //     heroTag: 'branded_products_grid',
                //   );
                // },
                // staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
            ),
          );
  }
}
