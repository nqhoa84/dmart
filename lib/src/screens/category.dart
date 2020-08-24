//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';

import '../../buidUI.dart';
import '../../src/repository/user_repository.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/CategoryHomeTabWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByCategory.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryScreen extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  CategoryScreen({Key key, this.routeArgument}) {
    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
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
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: <Widget>[
        createSilverAppBar(context, haveBackIcon: true, title: widget._category?.name),
        SliverList(
          delegate: SliverChildListDelegate([
            ProductsByCategory(category: widget._category)
          ]),
        )
      ]),
    );
  }
}
