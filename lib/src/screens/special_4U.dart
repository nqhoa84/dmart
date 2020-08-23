import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductsByCategory.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../repository/user_repository.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/FavoriteGridItemWidget.dart';
import '../widgets/FavoriteListItemWidget.dart';
import '../widgets/PermissionDenied.dart';
import '../widgets/SearchBar.dart';

class Special4UScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Special4UScreen({Key key}) : super(key: key);

  @override
  _Special4UScreenState createState() => _Special4UScreenState();
}

class _Special4UScreenState extends StateMVC<Special4UScreen> {
  String layout = 'grid';

  ProductController _con;

  _Special4UScreenState() : super(ProductController()) {
    _con = controller;
  }
  @override
  void initState() {
    _con.listenForFavorites();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          createSilverAppBar(context, haveBackIcon: true, title: S.of(context).favorites),
          SliverList(
            delegate: SliverChildListDelegate([
              ProductsByCategory(category: Category(id: '1', name: 'name', description: 'desc'))
            ]),
          )
        ]),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      key:  widget.scaffoldKey,
      appBar: createAppBar(context, widget.scaffoldKey),
      body: currentUser.value.isLogin == false
          ? PermissionDenied()
          : RefreshIndicator(
        onRefresh: _con.refreshFavorites,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBar(onClickFilter: (e) {
                  widget.scaffoldKey.currentState.openEndDrawer();
                }),
              ),
              SizedBox(height: 10),
              Padding(
                //padding: const EdgeInsets.only(left: 20, right: 10),
                padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.favorite,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).favoriteProducts,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            this.layout = 'list';
                          });
                        },
                        icon: Icon(
                          Icons.format_list_bulleted,
                          color: this.layout == 'list'
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {

                            this.layout = 'grid';
                          });
                        },
                        icon: Icon(
                          Icons.apps,
                          color: this.layout == 'grid'
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _con.favorites.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : Offstage(
                offstage: this.layout != 'list',
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.favorites.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    return
                      FavoriteListItemWidget(
                        heroTag: 'favorites_list',
                        favorite: _con.favorites.elementAt(index),
                        onDismissed: () {
                          _con.removeFromFavorite(_con.favorites.elementAt(index));
                        },

                      );
                  },
                ),
              ),
              _con.favorites.isEmpty
                  ? CircularLoadingWidget(height: 500)
                  : Offstage(
                offstage: this.layout != 'grid',
                child: GridView.count(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(_con.favorites.length, (index) {
                    return FavoriteGridItemWidget(
                      heroTag: 'favorites_grid',
                      favorite: _con.favorites.elementAt(index),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

