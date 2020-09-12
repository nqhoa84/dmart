//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/promotion_controller.dart';
import 'package:dmart/src/models/promotion.dart';
import 'package:dmart/src/widgets/CircularLoadingWidget.dart';

import '../../src/controllers/category_controller.dart';
import '../../src/controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'CategoriesGrid.dart';

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

  _PromotionGroupsState() : super(PromotionController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForPromotions();
    super.initState();
  }

//  onCompleteLoading() {
//    setState(() {
//      print('Finish loading categories, length = ${_con.promoGroups?.length}');
//      promoGroups = _con.promoGroups;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _con.promotions.isEmpty
            ? NameImageItemGridViewLoading()
            : PromotionsGridView(promotions: _con.promotions),
    );
  }
}

class PromotionsGridView extends StatelessWidget {
  final List<Promotion> promotions;
  PromotionsGridView ({this.promotions = const []});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(DmConst.masterHorizontalPad, 0,
          DmConst.masterHorizontalPad, DmConst.masterHorizontalPad),
      child: GridView.count(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 15),
        childAspectRatio: 7.0 / 9.0,
        crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
        children: List.generate( promotions.length, (index) {
          Promotion promo =  promotions.elementAt(index);
          return InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/Promotion', arguments: new RouteArgument(id: promo.id, param: [promo],
                  heroTag: "fromPromoGroup_${promo.id}"));
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
                    child: promo.image.url.toLowerCase().endsWith('.svg')
                        ? Container(
                      child:
                      SvgPicture.network(promo.image.url, color: Theme.of(context).primaryColor),
                    )
                        : ClipRRect(
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                      child: createNetworkImage(url: promo.image.thumb, fit: BoxFit.cover),
                    ),
                  ),
                  Divider(thickness: 1, height: 1, color: DmConst.accentColor),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: Text(promo.name,
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
    );
  }
}

