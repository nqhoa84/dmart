import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/ProductItemHigh.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../src/models/product.dart';

// ignore: must_be_immutable
class ProductGridView extends StatefulWidget {
  final List<Product> products;
  final String heroTag;
  final bool isList;
  Axis scrollDirection;

  bool showRemoveIcon;

  ProductGridView(
      {required this.products,
      this.heroTag = 'product',
      this.isList = true,
      this.showRemoveIcon = false,
      this.scrollDirection = Axis.vertical});

  @override
  _ProductGridViewState createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  static const double _endReachedThreshold = 200;
  final ScrollController _controller = ScrollController();

  bool _loading = true;

  Future<void> onRefresh() async {
    print('ProductGridView onRefresh');
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _loading = false;
    super.initState();
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading)
      return; // Chỉ chạy những dòng dưới nếu như controller đã được mount vào widget và đang không loading

    final thresholdReached = _controller.position.extentAfter <
        _endReachedThreshold; // Check xem đã đạt tới _endReachedThreshold chưa

    if (thresholdReached) {
      // Load more!
      loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (DmUtils.isNullOrEmptyList(widget.products))
      return EmptyDataLoginWid(
        message: S.current.productListEmpty,
      );
    return Container(
      child: widget.isList == true
          ? RefreshIndicator(
              onRefresh: onRefresh,
              child: GridView.count(
                controller: _controller,
                primary: false,
                shrinkWrap: true,
                scrollDirection: widget.scrollDirection,
                crossAxisCount: 1,
                crossAxisSpacing: DmConst.masterHorizontalPad,
                mainAxisSpacing: DmConst.masterHorizontalPad,
                childAspectRatio: 337.0 / 120,
                // 120 / 337,
                children: List.generate(
                  widget.products.length,
                  (index) {
                    Product product = widget.products.elementAt(index);
                    return ProductItemWide(
                        product: product,
                        heroTag: '${widget.heroTag}',
                        showRemoveIcon: widget.showRemoveIcon);
                  },
                ),
              ),
            )
          : StaggeredGrid.count(
              // scrollDirection: widget.scrollDirection,
              // primary: false,
              // shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 15.0,
              children: [
                ListView.builder(
                  scrollDirection: widget.scrollDirection,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Product product = widget.products.elementAt(index);
                    return ProductItemHigh(
                      product: product,
                      heroTag: '${widget.heroTag}',
                    );
                  },
                )
              ],
              // itemCount: widget.products.length,
              // itemBuilder: (BuildContext context, int index) {
              //   Product product = widget.products.elementAt(index);
              //   //todo this is legacy class, need customer to design UI.
              //   return ProductItemHigh(
              //     product: product,
              //     heroTag: '${widget.heroTag}',
              //   );
              // },
              //                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
              // staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
            ),
    );
  }

  void loadMore() {
    _loading = true;

    print('the loadMore functions ========== fired.......');

    _loading = false;
  }
}
