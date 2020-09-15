import 'dart:math' as math;

import 'package:dmart/DmState.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/controller.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:dmart/src/models/product_order.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../src/repository/user_repository.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductOrderItemWide extends StatefulWidget {
  //TODO need to change to big int?
  static int unique = 0;
  String heroStr;
  ProductOrder po;
  bool isFavorite;

  int amountInCart = 0;

//  Function(int) onPressedOnRemoveIcon;

  ProductOrderItemWide({Key key, @required ProductOrder product, String heroTag})
      : super(key: key) {

    this.po = product;
    this.heroStr = '${heroTag??''}_POW_${product.product.id}.${unique++}';

    this.amountInCart = DmState.countQuantityInCarts(product.id);
    this.isFavorite = DmState.isFavorite(productId: product.id);

//    print('${product.id} is in cart with quality = ${this.amountInCart}');
  }

  @override
  _ProductOrderItemWideState createState() => _ProductOrderItemWideState();
}

class _ProductOrderItemWideState extends StateMVC<ProductOrderItemWide> {
  static const double _width = 550.0, _height = 192.0;
  static const double _tagSize = 50.0 / 550 * _width,
      _photoWid = 200.0 / 550 * _width,
      _icFavWSize = 34.0 / 550 * _width;
  ProductController _con;

  _ProductOrderItemWideState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(
                id: widget.po.product.id, param: [widget.po.product, widget.heroStr]));
      },
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: _createDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 200,
                  child: Stack(
                    children: <Widget>[
                      Hero(
                        tag: widget.heroStr,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: createNetworkImage(url: widget.po.product.image.thumb),
                          ),
                        ),
                      ),
                      widget.po.product.getTagAssetImage() != null
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(widget.po.product.getTagAssetImage(), fit: BoxFit.scaleDown),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
                Flexible(
                  flex: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Text(
                                  '${widget.po.product?.name??''}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              _createFavoriteIcon(context),
                            ],
                          ),
                        ),
                        SizedBox(height: 3),
                        Expanded(
                          flex: 30,
                          child: Center(child: Text( '${getDisplayMoney(widget.po.paidPrice)} x ${widget.po.quantity}')),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _createDecoration() {
    return widget.amountInCart > 0
        ? BoxDecoration(
      border: Border.all(color: DmConst.accentColor),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: DmConst.productShadowColor,
//                  spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(6, 6))
      ],
    )
        : BoxDecoration(
      border: Border.all(color: DmConst.accentColor),
      color: Colors.transparent,
    );
  }

  Widget _createFavoriteIcon(BuildContext context) {
//    return IconButton(
//        icon: widget.isFavorite
//            ? Icon(Icons.favorite, color: DmConst.colorFavorite)
//            : Icon(Icons.favorite_border, color: DmConst.colorFavorite),
//        onPressed: _onTapIconFav);
    return InkWell(
      onTap: _onTapIconFav,
      child: widget.isFavorite
          ? Icon(Icons.favorite, color: DmConst.colorFavorite)
          : Icon(Icons.favorite_border, color: DmConst.colorFavorite),
    );
  }

  bool _isDoing = false;

  void _onTapIconFav() {
    if (_isDoing) return;
    _isDoing = true;
    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });

    if (widget.isFavorite) {
      _con.addToFavorite(widget.po.product, onDone: (isOK){
//        setState(() {
//          widget.isFavorite = DmState.isFavorite(productId: widget.product?.id);
//        });
      });
    } else {
      Favorite mark;
      DmState.favorites.forEach((element) {
        if (element.product.id == widget.po.product.id) {
          mark = element;
          return;
        }
      });
      if (mark != null) {
        _con.removeFromFavorite(mark);
      }
    }
    _isDoing = false;
  }
}
