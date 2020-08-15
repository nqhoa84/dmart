import 'package:dmart/constant.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget createNetworkImage({String url, double width, double height, BoxFit fit = BoxFit.cover}) {
//  return CachedNetworkImage(
//    height: 80,
//    width: 80,
//    fit: BoxFit.cover,
//    imageUrl: url,
//    placeholder: (context, url) => Image.asset(
//      'assets/img/loading.gif',
//      fit: BoxFit.cover,
//      height: 80,
//      width: 80,
//    ),
//    errorWidget: (context, url, error) =>
//        Icon(Icons.error),
//  );
  return Image.network(
    url,
    width: width,
    height: height,
    fit: BoxFit.cover,
//    loadingBuilder: (ctx, wid, event) {
//      return Image.asset(
//        'assets/img/loading.gif',
//        fit: BoxFit.cover,
//        height: height,
//        width: width,
//      );
//    },
      errorBuilder: (ctx, obj, trace) {
        return Icon(Icons.error);
      },
  );
}

Widget createFavoriteIcon(BuildContext context, bool isFav) {
//  return Image.asset(
//      isFav ? 'assets/img/Favourite_01.png'
//          : 'assets/img/Favourite.png',
//      fit: BoxFit.scaleDown);
    return isFav ? Icon(Icons.favorite, color: DmConst.colorFavorite)
        : Icon(Icons.favorite_border, color: DmConst.colorFavorite);
}
