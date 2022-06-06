import 'package:dmart/DmState.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/controllers/category_controller.dart';
import 'package:dmart/src/models/product.dart';
import 'package:flutter/material.dart';

import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import 'abs_product_mvc.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  RouteArgument? routeArgument;
  Category? category;
  int? cateId;

  ///If category == null then cateId is used to load the category object from server.
  CategoryScreen({Key? key, this.cateId, this.category}) {
    // category = this.routeArgument.param[0] as Category;
  }

  @override
  _CategoryScreenState createState() =>
      _CategoryScreenState(category: category!, cateId: cateId!);
}

class _CategoryScreenState extends ProductStateMVC<CategoryScreen> {
  int? cateId;
  Category? category;

  _CategoryScreenState({required this.category, required this.cateId})
      : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    super.initState();
    print('----cateId = $cateId, category = $category');
    if (this.category == null) {
      CategoryController().loadCate(id: cateId!).then((value) {
        setState(() {
          this.category = value;
          if (this.category == null) {
            this.errMsg = S.current.generalErrorMessage;
          }
        });
        proCon.listenForProductsByCategory(id: cateId!);
      });
    } else {
      proCon.listenForProductsByCategory(id: this.category!.id);
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return '${category!.name}';
  }

  @override
  Future<void> onRefresh() async {
    if (this.category != null) {
      proCon.categoriesProducts!.clear();
      proCon.listenForProductsByCategory(id: this.category!.id);
      canLoadMore = true;
    } else {
      canLoadMore = false;
    }
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
    int pre = proCon.categoriesProducts != null
        ? proCon.categoriesProducts!.length
        : 0;

    await proCon.listenForProductsByCategory(
        id: this.category!.id, nextPage: true);
    canLoadMore = proCon.categoriesProducts!.length > pre;
//    isLoading = false;
    print('category can load more: $canLoadMore');
  }

  @override
  List<Product> get lstProducts => proCon.categoriesProducts!;
}
