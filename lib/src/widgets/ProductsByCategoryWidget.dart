import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/category.dart';
import '../../src/models/product.dart';
import '../../src/widgets/ProductGridItemWidget.dart';
import '../../src/widgets/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'ProductListItemWidget.dart';

class ProductsByCategoryWidget extends StatefulWidget {
  Category category;

  ProductsByCategoryWidget({Key key, this.category}) : super(key: key);

  @override
  _ProductsByCategoryWidgetState createState() => _ProductsByCategoryWidgetState();
}

class _ProductsByCategoryWidgetState extends StateMVC<ProductsByCategoryWidget> {
  ProductController _con;

  _ProductsByCategoryWidgetState() : super(ProductController()){
    _con = controller;
  }
  String layout = 'grid';

  @override
  void initState() {
    // TODO: implement initState
    _con.listenForProductsByCategory(id: widget.category.id);
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SearchBarWidget(
            onClickFilter: (event) {
              _con.scaffoldKey.currentState.openEndDrawer();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.box,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              '${widget.category.name} '+ S.of(context).products,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.display1,
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
                    color: this.layout == 'list' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
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
                    color: this.layout == 'grid' ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                  ),
                )
              ],
            ),
          ),
        ),
        Offstage(
          offstage: this.layout != 'list',
          child: _con.categoriesProducts.isEmpty?CircularLoadingWidget(height: 200,):ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount: _con.categoriesProducts.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              // TODO replace with products list item
              Product product = _con.categoriesProducts.elementAt(index);
              return  ProductListItemWidget(
                heroTag: 'products_by_category_list',
                product: product,
                onDismissed: () {
                  setState(() {
                    _con.categoriesProducts.removeAt(index);
                  });
                },
              );
            },
          ),
        ),
        Offstage(
          offstage: this.layout != 'grid',
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _con.categoriesProducts.isEmpty?CircularLoadingWidget(height: 200,):new StaggeredGridView.countBuilder(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 4,
              itemCount: _con.categoriesProducts.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = _con.categoriesProducts.elementAt(index);
                return ProductGridItemWidget(
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
