import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/controllers/product_controller.dart';
import '../../src/models/category.dart';
import '../../src/models/product.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import '../../src/widgets/ProductItemHigh.dart';

class ProductsByCategory extends StatefulWidget {
  Category category;
  ProductsByCategory({Key key, this.category}) : super(key: key);
  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends StateMVC<ProductsByCategory> {
  ProductController _con;

  _ProductsByCategoryState() : super(ProductController()) {
    _con = controller;
  }

  String layout = 'list';

  @override
  void initState() {
    _con.listenForProductsByCategory(id: widget.category.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
//        Padding(
//          padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
//          child: ListTile(
//            dense: true,
//            contentPadding: EdgeInsets.symmetric(vertical: 0),
//            leading: Icon(UiIcons.box, color: Theme.of(context).hintColor),
//            title: Text('${widget.category.name} ' + S.of(context).products,
//                overflow: TextOverflow.fade, softWrap: false, style: Theme.of(context).textTheme.headline6),
//            trailing: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                IconButton(
//                  onPressed: () {
//                    setState(() {
//                      this.layout = 'list';
//                    });
//                  },
//                  icon: Icon(
//                    Icons.format_list_bulleted,
//                    color: this.layout == 'list' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
//                  ),
//                ),
//                IconButton(
//                  onPressed: () {
//                    setState(() {
//                      this.layout = 'grid';
//                    });
//                  },
//                  icon: Icon(
//                    Icons.apps,
//                    color: this.layout == 'grid' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
        Offstage(
          offstage: this.layout != 'list',
          child: _con.categoriesProducts.isEmpty
              ? CircularLoadingWidget(
                  height: 200
                )
              : GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 1,
                  crossAxisSpacing: 1.5,
                  childAspectRatio: 337.0 / 120,
                  // 120 / 337,
                  children: List.generate(
                    _con.categoriesProducts.length,
                    (index) {
                      Product product = _con.categoriesProducts.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ProductItemWide(product: product, heroTag: 'category_products_grid'),
                      );
                    },
                  ),
                ),
        ),
        Offstage(
          offstage: this.layout != 'grid',
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _con.categoriesProducts.isEmpty
                ? CircularLoadingWidget(
                    height: 200,
                  )
                : new StaggeredGridView.countBuilder(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    itemCount: _con.categoriesProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      Product product = _con.categoriesProducts.elementAt(index);
                      //todo this is legacy class, need customer to design UI.
                      return ProductItemHigh(
                        product: product,
                        heroTag: 'products_by_category_grid',
                      );
                    },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
                    staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                    mainAxisSpacing: 15.0,
                    crossAxisSpacing: 15.0,
                  ),
          ),
        ),
      ],
    );
  }
}

