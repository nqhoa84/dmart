//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';
import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';

class ProductItemWide extends StatefulWidget {
  final String heroTag;
  final Product product;
  int amountInCart;
  bool isFavorite;

  ProductItemWide({Key key, this.product, this.heroTag, this.amountInCart = 2, this.isFavorite = true}) : super(key: key);

  @override
  _ProductItemWideState createState() => _ProductItemWideState();
}

class _ProductItemWideState extends State<ProductItemWide> {
  static const double _width = 550.0, _height = 192.0;
  static const double _tagSize = 50.0 / 550 * _width,
      _photoWid = 200.0 / 550 * _width,
      _icFavWSize = 34.0 / 550 * _width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('/Product',
            arguments: new RouteArgument(id: widget.product.id, param: [widget.product, widget.heroTag]));
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
                        tag: widget.heroTag + widget.product.id,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: createNetworkImage(url: widget.product.image.thumb),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Image.asset('assets/img/Tag_Best_Sale.png', fit: BoxFit.scaleDown),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(),
                            ),
                          ],
                        ),
                      )
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
                                flex: 6,
                                child: Text(
                                  widget.product?.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: createFavoriteIcon(context, widget.isFavorite),
                              ),
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
//          _createSaleTag(context),
//          _createFavIcon(context),
        ],
      ),
    );
  }

  String getTagAssetImage() {
    switch (widget.product.getDisplaySaleTag) {
      case SaleTag.BestSale:
        return 'assets/img/Tag_Best_Sale.png';
      case SaleTag.NewArrival:
        return 'assets/img/Tag_NewArrival.png';
      case SaleTag.Promotion:
        return 'assets/img/Tag_Promotion.png';
      case SaleTag.Special4U:
        return 'assets/img/Tag_Special4u.png';
      default:
        return null;
    }
  }

  BoxDecoration _createDecoration() {
    return widget.amountInCart > 0
        ? BoxDecoration(
            border: Border.all(color: DmConst.primaryColor),
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
            border: Border.all(color: DmConst.primaryColor),
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
          IconButton(
            onPressed: () {
//                _con.decrementQuantity();
            },
//            iconSize: 30,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.remove_circle_outline),
//              color: Theme.of(context).hintColor,
          ),
          Text('${widget.amountInCart}'),
          IconButton(
            onPressed: () {
//                _con.incrementQuantity();
            },
//            iconSize: 30,
            padding: EdgeInsets.all(0),
            icon: Icon(Icons.add_circle_outline),
//              color: Theme.of(context).hintColor,
          )
        ],
      );
    } else {
      return FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: DmConst.primaryColor)),
        child: Text(S.of(context).add_to_cart),
        color: DmConst.primaryColor,
        onPressed: () {},
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
}
