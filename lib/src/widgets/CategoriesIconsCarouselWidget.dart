import '../widgets/CategoriesIconsCarouselLoadingWidget.dart';

import '../controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/ui_icons.dart';
import '../models/category.dart';

import '../widgets/CategoryIconWidget.dart';
import 'package:flutter/material.dart';


class CategoriesIconsCarouselWidget extends StatefulWidget {
  List<Category> categoriesList;
  String heroTag;
  ValueChanged<String> onChanged;

  CategoriesIconsCarouselWidget({Key key, this.categoriesList, this.heroTag, this.onChanged}) : super(key: key);

  @override
  _CategoriesIconsCarouselWidgetState createState() => _CategoriesIconsCarouselWidgetState();
}

class _CategoriesIconsCarouselWidgetState extends StateMVC<CategoriesIconsCarouselWidget> {

  ProductController _con;
  _CategoriesIconsCarouselWidgetState() : super(ProductController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return widget.categoriesList.isEmpty
      ? CategoriesIconsCarouselLoadingWidget()
      : SizedBox(
        height: 65,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(1),
                borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(60), topEnd: Radius.circular(60))
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/Categories');
                },
                icon: Icon(
                  UiIcons.settings_2,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(left: 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withOpacity(1),
                    //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), topLeft: Radius.circular(60)),
                    borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(60), topStart: Radius.circular(60))
                  ),
                  child: ListView.builder(
                    itemCount: widget.categoriesList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      double _marginLeft = 0;
                      (index == 0) ? _marginLeft = 12 : _marginLeft = 0;
                      return CategoryIconWidget(
                          heroTag: widget.heroTag+UniqueKey().toString(),
                          marginLeft: _marginLeft,
                          category: widget.categoriesList.elementAt(index),
                          onPressed: (String id) {
                            setState(() {
                              _con.selectCategoryById(widget.categoriesList,id);
                              widget.onChanged(id);
                            });
                          });
                    },
                    scrollDirection: Axis.horizontal,
                  )),
            ),
          ],
        ),
      );
  }
}
