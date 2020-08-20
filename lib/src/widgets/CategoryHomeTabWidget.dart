import '../../generated/l10n.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/models/category.dart';
import '../../src/widgets/FlashSalesCarouselWidget.dart';
import '../../src/widgets/HomePromotionsSlider.dart';
import 'package:flutter/material.dart';

import 'FlashSalesWidget.dart';

class CategoryHomeTabWidget extends StatefulWidget {
  Category category;
  CategoryHomeTabWidget({this.category});

  @override
  _CategoryHomeTabWidgetState createState() => _CategoryHomeTabWidgetState();
}

class _CategoryHomeTabWidgetState extends StateMVC<CategoryHomeTabWidget> {
  HomeController _con;

  _CategoryHomeTabWidgetState(): super( HomeController()){
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.folder_1,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              widget.category.name,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        HomePromotionsSlider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: Icon(
              UiIcons.favorites,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              S.of(context).description,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              '${widget.category.description}',
            )
        ),
        FlashSalesHeaderWidget(),
        FlashSalesCarouselWidget(heroTag: 'category_featured_products', productsList:_con.trendingProducts),
      ],
    );
  }
}
