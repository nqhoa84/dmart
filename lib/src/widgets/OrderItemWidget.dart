//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/product_order.dart';
import '../models/route_argument.dart';

class OrderItemWidget extends StatelessWidget {
  final String heroTag;
  final ProductOrder productOrder;
  final Order order;

  const OrderItemWidget(
      {Key? key,
      required this.productOrder,
      required this.order,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      focusColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Tracking',
            arguments: RouteArgument(id: order.id, heroTag: this.heroTag));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + productOrder.id.toString(),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
//                child: CachedNetworkImage(
//                  height: 60,
//                  width: 60,
//                  fit: BoxFit.cover,
//                  imageUrl: productOrder.product.image.thumb,
//                  placeholder: (context, url) => Image.asset(
//                    'assets/img/loading.gif',
//                    fit: BoxFit.cover,
//                    height: 60,
//                    width: 60,
//                  ),
//                  errorWidget: (context, url, error) => Icon(Icons.error),
//                ),
                child: createNetworkImage(
                    url: productOrder.product!.image!.thumb!,
                    width: 60,
                    height: 60),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          productOrder.product!.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          productOrder.product!.store!.name,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
//                        Text(
//                          '${order.payment.method}',
//                          overflow: TextOverflow.ellipsis,
//                          style: Theme.of(context).textTheme.bodyText2,
//                        ),
                        SizedBox(height: 10),
//                        Text(
//                          DateFormat('yyyy-MM-dd').format(productOrder),
//                          style: Theme.of(context).textTheme.bodyText2,
//                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Helper.getPrice(
                          Helper.getTotalOrderPrice(
                              productOrder, order.tax, order.deliveryFee),
                          context,
                          style: Theme.of(context).textTheme.headline4),
                      //SizedBox(height:8),
                      Chip(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        backgroundColor: Colors.transparent,
                        shape: StadiumBorder(
                            side: BorderSide(
                                color: Theme.of(context).focusColor)),
                        label: Text(
                          'X ${productOrder.quantity}',
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ),
                      ),
//                      Text(
//                        DateFormat('HH:mm').format(productOrder.dateTime),
//                        style: Theme.of(context).textTheme.bodyText2,
//                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
