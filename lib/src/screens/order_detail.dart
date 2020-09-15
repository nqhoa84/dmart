import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dmart/src/controllers/delivery_pickup_controller.dart';
import 'package:dmart/src/controllers/order_controller.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/models/product_order.dart';
import 'package:dmart/src/screens/order_success.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:dmart/src/widgets/ProductOrderItemWide.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../widgets/cart_bottom_button.dart';
import 'contactus.dart';
import 'delivery_to.dart';

class OrderDetailScreen extends StatefulWidget {
  Order order;

  OrderDetailScreen(this.order);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState(this.order);
}

class _OrderDetailScreenState extends StateMVC<OrderDetailScreen> {
  Order order;
  OrderController _con;
  _OrderDetailScreenState(this.order) : super(OrderController()) {
    _con = controller;
    _con.order = order;
    _con.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
//    DmState.cartsValue.addListener(() {
//      setState(() {
//        _con.order.applyCarts(DmState.carts);
//      });
//    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              createSliverTopBar(context),
              createSliverSearch(context),
              createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).myOrder),
              SliverList(
                delegate: SliverChildListDelegate([
                  buildContent(context),
//                  SizedBox(height: 80),
                ]),
              )
            ],
          ),
        ),
//        body: _createProductsGrid(context),
      ),
    );
  }


  Widget _createSummaryContainer(BuildContext context) {
    return Container(
      decoration: createRoundedBorderBoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          OrderSummaryRow(S.of(context).date, toDateTimeStr(DateTime.now())),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).totalItems, '${_con.order.totalItems}'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).orderValue, getDisplayMoney(_con.order.orderVal), isBold: true),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).serviceFee, getDisplayMoney(_con.order.serviceFee)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).deliveryFee, getDisplayMoney(_con.order.deliveryFee)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).discount, getDisplayMoney(_con.order.voucherDiscount)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).total, getDisplayMoney(_con.order.totalBeforeTax), isBold: true),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).VAT, getDisplayMoney(_con.order.tax)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).grandTotal.toUpperCase(), getDisplayMoney(_con.order.grandTotal),
              isBold: true),
        ],
      ),
    );
  }

  Container _createDeliverToContainer(BuildContext context) {
    return Container(
      decoration: createRoundedBorderBoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          OrderSummaryRow(S.of(context).fullName, widget.order.deliveryAddress.fullName,
              txtAlign2: TextAlign.start),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).phone, widget.order.deliveryAddress.phone,
              txtAlign2: TextAlign.start),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).date, widget.order.getDeliverDateSlot, txtAlign2: TextAlign.start),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          OrderSummaryRow(S.of(context).address, widget.order.deliveryAddress.getFullAddress,
              txtAlign2: TextAlign.start),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad, vertical: 10),
              child: TitleDivider(
                  title: '${S.of(context).orderNumber}: ${widget.order.id}' ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _createSummaryContainer(context)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TitleDivider(
                  title: S.of(context).deliverTo ),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _createDeliverToContainer(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TitleDivider(
                  title: S.of(context).itemsList ),
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              crossAxisCount: 1,
              crossAxisSpacing: 1.5,
              childAspectRatio: 337.0 / 120,
              children: List.generate(
                this.order.productOrders!= null ?  this.order.productOrders.length : 0,
                (index) {
                  ProductOrder po = order.productOrders.elementAt(index);
//                  Product product = c.product;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductOrderItemWide(
                      product: po,
                      heroTag: '',
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}

class OrderSummaryRow extends StatelessWidget {
  String text1; String text2;
  bool isBold = false; TextAlign txtAlign1 = TextAlign.start; TextAlign txtAlign2 = TextAlign.end;

  OrderSummaryRow(this.text1, this.text2,
      {this.isBold = false, this.txtAlign1 = TextAlign.start, this.txtAlign2 = TextAlign.end});

  @override
  Widget build(BuildContext context) {
//    return Container();
    if (isBold)
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(text1, style: TextStyle(fontWeight: FontWeight.bold), textAlign: txtAlign1)),
            Text(": "),
            Expanded(flex: 3, child: Text(text2, style: TextStyle(fontWeight: FontWeight.bold), textAlign: txtAlign2)),
          ],
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(text1??'', textAlign: txtAlign1)),
            Text(": "),
            Expanded(flex: 3, child: Text(text2??'', textAlign: txtAlign2)),
          ],
        ),
      );
  }
}

