//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/promotion_controller.dart';
import 'package:dmart/src/widgets/CircularLoadingWidget.dart';

import '../../src/controllers/category_controller.dart';
import '../../src/controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PromotionGroups extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

//  final List<Category> categories;

  const PromotionGroups(
      {Key key,
//    this.categories,
      this.parentScaffoldKey})
      : super(key: key);

  @override
  _PromotionGroupsState createState() => _PromotionGroupsState();
}

class _PromotionGroupsState extends StateMVC<PromotionGroups> with SingleTickerProviderStateMixin {
  PromotionController _con;

  //Todo change to PromotionGroup class
  List<Category> promoGroups = [];

  _PromotionGroupsState() : super(PromotionController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForGroups(onDone: onCompleteLoading);
    super.initState();
  }

  onCompleteLoading() {
    setState(() {
      print('Finish loading categories, length = ${_con.promoGroups?.length}');
      promoGroups = _con.promoGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: promoGroups == null
            ? CircularLoadingWidget()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 15),
                  childAspectRatio: 7.0 / 9.0,
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                  children: List.generate(promoGroups.length, (index) {
                    Category category = promoGroups.elementAt(index);
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
                          ],
                        ),
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
                ),
              ));
  }

  Widget _build(BuildContext context) {
    return null;
//    return StaggeredGridView.countBuilder(
//      primary: false,
//      shrinkWrap: true,
//      padding: EdgeInsets.only(top: 15),
//      crossAxisCount:
//      MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
//      itemCount: widget.categories.length,
//      itemBuilder: (BuildContext context, int index) {
//        Category category = widget.categories.elementAt(index);
//        return InkWell(
//          onTap: () {
//            Navigator.of(context).pushNamed('/Category', arguments: new RouteArgument(id: category.id, param: [category]));
//          },
//          child: Stack(
//            alignment: AlignmentDirectional.topCenter,
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.all(10),
//                alignment: AlignmentDirectional.topCenter,
//                padding: EdgeInsets.all(20),
//                width: double.infinity,
//                height: 100,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(10),
//                    boxShadow: [
//                      BoxShadow(
//                          color: Theme.of(context).hintColor.withOpacity(0.10),
//                          offset: Offset(0, 4),
//                          blurRadius: 10)
//                    ],
//                    gradient: LinearGradient(
//                        begin: Alignment.bottomLeft,
//                        end: Alignment.topRight,
//                        colors: [
//                          Theme.of(context).accentColor,
//                          Theme.of(context).accentColor.withOpacity(0.2),
//                        ])),
//                child: Hero(
//                  tag: category.id,
//                  child: category.image.url.toLowerCase().endsWith('.svg')
//                      ? Container(
//                    height: 80,
//                    width: 80,
//                    child: SvgPicture.network(
//                      category.image.url,
//                      color: Theme.of(context).primaryColor,
//                    ),
//                  )
//                      : ClipRRect(
//                    borderRadius: BorderRadius.all(Radius.circular(5)),
////                    child: CachedNetworkImage(
////                      height: 80,
////                      width: 80,
////                      fit: BoxFit.cover,
////                      imageUrl: category.image.thumb,
////                      placeholder: (context, url) => Image.asset(
////                        'assets/img/loading.gif',
////                        fit: BoxFit.cover,
////                        height: 80,
////                        width: 80,
////                      ),
////                      errorWidget: (context, url, error) =>
////                          Icon(Icons.error),
////                    ),
//                    child: createNetworkImage(url: category.image.thumb, width: 80, height: 80),
//                  ),
//                ),
//              ),
//              Positioned(
//                right: -50,
//                bottom: -100,
//                child: Container(
//                  width: 220,
//                  height: 220,
//                  decoration: BoxDecoration(
//                    color: Theme.of(context).primaryColor.withOpacity(0.08),
//                    borderRadius: BorderRadius.circular(150),
//                  ),
//                ),
//              ),
//              Positioned(
//                left: -30,
//                top: -60,
//                child: Container(
//                  width: 120,
//                  height: 120,
//                  decoration: BoxDecoration(
//                    color: Theme.of(context).primaryColor.withOpacity(0.12),
//                    borderRadius: BorderRadius.circular(150),
//                  ),
//                ),
//              ),
//              Container(
//                margin: EdgeInsets.only(top: 90, bottom: 10),
//                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                width: 140,
//                height: 50,
//                decoration: BoxDecoration(
//                    color: Theme.of(context).primaryColor,
//                    borderRadius: BorderRadius.circular(6),
//                    boxShadow: [
//                      BoxShadow(
//                          color: Theme.of(context).hintColor.withOpacity(0.15),
//                          offset: Offset(0, 3),
//                          blurRadius: 10)
//                    ]),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Text(
//                      category.name,
//                      style: Theme.of(context).textTheme.bodyText2,
//                      maxLines: 1,
//                      softWrap: false,
//                      overflow: TextOverflow.fade,
//                    ),
//                    /*Row(
//                      children: <Widget>[
//                        // The title of the product
//                        Expanded(
//                          child: Text(
//                            _con.products.where((product) => product.category.id == category.id).length.toString() + ' Products',
//                            style: Theme.of(context).textTheme.bodyText2,
//                            overflow: TextOverflow.fade,
//                            softWrap: false,
//                          ),
//                        ),
//                        /*Icon(
//                          Icons.star,
//                          color: Colors.amber,
//                          size: 18,
//                        ),
//                        Text(
//                          category.name,
//                          style: Theme.of(context).textTheme.bodyText1,
//                        )*/
//                      ],
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                    ),*/
//                  ],
//                ),
//              ),
//            ],
//          ),
//        );
//      },
////                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
//      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
//      mainAxisSpacing: 15.0,
//      crossAxisSpacing: 15.0,
//    );
  }
}
