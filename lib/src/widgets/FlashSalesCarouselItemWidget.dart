//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';

import '../controllers/map_controller.dart';
import 'package:flutter/cupertino.dart';
import '../../src/helpers/helper.dart';

import '../../src/models/product.dart';
import '../../src/models/route_argument.dart';
import 'package:flutter/material.dart';

import 'AvailableProgressBarWidget.dart';

class FlashSalesCarouselItemWidget extends StatelessWidget {
  String heroTag;
  double marginLeft;
  Product product;

  FlashSalesCarouselItemWidget({
    Key key,
    this.heroTag,
    this.marginLeft,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments:
                new RouteArgument(id: product.id, param: [product, heroTag]));
      },
      child: Container(
        margin: EdgeInsets.only(left: this.marginLeft, right: 20),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Hero(
              tag: heroTag + product.id.toString(),
              child: Container(
                width: 160,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
//                  child: CachedNetworkImage(
//                    fit: BoxFit.cover,
//                    imageUrl: product.image.thumb,
//                    placeholder: (context, url) => Image.asset(
//                      'assets/img/loading.gif',
//                      fit: BoxFit.cover,
//                    ),
//                    errorWidget: (context, url, error) => Icon(Icons.error),
//                  ),
                  child: createNetworkImage(url: product.image.thumb),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 170),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              width: 140,
              height: 113,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.15),
                        offset: Offset(0, 3),
                        blurRadius: 10)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            child: Helper.getPrice(
                              product.price,
                              context,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              product.rate,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],

                  ),
                  SizedBox(height: 9),
                  product.itemsAvailable.isEmpty
                      ?Text(
                        '0 Available',
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.ellipsis,
                      )
                      :Text(
                        '${product.itemsAvailable} Available',
                        style: Theme.of(context).textTheme.bodyText2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  /*product.itemsAvailable.isEmpty
                      ? AvailableProgressBarWidget(available:0.0)
                      : AvailableProgressBarWidget(available:double.parse(product.itemsAvailable)),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
