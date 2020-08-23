import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../../src/helpers/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/models/product.dart';
import 'package:flutter/material.dart';

import 'CircularLoadingWidget.dart';
import 'OptionItemWidget.dart';

class ProductHomeTabWidget extends StatefulWidget {
  Product product;

  ProductHomeTabWidget({this.product});

  @override
  productHomeTabWidgetState createState() => productHomeTabWidgetState();
}

class productHomeTabWidgetState extends StateMVC<ProductHomeTabWidget> {
  ProductController _con;

  productHomeTabWidgetState() : super(ProductController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Chip(
                padding: EdgeInsets.all(0),
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(S.of(context).featured,
                        style: Theme.of(context).textTheme.bodyText1.merge(
                            TextStyle(color: Theme.of(context).primaryColor))),
                    Icon(
                      Icons.star_border,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Helper.getPrice(
                    widget.product.price,
                    context,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  widget.product.discountPrice > 0
                      ? Helper.getPrice(widget.product.discountPrice, context,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .merge(TextStyle(decoration: TextDecoration.lineThrough)))
                      : SizedBox(height: 0),
                ],
              ),
              SizedBox(width: 10),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: BorderRadius.circular(24)),
                  child:Text(
                        widget.product.packageItemsCount + " " + S.of(context).items,
                        style: Theme.of(context).textTheme.bodyText2
                  )
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                    color:
                        widget.product.deliverable ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(24)),
                child: widget.product.deliverable
                    ? Text('deliverable',
                        style: Theme.of(context).textTheme.caption.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      )
                    : Text('not_deliverable',
                        style: Theme.of(context).textTheme.caption.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      ),
              ),
              Expanded(child: SizedBox(height: 0)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: BorderRadius.circular(24)),
                  child: Text(
                    widget.product.capacity + " " + widget.product.unit,
                    style: Theme.of(context).textTheme.caption.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            leading: Icon(
              Icons.add_circle,
              color: Theme.of(context).hintColor,
            ),
            title: Text(
              S.of(context).options,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: Text(
              S.of(context).select_options_to_add_them_on_the_product,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.product.optionGroups == null
                    ? CircularLoadingWidget(height: 100)
                    : ListView.separated(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, optionGroupIndex) {
                    var optionGroup = widget.product.optionGroups.elementAt(optionGroupIndex);
                    return Wrap(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.add_circle_outline,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            optionGroup.name,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListView.separated(
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, optionIndex) {
                            return OptionItemWidget(
                              option: widget.product.options
                                  .where((option) => option.optionGroupId == optionGroup.id)
                                  .elementAt(optionIndex),
                              onChanged: _con.calculateTotal,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                          itemCount: widget.product.options
                              .where((option) => option.optionGroupId == optionGroup.id)
                              .length,
                          primary: false,
                          shrinkWrap: true,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: widget.product.optionGroups.length,
                  primary: false,
                  shrinkWrap: true,
                ),
                SizedBox(height: 10),
                //SelectColorWidget()
              ],
            ),
        ),
      ],
    );
  }
}
