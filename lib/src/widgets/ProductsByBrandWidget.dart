import 'package:dmart/src/widgets/ProductItemHigh.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/brand.dart';
import '../../src/models/product.dart';
import 'toolbars/SearchBar.dart';
import 'package:flutter/material.dart';

class ProductsByBrandWidget extends StatefulWidget {
  Brand brand;

  ProductsByBrandWidget({Key? key, required this.brand}) : super(key: key);

  @override
  _ProductsByBrandWidgetState createState() => _ProductsByBrandWidgetState();
}

class _ProductsByBrandWidgetState extends StateMVC<ProductsByBrandWidget> {
  ProductController _con = ProductController();

  _ProductsByBrandWidgetState() : super(ProductController()) {
    _con = controller as ProductController;
  }
  String layout = 'grid';

  @override
  void initState() {
    // TODO: implement initState
    _con.listenForProductsByBrand(id: widget.brand.id);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SearchBar(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(UiIcons.box, color: Theme.of(context).hintColor),
            title: Text(
              '${widget.brand.name}' + ' ' + S.current.products,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.headline4,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      this.layout = 'list';
                    });
                  },
                  icon: Icon(
                    Icons.format_list_bulleted,
                    color: this.layout == 'list'
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).focusColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      this.layout = 'grid';
                    });
                  },
                  icon: Icon(
                    Icons.apps,
                    color: this.layout == 'grid'
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).focusColor,
                  ),
                )
              ],
            ),
          ),
        ),
        Offstage(
          offstage: this.layout != 'list',
          child: _con.brandsProducts!.isEmpty
              ? CircularLoadingWidget(
                  height: 200,
                )
              : ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.brandsProducts!.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    // TODO replace with products list item
                    Product product = _con.brandsProducts!.elementAt(index);
                    return ProductItemWide(
                      heroTag: 'products_by_brand_list',
                      product: product,
                    );
                  },
                ),
        ),
        Offstage(
          offstage: this.layout != 'grid',
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _con.brandsProducts!.isEmpty
                ? CircularLoadingWidget(
                    height: 200,
                  )
                : StaggeredGrid.count(
                    // primary: false,
                    // shrinkWrap: true,
                    crossAxisCount: 4,
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                    children: [
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Product product =
                              _con.brandsProducts!.elementAt(index);
                          return ProductItemHigh(
                            product: product,
                            heroTag: 'products_by_brand_grid',
                          );
                        },
                        itemCount: _con.brandsProducts!.length,
                      )
                    ],
//                     itemCount: _con.brandsProducts.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       Product product = _con.brandsProducts.elementAt(index);
//                       return ProductItemHigh(
//                         product: product,
//                         heroTag: 'products_by_brand_grid',
//                       );
//                     },
// //                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
//                     staggeredTileBuilder: (int index) =>
//                         new StaggeredTile.fit(2),
                  ),
          ),
        ),
      ],
    );
  }
}
