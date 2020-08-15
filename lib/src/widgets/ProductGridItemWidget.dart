//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';

import '../../src/helpers/helper.dart';

import '../../src/models/product.dart';
import '../../src/models/route_argument.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class ProductGridItemWidget extends StatelessWidget {
  const ProductGridItemWidget({
    Key key,
    @required this.product,
    @required this.heroTag,
  }) : super(key: key);

  final Product product;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(param: [this.product, this.heroTag], id: this.product.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: this.heroTag + product.id,
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
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Helper.getPrice(
                        product.price,
                        context,
                        style: Theme.of(context).textTheme.display1,
                      ),
                  ),
                  Row(
                      children: <Widget>[
                        Text(
                          product.rate,
                          style: Theme.of(context).textTheme.body2,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
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
}
