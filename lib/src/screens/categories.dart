import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/route_argument.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/controllers/category_controller.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import '../../generated/l10n.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/SearchBar.dart';
import '../../src/widgets/ShoppingCartButton.dart';
import 'package:flutter/material.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class CategoriesScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  bool canBack;

  CategoriesScreen({
    Key key, this.canBack = false
  }) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends StateMVC<CategoriesScreen> {
  CategoryController _con;

  _CategoriesScreenState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
//    _con.listenForCategories();
    super.initState();
  }

  Widget buildContent(BuildContext context) {
    if (_con.categories.isEmpty)  {
      return NameImageItemGridViewLoading();
    } else
    {
      return NameImageItemGridView(items: _con.categories);
//      CategoriesGrid(parentScaffoldKey: widget.scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: 1),
      drawer: DrawerWidget(),
      endDrawer: FilterWidget(onFilter: (Filter f) {
        print('selected filter: $f');
      }),
      endDrawerEnableOpenDragGesture: true,
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          createSliverSearch(context),
          createSilverTopMenu(context, haveBackIcon: widget.canBack, title: S.of(context).categories),
          SliverList(
            delegate: SliverChildListDelegate([
              buildContent(context),
              ]),
          )
        ]),
      ),
    );
  }

  Widget _createCategoriesGrid(List<Category> categories) {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 15),
      childAspectRatio: 7.0 / 9.0,
      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: List.generate(categories.length, (index) {
        Category category = categories.elementAt(index);
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/Category', arguments: new RouteArgument(id: category.id, param: [category]));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: DmConst.accentColor),
              boxShadow: [
                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
              ],
            ),
            child: Column(
              children: <Widget>[
                //category image space.
                Expanded(
                  flex: 7,
                  child: category.image.url.toLowerCase().endsWith('.svg')
                      ? Container(
                          child: SvgPicture.network(category.image.url, color: Theme.of(context).primaryColor),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                          child: createNetworkImage(url: category.image.thumb, fit: BoxFit.cover),
                        ),
                ),
                Divider(thickness: 1, height: 1, color: DmConst.accentColor),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Center(
                      child: Text(category.name,
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
  }
}
