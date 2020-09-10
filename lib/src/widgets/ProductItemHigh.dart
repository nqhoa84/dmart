//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../src/helpers/helper.dart';
import '../../src/models/product.dart';
import '../../src/models/route_argument.dart';

class ProductItemHigh extends StatelessWidget {
  ProductItemHigh({Key key, @required Product product, @required String heroTag,
  this.amountInCart = 0}) : super(key: key) {
    this.product = product;
    this.heroTag = '$heroTag' + '_H_${product.id}';
  }
  Product product;
  String heroTag;
  final int amountInCart;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(param: [this.product, heroTag], id: this.product.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: _createDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
//                child: CachedNetworkImage(
//                  fit: BoxFit.cover,
//                  imageUrl: product.image.thumb,
//                  placeholder: (context, url) => Image.asset(
//                    'assets/img/loading.gif',
//                    fit: BoxFit.cover,
//                  ),
//                  errorWidget: (context, url, error) => Icon(Icons.error),
//                ),
                child: createNetworkImage(url: product.image.thumb),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Text(product.name, style: Theme.of(context).textTheme.bodyText1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Helper.getPrice(product.price, context, style: Theme.of(context).textTheme.headline5),
                  ),
                  Row(
                    children: <Widget>[
                      Text(product.rate, style: Theme.of(context).textTheme.bodyText1),
                      Icon(Icons.star, color: Colors.amber, size: 16)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
  BoxDecoration _createDecoration() {
    return this.amountInCart > 0
        ? BoxDecoration(
      border: Border.all(color: DmConst.accentColor),
      color: DmConst.accentColor,
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(
            color: DmConst.productShadowColor,
            blurRadius: 7,
            offset: Offset(6, 6))
      ],
    )
        : BoxDecoration(
      border: Border.all(color: DmConst.accentColor),
      borderRadius: BorderRadius.circular(6),
      color: DmConst.accentColor,
    );
  }
}
