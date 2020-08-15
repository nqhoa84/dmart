import '../../src/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/favorite.dart';
import '../models/route_argument.dart';

class FavoriteGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Favorite favorite;

  FavoriteGridItemWidget({Key key, this.heroTag, this.favorite}) : super(key: key);

  @override
  _FavoriteGridItemWidgetState createState() =>  _FavoriteGridItemWidgetState();

}

class _FavoriteGridItemWidgetState  extends StateMVC<FavoriteGridItemWidget>{
  ProductController _con ;
  _FavoriteGridItemWidgetState() :super(ProductController()){
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
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Product', arguments: new RouteArgument(id: widget.favorite.product.id, param: [widget.favorite.product, widget.heroTag]));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.favorite.product.id,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(this.widget.favorite.product.image.thumb), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.favorite.product.name,
                style: Theme.of(context).textTheme.body2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                widget.favorite.product.store.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {},
              child: Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
