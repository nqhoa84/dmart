import 'dart:math' as math;

import 'package:dmart/DmState.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../constant.dart';
import '../../src/repository/user_repository.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductItemWide extends StatefulWidget {
  //TODO need to change to big int?
  static int unique = 0;
  String heroStr;
  Product product;
  int amountInCart;
  bool isFavorite;
  bool showRemoveIcon;
  double _removeIconSize = 0;

//  Function(int) onPressedOnRemoveIcon;

  ProductItemWide({Key key, @required Product product, String heroTag, this.showRemoveIcon = false}) : super(key: key) {
    if (showRemoveIcon) _removeIconSize = 25;

    this.product = product;
    this.heroStr = '${heroTag ?? ''}_W_${product.id}.${unique++}';
//    print('heroTag $heroStr');

    this.amountInCart = DmState.countQuantityInCarts(product.id);
    this.isFavorite = DmState.isFavorite(productId: product.id);

//    print('${product.id} is in cart with quality = ${this.amountInCart}');
  }

  @override
  _ProductItemWideState createState() => _ProductItemWideState();
}

class _ProductItemWideState extends StateMVC<ProductItemWide> {
//  static const double _width = 550.0, _height = 192.0;
//  static const double _tagSize = 50.0 / 550 * _width,
//      _photoWid = 200.0 / 550 * _width,
//      _icFavWSize = 34.0 / 550 * _width;
  ProductController _con;

  _ProductItemWideState() : super(ProductController()) {
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
      onTap: onTapOnProduct,
      child: Stack(
        children: <Widget>[
          Container(
//            margin: EdgeInsets.only(right: widget.amountInCart > 0 ? 6 : 0),
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
                            child: createNetworkImage(url: widget.product.image.thumb),
                          ),
                        ),
                      ),
                      widget.product.getTagAssetImage() != null
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(widget.product.getTagAssetImage(), fit: BoxFit.scaleDown),
                                  ),
                                  Expanded(flex: 2, child: Container()),
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
                    padding: const EdgeInsets.all(4.0),
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
                                  widget.product?.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              _createFavoriteIcon(context),
                              SizedBox(width: widget._removeIconSize)
                            ],
                          ),
                        ),
                        SizedBox(height: 3),
                        Expanded(
                          flex: 30,
                          child: Center(child: _createAddToCartOrChooseAmount(context)),
                        ),
                        SizedBox(height: 3),
                        Expanded(flex: 25, child: Center(child: this._createPriceWidget(context))),
                        Text('${S.current.available}: ${widget.product.itemsAvailable?? 0}', style: TextStyle(fontSize: 11),),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          widget.showRemoveIcon
              ? Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: Container(
                        padding: EdgeInsets.all(0),
                        color: Theme.of(context).accentColor,
                        child: Icon(Icons.close, size: widget._removeIconSize, color: Colors.white)),
                    onTap: _onTapIconRemove,
                  ))
              : SizedBox(width: 0)
//          _createSaleTag(context),
//          _createFavIcon(context),
        ],
      ),
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

  BoxDecoration _createDecoration() {
    return widget.amountInCart > 0
        ? BoxDecoration(
            border: Border.all(color: DmConst.accentColor),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: DmConst.productShadowColor,
//                  spreadRadius: 5,
//                  blurRadius: 0,
                  offset: Offset(5, 5),
              )
            ],
          )
        : BoxDecoration(
            border: Border.all(color: DmConst.accentColor),
            color: Colors.transparent,
          );
  }

  TextEditingController _textEditingCon = TextEditingController(text: '');

  Widget _createAddToCartOrChooseAmount(BuildContext context) {
    if (widget.amountInCart > 0) {
      _textEditingCon.text = '${widget.amountInCart}';
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: _onTapIconSubtract,
            child: Container(
                decoration: new BoxDecoration(
                  border: Border.all(color: DmConst.accentColor, width: 2),
                  shape: BoxShape.rectangle,
                ),
                child: Center(child: Icon(Icons.remove))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('${widget.amountInCart}'),
          ),
          InkWell(
            onTap: _onTapIconAdd,
            child: Container(
                decoration: new BoxDecoration(
                  border: Border.all(color: DmConst.accentColor, width: 2),
                  shape: BoxShape.rectangle,
                ),
                child: Center(child: Icon(Icons.add))),
          )
        ],
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: 80),
        child: FlatButton(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(S.current.add),
          color: DmConst.accentColor,
          onPressed: _onPressedAdd2Cart,
        ),
      );
    }
  }

  Widget _createPriceWidget(BuildContext context) {
    if (widget.product.isPromotion) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/img/Price_Strikethrough.png'), fit: BoxFit.scaleDown)),
            child: Text('${widget.product.getDisplayOriginalPrice}'),
          ),
          Text(
            '${widget.product.getDisplayPromotionPrice}',
            style: TextStyle(color: DmConst.textColorPromotionPrice),
          ),
        ],
      );
    } else {
      return Text('${widget.product.getDisplayOriginalPrice}');
    }
  }

  void _onPressedAdd2Cart() {
    addCart(1);
  }

  void _onTapIconSubtract() {
    print(' _onTapIconSubtract');
    addCart(-1);
  }

  void addCart(int quantity) {
    if (_isDoing) return;
    bool enable = widget.product.itemsAvailable >= widget.amountInCart + quantity && widget.amountInCart + quantity >= 0;
    if(!enable) return;
    if (currentUser.value.isLogin) {
      _con.addCartGeneral(widget.product.id, quantity, onDone: (isOK) {
        _isDoing = false;
        setState(() {
          widget.amountInCart = math.max<int>(0, widget.amountInCart + quantity);
          widget.showRemoveIcon = widget.amountInCart > 0; // = DmState.countQualityInCarts(widget.product.id);
        });
      });
    } else {
      RouteGenerator.gotoLogin(context, replaceOld: false);
    }
//    _isDoing = false;
  }

  void _onTapIconAdd() {
    addCart(1);
  }

  void _onTapIconRemove() {
    addCart(-999999999);
  }

  bool _isDoing = false;

  void _onTapIconFav() {
    if (_isDoing) return;
    _isDoing = true;
    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });

    if (widget.isFavorite) {
      _con.addToFavorite(widget.product, onDone: (isOK) {
//        setState(() {
//          widget.isFavorite = DmState.isFavorite(productId: widget.product?.id);
//        });
      });
    } else {
      Favorite mark;
      DmState.favorites.forEach((element) {
        if (element.product.id == widget.product.id) {
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

  void onTapOnProduct() {
    RouteGenerator.gotoProductDetailPage(context, productId: widget.product.id, replaceOld: false);
  }
}
