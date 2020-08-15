import '../../src/controllers/product_controller.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/favorite.dart';
import '../models/route_argument.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

// ignore: must_be_immutable
class FavoriteListItemWidget extends StatefulWidget {
  String heroTag;
  Favorite favorite;
  VoidCallback onDismissed;

  FavoriteListItemWidget({Key key, this.heroTag, this.favorite,this.onDismissed}) : super(key: key);
  @override
  _FavoriteListItemWidgetState createState() =>  _FavoriteListItemWidgetState();

}
  class _FavoriteListItemWidgetState extends StateMVC<FavoriteListItemWidget>{

  ProductController _con ;
  _FavoriteListItemWidgetState() :super(ProductController()){
    _con = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
    _con.listenForFavorites();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
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
          Navigator.of(context).pushNamed('/Product', arguments: new RouteArgument(id: widget.favorite.product.id, param: [widget.favorite.product, widget.heroTag]));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: widget.heroTag + widget.favorite.product.id,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(image: NetworkImage(widget.favorite.product.image.thumb), fit: BoxFit.cover),
                  ),
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
                        children: <Widget>[
                          Text(
                            widget.favorite.product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Text(
                            widget.favorite.product.store.name,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Helper.getPrice(widget.favorite.product.price, context, style: Theme.of(context).textTheme.display1),
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


