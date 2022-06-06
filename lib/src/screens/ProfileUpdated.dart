import 'package:dmart/DmState.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../widgets/ProductsGridView.dart';
import '../widgets/ProductsGridViewLoading.dart';
import '../widgets/TitleDivider.dart';

class ProfileUpdatedScreen extends StatefulWidget {
  ProfileUpdatedScreen({Key? key}) : super(key: key);

  @override
  _ProfileUpdatedScreenState createState() => _ProfileUpdatedScreenState();
}

class _ProfileUpdatedScreenState extends StateMVC<ProfileUpdatedScreen> {
  ProductController _con = ProductController();

  _ProfileUpdatedScreenState() : super(ProductController()) {
    _con = controller as ProductController;
  }

  @override
  void initState() {
    _con.listenForBestSaleProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      body: SafeArea(
        child: CustomScrollView(slivers: <Widget>[
          createSliverTopBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
              buildContent(context),
            ]),
          )
        ]),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          isThreeLine: false,
          leading: Image.asset(DmConst.assetImgUserThumbUp),
          title: Text(S.current.accountInfoUpdated),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () {
                  RouteGenerator.gotoHome(context);
                },
                child: Text(S.current.startShopping,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TitleDivider(title: S.current.bestSale),
        SizedBox(height: 10),
        buildBestSale(context),
      ],
    );
  }

  Widget buildBestSale(BuildContext context) {
    if (DmUtils.isNullOrEmptyList(_con.bestSaleProducts!)) {
      return ProductsGridViewLoading(isList: true);
    } else {
//      return FadeTransition(
//        opacity: this.animationOpacity,
//        child: ProductGridView(products: _con.bestSaleProducts, heroTag: 'bestSale'),
//      );

      return ProductGridView(
          products: _con.bestSaleProducts!, heroTag: 'bestSale');
    }
  }

  Widget buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: createRoundedBorderBoxDecoration(),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  isThreeLine: false,
                  leading: Image.asset(DmConst.assetImgUserThumbUp),
                  title: Text(S.current.accountInfoUpdated),
                ),
                Divider(thickness: 2, color: Colors.grey.withOpacity(0.5)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          onPressed: () {
                            RouteGenerator.gotoHome(context);
                          },
                          child: Text(S.current.startShopping,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white)),
                          color: DmConst.accentColor,
//                    shape: StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          TitleDivider(title: S.current.bestSale),
          SizedBox(height: 10),
          buildBestSale(context),
        ],
      ),
    );
  }
}
