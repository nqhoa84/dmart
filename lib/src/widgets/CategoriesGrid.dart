//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/models/i_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/controllers/category_controller.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';

class NameImageItemGridViewLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
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
}

///TODO remove promotion gridview and use this grid.
///GridView of 2 columns to display NameImageObj (such as Category, Brand, Promotion...).
class CategoriesGridView extends StatelessWidget {
  final List<NameImageObj> items;
  CategoriesGridView({@required this.items});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      childAspectRatio: 7.0 / 9.0,
      crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
      children: List.generate(items.length, (index) {
        NameImageObj category = items.elementAt(index);
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
    );
  }
}

