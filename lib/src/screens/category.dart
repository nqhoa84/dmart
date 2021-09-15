import 'package:dmart/DmState.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/product.dart';
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

// ignore: must_be_immutable
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

//  @override
//  Widget buildContent(BuildContext context) {
//    if (proCon.categoriesProducts.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
//    } else {
////      print('_con.categoriesProducts ${proCon.categoriesProducts.length}');
//      return FadeTransition(
//        opacity: this.animationOpacity,
//        child: ProductGridView(products: proCon.categoriesProducts, heroTag: 'cate_${category?.id}'),
//      );
//    }
//  }

  @override
  Future<void> loadMore() async {
    int pre = proCon.categoriesProducts != null ? proCon.categoriesProducts.length : 0;

    await proCon.listenForProductsByCategory(id: this.category.id, nextPage: true);
    canLoadMore = proCon.categoriesProducts != null && proCon.categoriesProducts.length > pre;
//    isLoading = false;
    print('category can load more: $canLoadMore');
  }

  @override
  List<Product> get lstProducts => proCon.categoriesProducts;
}
