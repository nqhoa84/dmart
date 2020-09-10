//import 'package:cached_network_image/cached_network_image.dart';
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
import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';
import '../../src/repository/user_repository.dart';

class ProductItemWide extends StatefulWidget {
  String heroTag;
  Product product;
  int amountInCart;
  bool isFavorite;
  bool showRemoveIcon;
  double _removeIconSize = 0;
  Function(int) onPressedOnRemoveIcon;

  ProductItemWide(
      {Key key,
      @required Product product,
      @required String heroTag,
      this.showRemoveIcon = false,
      this.onPressedOnRemoveIcon})
      : super(key: key) {
    if (showRemoveIcon) _removeIconSize = 25;

    this.product = product;
    this.heroTag = '$heroTag' + '_W_${product.id}';

    this.amountInCart = DmState.countQualityInCarts(product.id);
    this.isFavorite = DmState.isFavorite(productId: product.id);

//    print('${product.id} is in cart with quality = ${this.amountInCart}');
  }

  @override
  _ProductItemWideState createState() => _ProductItemWideState();
}

class _ProductItemWideState extends StateMVC<ProductItemWide> {
  static const double _width = 550.0, _height = 192.0;
  static const double _tagSize = 50.0 / 550 * _width,
      _photoWid = 200.0 / 550 * _width,
      _icFavWSize = 34.0 / 550 * _width;
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
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(id: widget.product.id,
                param: [widget.product, widget.heroTag + widget.product.id.toString()]));
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
                        tag: widget.heroTag + '${widget.product.id}',
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: createNetworkImage(url: widget.product.image.thumb),
                          ),
                        ),
                      ),
                      getTagAssetImage() != null
                        ? Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset(getTagAssetImage(), fit: BoxFit.scaleDown),
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
                        Expanded(flex: 25, child: Center(child: this._createPriceWidget(context)))
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
                        child: Icon(
                          Icons.close,
                          size: widget._removeIconSize,
                          color: Colors.white,
                        )),
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

  String getTagAssetImage() {
    if(widget.product.isPromotion == true)
      return 'assets/img/Tag_Promotion.png';
    else if(widget.product.isBestSale == true)
      return 'assets/img/Tag_Best_Sale.png';
    else if(widget.product.isNewArrival == true)
      return 'assets/img/Tag_NewArrival.png';
    else if(widget.product.isSpecial4U == true)
      return 'assets/img/Tag_Special4u.png';
    else
      return null;
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
          child: Text(S.of(context).add),
          color: DmConst.accentColor,
          onPressed: _onPressedAdd2Cart,
        ),
      );
    }
  }

  Widget _createPriceWidget(BuildContext context) {
    if (widget.product.promotionPrice != null) {
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
    if (currentUser.value.isLogin) {
      _con.addToCart(_con.product);
      DmState.amountInCart.value ++;
      setState(() {
        widget.amountInCart++;
      });
    } else {
      RouteGenerator.gotoLogin(context, replaceOld: true);
    }
  }

  void _onTapIconSubtract() {
  }

  void _onTapIconAdd() {
  }

  void _onTapIconRemove() {
    if (widget.onPressedOnRemoveIcon != null) {
      widget.onPressedOnRemoveIcon(widget.product?.id);
    }
  }

  void _onTapIconFav() {
    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });
    if(widget.isFavorite) {
      Favorite mark = null;
      DmState.favorites.forEach((element) {
        if(element.product.id == widget.product.id) {
          mark = element;
          _con.removeFromFavorite(element);
        }
      });

      if(mark != null) DmState.favorites.remove(mark);
    } else {
      _con.addToFavorite(widget.product);
    }
  }
}
