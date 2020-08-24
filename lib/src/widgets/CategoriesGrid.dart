//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/controllers/category_controller.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';

class CategoriesGrid extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

//  final List<Category> categories;

  const CategoriesGrid(
      {Key key,
//    this.categories,
      this.parentScaffoldKey})
      : super(key: key);

  @override
  _CategoriesGridState createState() => _CategoriesGridState();
}

class _CategoriesGridState extends StateMVC<CategoriesGrid> with SingleTickerProviderStateMixin {
  CategoryController _con;
  List<Category> categories = [];
  Animation animationOpacity;
  AnimationController animationController;

  _CategoriesGridState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCategories(onDone: onCompleteLoading);

    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  onCompleteLoading() {
    setState(() {
      print('Finish loading categories, length = ${_con.categories?.length}');
      categories = _con.categories;
    });
//    Future.delayed(Duration(seconds: 1), () {
//      setState(() {
//        print('Finish loading categories, length = ${_con.categories?.length}');
//        categories = _con.categories;
//      });
//    });
  }

  Widget _createLoading() {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 15),
      childAspectRatio: 7.0 / 9.0,
      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: List.generate(4, (index) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: DmConst.accentColor),
              boxShadow: [
                BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(9)),
            child: Image.asset('assets/img/loading_categories.gif', fit: BoxFit.cover),
          ),
        );
      }),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: categories == null || categories.isEmpty
          ? _createLoading() // CircularLoadingWidget()
          : FadeTransition(
              opacity: animationOpacity,
              child: GridView.count(
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
                            BoxShadow(
                                color: Theme.of(context).hintColor.withOpacity(0.10),
                                offset: Offset(0, 4),
                                blurRadius: 10)
                          ]),
                      child: Column(
                        children: <Widget>[
                          //category image space.
                          Expanded(
                            flex: 7,
                            child: category.image.url.toLowerCase().endsWith('.svg')
                                ? SvgPicture.network(category.image.url, color: Theme.of(context).primaryColor)
                                : ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
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
                                          overflow: TextOverflow.fade)))),
                        ],
                      ),
                    ),
                  );
                }),
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
              ),
            ),
    ));
  }
}
