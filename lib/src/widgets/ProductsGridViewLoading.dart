import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../constant.dart';

class ProductsGridViewLoading extends StatelessWidget {
  final bool isList;
  const ProductsGridViewLoading({Key? key, this.isList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad,
//      vertical: DmConst.masterHorizontalPad/2),
      child: Wrap(
        children: <Widget>[
          Offstage(
            offstage: isList == false,
            child: GridView.count(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              crossAxisCount: 1,
              crossAxisSpacing: DmConst.masterHorizontalPad,
              mainAxisSpacing: DmConst.masterHorizontalPad,
              childAspectRatio: 337.0 / 120,
              // 120 / 337,
              children: List.generate(
                  4,
                  (index) => Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: DmConst.accentColor),
                            image: DecorationImage(
                                image: AssetImage('assets/img/loading.gif'),
                                fit: BoxFit.cover)),
                      )).toList(),
            ),
          ),
          Offstage(
            offstage: isList == true,
            child: StaggeredGrid.count(
              // primary: false,
              // shrinkWrap: true,
              children: [
                ListView.builder(
                  itemCount: 4,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 120,
                      width: 337,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/img/loading_product.gif'),
                              fit: BoxFit.cover)),
                    );
                  },
                )
              ],
              crossAxisCount: 4,
              // itemCount: 4,
              // itemBuilder: (BuildContext context, int index) {
              //   return Container(
              //     height: 120,
              //     width: 337,
              //     decoration: BoxDecoration(
              //         image: DecorationImage(
              //             image: AssetImage('assets/img/loading_product.gif'),
              //             fit: BoxFit.cover)),
              //   );
              // },
//                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
              // staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              mainAxisSpacing: DmConst.masterHorizontalPad,
              crossAxisSpacing: DmConst.masterHorizontalPad,
            ),
          ),
        ],
      ),
    );
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        height: 300,
        width: double.infinity,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 2,
          crossAxisSpacing: 1.5,
          childAspectRatio: 120 / 337,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                width: 337,
                decoration: BoxDecoration(
//                  color: Colors.amber
                    image: DecorationImage(
                        image: AssetImage('assets/img/loading_product.gif'),
                        fit: BoxFit.cover)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                width: 337,
                decoration: BoxDecoration(
//                  color: Colors.amber
                    image: DecorationImage(
                        image: AssetImage('assets/img/loading_product.gif'),
                        fit: BoxFit.cover)),
              ),
            ),
//            Container( height: 120, width: 337,
//              decoration: BoxDecoration(color: Colors.amber),
//            ),
//            Container( height: 120, width: 337,
//              decoration: BoxDecoration(color: Colors.amber),
//            ),
//            Container( height: 120, width: 337,
//              decoration: BoxDecoration(color: Colors.amber),
//            )
          ],
        ));
  }
}
