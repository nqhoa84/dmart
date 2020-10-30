//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
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
      children: List.generate(items.length + 1, (index) {
        if (index == 0) {
//          return Container(color: Colors.grey);
          return _buildAllWidget(context);
        } else {
          NameImageObj category = items.elementAt(index - 1);
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
                        color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
                  ]),
              child: Column(
                children: <Widget>[
                  //category image space.
                  Expanded(
                    flex: 7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                      child: createEmptyContainer(imageUrl: category.image.thumb),
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
                                  textAlign: TextAlign.center,
                                  softWrap: false,
                                  overflow: TextOverflow.fade)))),
                ],
              ),
            ),
          );
        }
      }),
      mainAxisSpacing: 15.0,
      crossAxisSpacing: 15.0,
    );
  }

  Widget _buildAllWidget(BuildContext context) {
    int len = items.length;
    if (len == 1) {
//      return Container();
      return Offstage(offstage: true, child: SizedBox());
    }

    Widget _buildImageForAllWid() {
      Category cate0 = items[0];
      Category cate1 = items[1];
      if (len == 2) {
        return Row(
          children: [
            Expanded(
              child: createEmptyContainer(imageUrl: cate0.image.icon),
            ),
            Expanded(
              child: createEmptyContainer(imageUrl: cate1.image.icon),
            ),
          ],
        );
      } else if (len == 3) {
        Category cate2 = items[2];
        return Stack(children: [
          createEmptyContainer(imageUrl: cate0.image.icon),
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: createEmptyContainer(imageUrl: cate1.image.icon),
                    ),
                    Expanded(
                      child: createEmptyContainer(imageUrl: cate2.image.icon),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          ),
        ]);
      } else if (len == 4) {
        Category cate2 = items[2];
        Category cate3 = items[3];
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: createEmptyContainer(imageUrl: cate0.image.icon),
                  ),
                  Expanded(
                    child: createEmptyContainer(imageUrl: cate1.image.icon),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: createEmptyContainer(imageUrl: cate2.image.icon),
                  ),
                  Expanded(
                    child: createEmptyContainer(imageUrl: cate3.image.icon),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        Category cate2 = items[2];
        Category cate3 = items[3];
        Category cate4 = items[4];
        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: createEmptyContainer(imageUrl: cate0.image.icon),
                      ),
                      Expanded(
                        child: createEmptyContainer(imageUrl: cate1.image.icon),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: createEmptyContainer(imageUrl: cate2.image.icon),
                      ),
                      Expanded(
                        child: createEmptyContainer(imageUrl: cate3.image.icon),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: kToolbarHeight, height: kToolbarHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(cate4.image.icon),
                          fit: BoxFit.cover
                      )
                  )
              ),
            )
          ],
        );
      }
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/Category',
            arguments: new RouteArgument(id: -1, param: [Category()..name = S.of(context).all]));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: DmConst.accentColor),
            boxShadow: [
              BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, 4), blurRadius: 10)
            ]),
        child: Column(
          children: <Widget>[
            //category image space.
            Expanded(
              flex: 7,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(9)),
                child: _buildImageForAllWid(),
              ),
            ),
            Divider(thickness: 1, height: 1, color: DmConst.accentColor),
            Expanded(
                flex: 2,
                child: Center(
                  child: Text(S.of(context).all,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade),
                )),
          ],
        ),
      ),
    );
  }
}
