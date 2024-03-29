import 'package:flutter/material.dart';

class ProductsCarouselLoaderWidget extends StatelessWidget {
  const ProductsCarouselLoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            double _marginLeft = 0;
            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
            return Container(
              margin: EdgeInsetsDirectional.only(start: _marginLeft, end: 20),
              width: 160,
              height: 275,
              child: Image.asset('assets/img/loading_trend.gif', fit: BoxFit.contain),
            );
          },
          scrollDirection: Axis.horizontal,
        ));
  }
}
