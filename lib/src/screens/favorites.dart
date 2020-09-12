import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/ProductsByCategory.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../repository/user_repository.dart';
import '../widgets/PermissionDenied.dart';
import 'abs_product_mvc.dart';

class FavoritesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  FavoritesScreen({Key key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ProductStateMVC<FavoritesScreen>
{
  _FavoritesScreenState() : super(bottomIdx: DmState.bottomBarSelectedIndex);

  @override
  void initState() {
    proCon.listenForFavorites();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  String getTitle(BuildContext context) {
    return S.of(context).myFavorite;
  }

  @override
  Future<void> onRefresh() async{
    proCon.listenForFavorites();
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (DmState.favorites.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
      return EmptyDataLoginWid(
        message: S.of(context).yourFavoriteEmpty,
        iconData: Icons.favorite_border,
      );
    } else {
      List<Product> lp = [];
      DmState.favorites.forEach((element) {
        lp.add(element.product);
      });
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: lp, heroTag: 'myFav'),);
    }
  }

  @override
  void loadMore() {
//    int pre = proCon.favorites != null ? proCon.favorites.length : 0;
//    proCon.listenForFavorites(nextPage: true);
//    canLoadMore = proCon.favorites != null
//        && proCon.favorites.length > pre;
  }
}
