import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesIconsCarouselLoadingWidget extends StatelessWidget{

  const CategoriesIconsCarouselLoadingWidget({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
   return Container(
     height: 65,
     child: Image.asset(
      'assets/img/loading_categories.gif',
       //fit: BoxFit.contain
    ),
   );
  }

}