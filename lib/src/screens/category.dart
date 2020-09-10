//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/DmState.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/ProductType.dart';
import 'package:dmart/src/models/brand.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByCategory.dart';
import 'abs_product_mvc.dart';

class CategoryScreen extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  CategoryScreen({Key key, this.routeArgument}) {
    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _CategoryScreenState createState() => _CategoryScreenState(category: _category);
}

class _CategoryScreenState extends ProductStateMVC<CategoryScreen> {
  Category category;

  _CategoryScreenState({@required this.category}) : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForProductsByCategory(id: this.category.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return '${category?.name}';
  }

  @override
  Future<void> onRefresh() async {
    proCon.categoriesProducts.clear();
    proCon.listenForProductsByCategory(id: this.category.id);
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (proCon.categoriesProducts.isEmpty) {
      return ProductsGridViewLoading(isList: true);
    } else {
//      print('_con.categoriesProducts ${proCon.categoriesProducts.length}');
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: proCon.categoriesProducts, heroTag: 'cate_${category?.id}'),
      );
    }
  }

  @override
  void loadMore() {
    int pre = proCon.categoriesProducts != null ? proCon.categoriesProducts.length : 0;
    proCon.listenForProductsByCategory(id: this.category.id, nextPage: true);
    canLoadMore = proCon.categoriesProducts != null && proCon.categoriesProducts.length > pre;
  }
}

class _CategoryScreenStateOld extends StateMVC<CategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProductController _con;

  _CategoryScreenStateOld() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
//    _con.listenForProductsByCategory(id: widget._category.id);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      key: _scaffoldKey,
//      appBar: createAppBar(context, _scaffoldKey),
//      appBar: DmAppBarFull(height: 130),
//      appBar: createSilverAppBar(context),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(onFilter: (Filter f) {
        print('selected filter: $f');
      }),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          createSliverSearch(context),
          createSilverTopMenu(
            context, haveBackIcon: true, title: widget._category?.name,
//              types: [ProductType()],
//              cates: [Category()],
//              sorts: [SortBy.nameAsc],
//              brands: [Brand()]
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ProductsByCategory(category: widget._category),
            ]),
          )
        ]),
      ),
    );
  }
}
