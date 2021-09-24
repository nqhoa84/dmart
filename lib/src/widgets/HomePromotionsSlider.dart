import 'dart:ffi';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/promotion.dart';
import 'package:dmart/src/models/route_argument.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/helpers/app_config.dart' as config;
import 'package:flutter/material.dart';
import '../controllers/promotion_controller.dart';
import 'CardsCarouselLoaderWidget.dart';

class HomePromotionsSlider extends StatefulWidget {
  @override
  _HomePromotionsSliderState createState() => _HomePromotionsSliderState();
}

class _HomePromotionsSliderState extends StateMVC<HomePromotionsSlider> {
  int _current = 0;
  PromotionController _con;

  _HomePromotionsSliderState() : super(PromotionController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForPromotions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
//      fit: StackFit.expand,
      children: <Widget>[
        _con.promotions.isEmpty
            ? CardsCarouselLoaderWidget()
            : CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true, autoPlayInterval: Duration(seconds: 4),
                  //todo should make the height depend on width
                  height: 225, viewportFraction: 1.0,
                  onPageChanged: (idx, reason) {
                    setState(() {_current = idx;});
                  }
                ),
                items: _con.promotions.map((promotion) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          child: Stack(
                        children: <Widget>[
                          //display slider.image
                          InkWell(
                            onTap: () {
                              onTapOnPromotion(promotion: promotion);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              height: 200, //TODO should not hardcode.
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      promotion.image.url
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context).hintColor.withOpacity(0.2),
                                      offset: Offset(0, 4),
                                      blurRadius: 9)
                                ],
                              ),
                            ),
                          ),
                          //display slide.description
//                          Container(
//                            alignment: AlignmentDirectional.bottomEnd,
//                            width: double.infinity,
//                            height: 200,
//                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//                            child: Container(
//                              width: config.App(context).appWidth(45),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.stretch,
//                                mainAxisSize: MainAxisSize.max,
//                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                children: <Widget>[
//                                  Text(slide.description,
//                                      style: Theme.of(context).textTheme.headline6.merge(TextStyle(height: 1)),
//                                      textAlign: TextAlign.end,
//                                      overflow: TextOverflow.fade,
//                                      maxLines: 3),
//                                ],
//                              ),
//                            ),
//                          ),
                        ],
                      ));
                    },
                  );
                }).toList(),
              ),
        buildIndicator(context),
      ],
    );
  }

  Positioned buildIndicator(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 41,
      left: 41,
//          width: config.App(context).appWidth(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: _con.promotions.map((slide) {
          return Container(
            width: 15.0,
            height: 3.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                color: _current == _con.promotions.indexOf(slide)
                    ? Theme.of(context).hintColor
                    : Theme.of(context).hintColor.withOpacity(0.3)),
          );
        }).toList(),
      ),
    );
  }

  void onTapOnPromotion({Promotion promotion}) {
    if(promotion != null && promotion.id > 0) {
      RouteGenerator.gotoPromotionPage(context, promotionId: promotion.id);
    } else {
      _con.showErr(S.current.generalErrorMessage);
    }
    // Navigator.of(context)
    //     .pushNamed('/Promotion', arguments: new RouteArgument(id: promotion.id,
    //     param: [promotion], heroTag: 'fromHome${promotion.id}'));
  }
}
