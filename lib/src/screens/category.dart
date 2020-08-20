//import 'package:cached_network_image/cached_network_image.dart';
import '../../buidUI.dart';
import '../../src/repository/user_repository.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/CategoryHomeTabWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByCategory.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  CategoryWidget({Key key, this.routeArgument}) {
    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, _scaffoldKey),
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          snap: true,
          floating: true,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(child: Text('${widget._category?.name}')),
            )
          ],
          backgroundColor: Theme.of(context).accentColor,

        ),
        SliverList(
          delegate: SliverChildListDelegate([
            ProductsByCategory(category: widget._category)
          ]),
        )
      ]),
    );
  }
}
