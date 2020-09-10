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
    proCon.favorites?.clear();
    proCon.listenForFavorites();
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (proCon.favorites.isEmpty) {
//      return ProductsGridViewLoading(isList: true);
      return EmptyDataLoginWid(
        message: S.of(context).yourFavoriteEmpty,
        iconData: Icons.favorite_border,
      );
    } else {
      List<Product> lp = [];
      proCon.favorites.forEach((element) {
        lp.add(element.product);
      });
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: lp, heroTag: 'myFav'),);
    }
  }

  @override
  void loadMore() {
    int pre = proCon.favorites != null ? proCon.favorites.length : 0;
    proCon.listenForFavorites(nextPage: true);
    canLoadMore = proCon.favorites != null
        && proCon.favorites.length > pre;
  }
}

class _FavoritesScreenStateOld extends StateMVC<FavoritesScreen> {
  String layout = 'grid';

  ProductController _con;

  _FavoritesScreenStateOld() : super(ProductController()) {
    _con = controller;
  }

@override
  void initState() {
    _con.listenForFavorites();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:  widget.scaffoldKey,
      appBar: createAppBar(context, widget.scaffoldKey),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      body: currentUser.value.isLogin == false
          ? PermissionDenied()
          : RefreshIndicator(
              onRefresh: _con.refreshFavorites,
              child: CustomScrollView(slivers: <Widget>[
                createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).favorites),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ProductsByCategory(category: Category(id: 1, name: 'name', description: 'desc'))
                  ]),
                )
              ]),
            ),
    );
  }

}
