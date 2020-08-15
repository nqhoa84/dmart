import 'dart:ffi';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/helpers/app_config.dart' as config;
import 'package:flutter/material.dart';
import '../controllers/slider_controller.dart';
import 'CardsCarouselLoaderWidget.dart';

class HomeSliderWidget extends StatefulWidget {
  @override
  _HomeSliderWidgetState createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends StateMVC<HomeSliderWidget> {
  int _current = 0;
  SliderController _con;
  _HomeSliderWidgetState() : super(SliderController()){
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
//      fit: StackFit.expand,
      children: <Widget>[
        _con.sliders.isEmpty?CardsCarouselLoaderWidget()
            :CarouselSlider(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          height: 240,
          viewportFraction: 1.0,

          onPageChanged: (index) {
            setState(() {
              _current = index.toInt();
            });
          },
          items: _con.sliders.map((slide) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    child:Stack(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          height: 200, //TODO should not hardcode.
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:NetworkImage(slide.image.url,),
                                fit: BoxFit.cover
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 9)],
                          ),

                        ),
                        Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          width: double.infinity, height: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          child: Container(
                            width: config.App(context).appWidth(45),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  slide.description,
                                  style: Theme.of(context).textTheme.title.merge(TextStyle(height: 1)),
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.fade,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )


                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 35,
          right: 41,
          left: 41,
//          width: config.App(context).appWidth(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _con.sliders.map((slide) {
              return Container(
                width: 20.0,
                height: 3.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                    color: _current == _con.sliders.indexOf(slide)
                        ? Theme.of(context).hintColor
                        : Theme.of(context).hintColor.withOpacity(0.3)),
              );
            }).toList(),
          ),
        ),
      ],
    );
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                margin: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                  color: DmConst.homePromotionColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(S.of(context).homePromotion + ' >>',
                        textAlign: TextAlign.right),
                  )),
            ),
          ],
        ),
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
//      fit: StackFit.expand,
          children: <Widget>[
            _con.sliders.isEmpty?CardsCarouselLoaderWidget()
                :CarouselSlider(
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                height: 240,
                viewportFraction: 1.0,

                onPageChanged: (index) {
                  setState(() {
                    _current = index.toInt();
                  });
                },
              items: _con.sliders.map((slide) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      child:Stack(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            height: 200, //TODO should not hardcode.
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:NetworkImage(slide.image.url,),
                                fit: BoxFit.cover
                              ),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 9)],
                            ),

                          ),
                          Container(
                            alignment: AlignmentDirectional.bottomEnd,
                            width: double.infinity, height: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            child: Container(
                              width: config.App(context).appWidth(45),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    slide.description,
                                    style: Theme.of(context).textTheme.title.merge(TextStyle(height: 1)),
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.fade,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )


                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              bottom: 35,
              right: 41,
              left: 41,
//          width: config.App(context).appWidth(100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _con.sliders.map((slide) {
                  return Container(
                    width: 20.0,
                    height: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: _current == _con.sliders.indexOf(slide)
                            ? Theme.of(context).hintColor
                            : Theme.of(context).hintColor.withOpacity(0.3)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
