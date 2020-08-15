import '../../src/controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/helpers/ui_icons.dart';
import '../../src/models/brand.dart';
import '../../src/widgets/BrandIconWidget.dart';
import 'package:flutter/material.dart';

import 'BrandsIconsCarouselLoadingWidget.dart';

class BrandsIconsCarouselWidget extends StatefulWidget {
  List<Brand> brandsList;
  String heroTag;
  ValueChanged<String> onChanged;

  BrandsIconsCarouselWidget({Key key, this.brandsList, this.heroTag, this.onChanged}) : super(key: key);

  @override
  _BrandsIconsCarouselWidgetState createState() => _BrandsIconsCarouselWidgetState();
}

class _BrandsIconsCarouselWidgetState extends StateMVC<BrandsIconsCarouselWidget> {
  ProductController _con;

  _BrandsIconsCarouselWidgetState() :super(ProductController()){
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return widget.brandsList.isEmpty?BrandsIconsCarouselLoadingWidget()
        :SizedBox(
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withOpacity(1),
                      //borderRadius: BorderRadius.only(bottomRight: Radius.circular(60), topRight: Radius.circular(60)),
                        borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(60), topEnd: Radius.circular(60))

                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.brandsList.length,
                      itemBuilder: (context, index) {
                        double _marginLeft = 0;
                        (index == 0) ? _marginLeft = 12 : _marginLeft = 0;
                        return BrandIconWidget(
                            heroTag: widget.heroTag+UniqueKey().toString(),
                            marginLeft: _marginLeft,
                            brand: widget.brandsList.elementAt(index),
                            onPressed: (String id) {
                              setState(() {
                                _con.selectBrandById(widget.brandsList,id);
                                widget.onChanged(id);
                              });
                            });
                      },
                      scrollDirection: Axis.horizontal,
                    )),
              ),
              Container(
                width: 80,
                margin: EdgeInsets.only(left: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor.withOpacity(1),
                    borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(60), topStart: Radius.circular(60))
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/Brands');
                  },
                  icon: Icon(
                    UiIcons.settings_2,
                    size: 28,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
