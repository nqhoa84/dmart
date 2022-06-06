import 'package:dmart/src/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/route_argument.dart';

class DebugWidget extends StatefulWidget {
  final RouteArgument? routeArgument;

  DebugWidget({Key? key, this.routeArgument}) : super(key: key);

  @override
  _DebugWidgetState createState() {
    return _DebugWidgetState();
  }
}

class _DebugWidgetState extends StateMVC<DebugWidget> {
//  FavoriteController _con;

  _DebugWidgetState() : super(ProductController()) {
//    _con = controller;
  }

  @override
  void initState() {
    //_con.listenForTrendingProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        key: _con.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Debug',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {},
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Container());
  }
}
