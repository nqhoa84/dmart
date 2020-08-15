import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandsIconsCarouselLoadingWidget extends StatelessWidget{

  const BrandsIconsCarouselLoadingWidget({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      child: Image.asset(
        'assets/img/loading_brands.gif',
        //fit: BoxFit.contain
      ),
    );
  }

}