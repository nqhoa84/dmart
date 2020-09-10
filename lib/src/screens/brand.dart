//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';

import '../../src/repository/user_repository.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/brand.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/BrandHomeTabWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByBrandWidget.dart';
import '../../src/widgets/ShoppingCartButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Brand _brand;

  BrandWidget({Key key, this.routeArgument}) {
    _brand = this.routeArgument.param[0] as Brand;
  }

  @override
  _BrandWidgetState createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body:
      CustomScrollView(slivers: <Widget>[
        createSliverTopBar(context),
        createSliverSearch(context),
        SliverList(
          delegate: SliverChildListDelegate([
            Offstage(
              offstage: 0 != _tabIndex,
              child: Column(
                children: <Widget>[
                  BrandHomeTabWidget(brand: widget._brand),
                ],
              ),
            ),
            Offstage(
              offstage: 1 != _tabIndex,
              child: Column(
                children: <Widget>[
                  ProductsByBrandWidget(brand: widget._brand)
                ],
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
