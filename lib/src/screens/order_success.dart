import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/ProductsGridViewLoading.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../../src/helpers/ui_icons.dart';

class OrderSuccessScreen extends StatefulWidget {
//  final RouteArgument routeArgument;

  final Order order;
  
  OrderSuccessScreen(this.order, {Key key}) : super(key: key);

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends StateMVC<OrderSuccessScreen> {
  ProductController _con;

  _OrderSuccessScreenState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    // route param contains the payment method
//    _con.payment = new Payment(widget.routeArgument.param);
    _con.listenForSpecial4U();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _con.scaffoldKey,
//        appBar: createAppBar(context, _con.scaffoldKey),
          bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                createSliverTopBar(context),
                createSliverSearch(context),
                createSilverTopMenu(context, haveBackIcon: false, title: S.of(context).myCart),
                SliverList(
                  delegate: SliverChildListDelegate([
                    buildContent(context),
                  ]),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _buildSpecial4U() {
    if(_con.special4UProducts != null) {
      return ProductGridView(products: _con.special4UProducts, heroTag: 'spe4U_fromOrderOK');
    } else {
      return ProductsGridViewLoading();
    }
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: [
//                createTitleRowWithBack(context, title: S.of(context).orderConfirmation, showBack: false),
        Padding(
          padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
          child: TitleDivider(title: '${S.of(context).orderId}: ${widget.order.id}'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
          child: Container(
            decoration: createRoundedBorderBoxDecoration(),
            child: ListTile(
              leading: Image.asset('assets/img/Thanks.png', fit: BoxFit.scaleDown),
              title: Text(S.of(context).thankYou.toUpperCase() + "\n" + S.of(context).yourOrderIsBeingPlaced),
              subtitle: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(S.of(context).pleaseCheck1),
                  FlatButton.icon(icon: Icon(UiIcons.edit, color: Theme.of(context).accentColor),
                      label: Text(S.of(context).myOrders, style: TextStyle(color: Theme.of(context).accentColor),),
                      onPressed: () => RouteGenerator.gotoMyOrders(context, replaceOld: true)
                  ),
                  Text(S.of(context).pleaseCheck2),
                ],),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
          child: TitleDivider(title: S.of(context).specialForYou),
        ),
        Padding(
          padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
          child: _buildSpecial4U(),
        ),
      ],
    );
  }
}
