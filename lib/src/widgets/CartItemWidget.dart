//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';

import '../../generated/l10n.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  double taxAmount;
  CartItemWidget({Key key, this.cart,this.taxAmount, this.heroTag, this.increment, this.decrement, this.onDismissed}) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Product', arguments: new RouteArgument(id: widget.cart.product.id, param: [widget.cart.product, widget.heroTag]));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
//                    child: CachedNetworkImage(
//                      height: 90,
//                      width: 90,
//                      fit: BoxFit.cover,
//                      imageUrl: widget.cart.product.image.thumb,
//                      placeholder: (context, url) => Image.asset(
//                        'assets/img/loading.gif',
//                        fit: BoxFit.cover,
//                        height: 90,
//                        width: 90,
//                      ),
//                      errorWidget: (context, url, error) => Icon(Icons.error),
//                    ),
                    child: createNetworkImage(url: widget.cart.product.image.thumb, width: 90, height: 90),
                  ),
                ],

              ),
              SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.cart.product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Wrap(
                            children: List.generate(widget.cart.options.length, (index) {
                              return Text(
                                widget.cart.options.elementAt(index).name + ', ',
                                style: Theme.of(context).textTheme.caption,
                              );
                            }),
                          ),
                          Helper.getPrice(widget.cart.product.price, context, style: Theme.of(context).textTheme.headline4),
                          Row(
                            children:<Widget>[
                              Text(
                                S.of(context).deliveryFee,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Helper.getPrice(widget.cart.product.store.deliveryFee, context, style: Theme.of(context).textTheme.bodyText2)
                            ]
                          ),
                          Row(
                              children:<Widget>[
                                Text(
                                  '${S.of(context).tax} (${widget.cart.product.store.defaultTax})%',
                                   style: Theme.of(context).textTheme.bodyText2,
                                ),
                                //Helper.getPrice(widget.taxAmount, context, style: Theme.of(context).textTheme.bodyText2)
                              ]
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        Text(widget.cart.quantity.toString(), style: Theme.of(context).textTheme.subtitle1),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 30,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          icon: Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
