import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/route_argument.dart';
import 'package:flutter_svg/svg.dart';

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

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({
    Key key,
  }) : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends StateMVC<CategoriesWidget> {
  CategoryController _con;

  _CategoriesWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(value.appName ?? S.of(context).home,
                style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)));
          },
        ),
        actions: <Widget>[
          new ShoppingCartButton(
              iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          Container(
            width: 30,
            height: 30,
            //margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
            margin: EdgeInsetsDirectional.only(top: 12.5, bottom: 12.5, end: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: () {
                currentUser.value.apiToken != null
                    ? Navigator.of(context).pushNamed('/Pages', arguments: 1)
                    : Navigator.of(context).pushNamed('/Login');
              },
              child: currentUser.value.apiToken != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.value.image.thumb),
                    )
                  : Icon(
                      Icons.person,
                      size: 26,
                      color: Theme.of(context).accentColor.withOpacity(1),
                    ),
            ),
          )
        ],
      ),
      body: _con.categories.isEmpty
          ? CircularLoadingWidget(
              height: 500,
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SearchBar(
                      onClickFilter: (event) {
                        _con.scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                  ),
                  _createCategoriesGrid(_con.categories),
                ],
              ),
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
