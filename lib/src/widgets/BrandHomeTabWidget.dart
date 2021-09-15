import '../../generated/l10n.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/models/brand.dart';
import '../../src/widgets/FlashSalesCarouselWidget.dart';
import '../../src/widgets/HomePromotionsSlider.dart';
import 'package:flutter/material.dart';

import 'FlashSalesWidget.dart';

class BrandHomeTabWidget extends StatefulWidget {
  Brand brand;
  BrandHomeTabWidget({this.brand});

  @override
  _BrandHomeTabWidgetState createState() => _BrandHomeTabWidgetState();
}

class _BrandHomeTabWidgetState extends StateMVC<BrandHomeTabWidget> {
  HomeController _con;

  _BrandHomeTabWidgetState(): super( HomeController()){
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
              UiIcons.flag,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              widget.brand.name,
              style: Theme.of(context).textTheme.headline4,
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
              S.current.description,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            '${widget.brand.description}',
          )
        ),
        FlashSalesHeaderWidget(),
        FlashSalesCarouselWidget(heroTag: 'brand_featured_products', productsList:_con.trendingProducts),
      ],
    );
  }
}
