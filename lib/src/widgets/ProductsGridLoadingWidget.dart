import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductsGridLoadingWidget extends StatelessWidget {
  const ProductsGridLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Container(height: 120, width: 337,
                decoration: BoxDecoration(
//                  color: Colors.amber
                    image: DecorationImage(
                        image: AssetImage('assets/img/loading_product.gif'), fit: BoxFit.cover
                    )
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container( height: 120, width: 337,
                decoration: BoxDecoration(
//                  color: Colors.amber
                  image: DecorationImage(
                    image: AssetImage('assets/img/loading_product.gif'), fit: BoxFit.cover
                  )
                ),
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

  Widget _build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        height: 500,
        width: double.infinity,
        child: StaggeredGridView.countBuilder(
          scrollDirection: Axis.horizontal,
          primary: false,
          crossAxisCount: 4,
          itemCount: 6,
          itemBuilder: (context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              height: 120,
              width: 337,

              decoration: BoxDecoration(color: Colors.amber),
//              child: Image.asset('assets/img/loading_product.gif', width: 400, height: 200, fit: BoxFit.cover),
            );
          },
          staggeredTileBuilder: (index) => new StaggeredTile.fit(2),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        ));
  }
}
