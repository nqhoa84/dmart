import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dmart/src/controllers/delivery_pickup_controller.dart';
import 'package:dmart/src/controllers/order_controller.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/screens/order_success.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
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

class PlaceOrderScreen extends StatefulWidget {
  Order order;

  PlaceOrderScreen(this.order);

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends StateMVC<PlaceOrderScreen> {
  OrderController _con;
  DatePickerController _datePickerController = DatePickerController();

  String voucher;

  _PlaceOrderScreenState() : super(OrderController()) {
    _con = controller;
    _con.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    _con.order = widget.order;
    DmState.cartsValue.addListener(() {
      setState(() {
        _con.order.applyCarts(DmState.carts);
      });
    });
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
//        appBar: createAppBar(context, _con.scaffoldKey),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  createSliverTopBar(context),
                  createSliverSearch(context),
                  createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).myCart),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      buildContent(context),
                      SizedBox(height: 80),
                    ]),
                  )
                ],
              ),
              buildBottom(context),
            ],
          ),
        ),
//        body: _createProductsGrid(context),
      ),
    );
  }

  Widget _createSummaryRow(BuildContext context, String text1, String text2,
      {bool isBold = false, TextAlign txtAlign1 = TextAlign.start, TextAlign txtAlign2 = TextAlign.end}) {
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
            Expanded(flex: 2, child: Text(text1, textAlign: txtAlign1)),
            Text(": "),
            Expanded(flex: 3, child: Text(text2, textAlign: txtAlign2)),
          ],
        ),
      );
  }

  DateFormat fmt = DateFormat.yMMMd('en_US').add_Hm();

  Widget _createSummaryContainer2(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: DmState.cartsValue,
        builder: (context, value, child) {
          double orderVal = DmState.calculateTotalMoneyPaidOnCarts();
          double serFee = DmState.calculateServiceFeeOnCarts();
          double deliverFee = _con.order.deliveryFee;
//          double discount = _con.order.voucherDiscount;
          double total = orderVal + serFee + deliverFee - _con.order.voucherDiscount;
          double vat = total * DmState.vatPercent;
          double grandTotal = total + vat;
          return Container(
            decoration: createRoundedBorderBoxDecoration(),
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                _createSummaryRow(context, S.of(context).date, fmt.format(DateTime.now())),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).totalItems, '${DmState.amountInCart.value}'),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).orderValue, getDisplayMoney(orderVal), isBold: true),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).serviceFee, getDisplayMoney(serFee)),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).deliveryFee, getDisplayMoney(deliverFee)),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).discount, getDisplayMoney(_con.order.voucherDiscount)),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).total, getDisplayMoney(total), isBold: true),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).VAT, getDisplayMoney(vat)),
                Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                _createSummaryRow(context, S.of(context).grandTotal.toUpperCase(), getDisplayMoney(grandTotal),
                    isBold: true),
              ],
            ),
          );
        });
  }

  Widget _createSummaryContainer(BuildContext context) {
//    double orderVal = DmState.calculateTotalMoneyPaidOnCarts();
    double serFee = DmState.calculateServiceFeeOnCarts();
//    double deliverFee = _con.order.deliveryFee;
//          double discount = _con.order.voucherDiscount;
//    double total = orderVal + serFee + deliverFee - _con.order.voucherDiscount;
//    double vat = total * DmState.vatPercent;
//    double grandTotal = total + vat;
    return Container(
      decoration: createRoundedBorderBoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _createSummaryRow(context, S.of(context).date, fmt.format(DateTime.now())),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).totalItems, '${_con.order.totalItems}'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).orderValue, getDisplayMoney(_con.order.orderVal), isBold: true),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).serviceFee, getDisplayMoney(_con.order.serviceFee)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).deliveryFee, getDisplayMoney(_con.order.deliveryFee)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).discount, getDisplayMoney(_con.order.voucherDiscount)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).total, getDisplayMoney(_con.order.totalBeforeTax), isBold: true),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).VAT, getDisplayMoney(_con.order.tax)),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).grandTotal.toUpperCase(), getDisplayMoney(_con.order.grandTotal),
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
          _createSummaryRow(context, S.of(context).fullName, widget.order.deliveryAddress.fullName,
              txtAlign2: TextAlign.start),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).phone, widget.order.deliveryAddress.phoneNumber,
              txtAlign2: TextAlign.start),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).date, widget.order.getDeliverDateSlot, txtAlign2: TextAlign.start),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).address, widget.order.deliveryAddress.getFullAddress,
              txtAlign2: TextAlign.start),
        ],
      ),
    );
  }

  Row _createVoucherRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextField(
              style: TextStyle(color: DmConst.accentColor),
              keyboardType: TextInputType.text,
              maxLines: 1,
              onChanged: (txt) => this.voucher = txt,
              onSubmitted: (input) {
//                print('your input voucher code = $input');
              },
//                            validator: (input) => !input.contains('@') ? S.of(context).invalidAddress : null,
              decoration: new InputDecoration(
                hintText: S.of(context).voucherCode,
                hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                prefixIcon: Icon(UiIcons.gift),
//                              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
          ),
        ),
        FlatButton(
          child: Text(S.of(context).apply),
          onPressed: onPressedOnApplyVoucher,
          color: DmConst.accentColor,
        )
      ],
    );
  }

  void onPressedOnPlaceOrder() {
    print('onPressedOnPlaceOrder--------');
//    Navigator.of(context).pushReplacementNamed('/OrderSuccess');
    DmState.refreshCart([]);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderSuccessScreen(_con.order)));
  }

  Widget _createDatePiker(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      height: 80,
      controller: _datePickerController,
      initialSelectedDate: DateTime.now(),
      selectionColor: Theme.of(context).accentColor,
      selectedTextColor: Colors.white,
//      inactiveDates: [
//        DateTime.now().add(Duration(days: 3)),
//        DateTime.now().add(Duration(days: 4)),
//        DateTime.now().add(Duration(days: 7))
//      ],
      onDateChange: (selectedDate) {
        // New date selected
        setState(() {
//          DateTime selectedValue = date;
          print(selectedDate);
        });
      },
    );
  }

  Widget _createRowSelectDeliveryTime(String strTime, int status, double diFee) {
    if (status == 0) {
      return Row(
        children: [
          Expanded(flex: 7, child: Text('$strTime')),
          Expanded(
              flex: 3,
              child: OutlineButton(onPressed: null, child: Text(S.of(context).full), color: DmConst.accentColor)),
        ],
      );
    } else if (status > 0) {
      // selected
      return Row(
        children: [
          Expanded(flex: 7, child: Text('$strTime')),
          Expanded(
            flex: 3,
            child: FlatButton(
                onPressed: () {
                  print('Press on button');
                },
                color: Theme.of(context).accentColor,
                child: Text('\$ ${diFee.toStringAsFixed(2)}')),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(flex: 7, child: Text('$strTime')),
          Expanded(
              flex: 3,
              child: OutlineButton(
                  onPressed: () {
                    print('Press on button');
                  },
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                  child: Text(
                    '\$ ${diFee.toStringAsFixed(2)}',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ))),
        ],
      );
    }
  }

  void onPressedOnApplyVoucher() {
    print('onPressedOnApplyVoucher $voucher');
    if(voucher != null && voucher.isNotEmpty) {
      _con.listenVoucher(code: this.voucher);
    } else {
      setState(() {
        _con.order.applyVoucher(null);
      });
    }
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
                  title: S.of(context).orderSummary,
                  titleTextColor: Theme.of(context).accentColor,
                  dividerColor: Colors.grey.shade400,
                  dividerThickness: 2),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _createSummaryContainer(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad, vertical: 10),
              child: TitleDivider(
                  title: S.of(context).voucher,
                  titleTextColor: Theme.of(context).accentColor,
                  dividerColor: Colors.grey.shade400,
                  dividerThickness: 2),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad, vertical: 10),
                child: _createVoucherRow(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TitleDivider(
                  title: S.of(context).deliverTo,
                  titleTextColor: Theme.of(context).accentColor,
                  dividerColor: Colors.grey.shade400,
                  dividerThickness: 2),
            ),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: _createDeliverToContainer(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TitleDivider(
                  title: S.of(context).itemsList,
                  titleTextColor: Theme.of(context).accentColor,
                  dividerColor: Colors.grey.shade400,
                  dividerThickness: 2),
            ),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              crossAxisCount: 1,
              crossAxisSpacing: 1.5,
              childAspectRatio: 337.0 / 120,
              children: List.generate(
                DmState.carts.length,
                (index) {
                  Cart c = DmState.carts.elementAt(index);
                  Product product = c.product;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductItemWide(
                      product: product,
                      heroTag: 'productOnCart$index',
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CartBottomButton(
        title: S.of(context).placeOrder,
        onPressed: onPressedOnPlaceOrder,
      ),
    );
  }
}
