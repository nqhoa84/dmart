//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/widgets/CircularLoadingWidget.dart';

import '../../src/controllers/category_controller.dart';
import '../../src/controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DmCategoriesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

//  final List<Category> categories;

  const DmCategoriesWidget(
      {Key key,
//    this.categories,
      this.parentScaffoldKey})
      : super(key: key);

  @override
  _DmCategoriesWidgetState createState() => _DmCategoriesWidgetState();
}

class _DmCategoriesWidgetState extends StateMVC<DmCategoriesWidget> with SingleTickerProviderStateMixin {
  CategoryController _con;
  List<Category> categories = [];

  _DmCategoriesWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCategories(onDone: onCompleteLoading);
    super.initState();
  }

  onCompleteLoading() {
    setState(() {
      print('Finish loading categories, length = ${_con.categories?.length}');
      categories = _con.categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: categories == null
            ? CircularLoadingWidget()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            border: Border.all(width: 1, color: DmConst.primaryColor),
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
                                  ? Container(
                                      child:
                                          SvgPicture.network(category.image.url, color: Theme.of(context).primaryColor),
                                    )
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                                      child: createNetworkImage(url: category.image.thumb, fit: BoxFit.cover),
                                    ),
                            ),
                            Divider(thickness: 1, height: 1, color: DmConst.primaryColor),
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
              ));
  }
}
