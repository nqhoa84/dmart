import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dmart/src/controllers/delivery_pickup_controller.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import 'contactus.dart';
import 'delivery_to.dart';

class PlaceOrderScreen extends StatefulWidget {
  int countItem = 10;
  double grandTotal = 100.0;

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends StateMVC<PlaceOrderScreen> {
  DeliveryPickupController _con;
  DatePickerController _datePickerController = DatePickerController();

  _PlaceOrderScreenState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  void initState() {
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
        appBar: createAppBar(context, _con.scaffoldKey),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        body: _createProductsGrid(context),
      ),
    );
  }

  Widget _createSummaryRow(BuildContext context, String text1, String text2, {bool isBold = false}) {
    if(isBold)
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(text1, style: TextStyle(fontWeight: FontWeight.bold))),
            Text(":"),
            Expanded(flex: 3, child: Text(text2, textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(text1)),
            Text(":"),
            Expanded(flex: 3, child: Text(text2, textAlign: TextAlign.right)),
          ],
        ),
      );
  }

  DateFormat fmt = DateFormat.yMMMd('en_US').add_Hm();

  Stack _createProductsGrid(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        //display list of product on gridView.
        Container(
          padding: EdgeInsets.only(bottom: 15),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                createTitleRowWithBack(context, title: S.of(context).myCart),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad, vertical: 10),
                  child: TitleDivider(
                      title: S.of(context).orderSummary,
                      titleTextColor: Theme.of(context).accentColor,
                      dividerColor: Colors.grey.shade400,
                      dividerThickness: 2),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _createSummaryContainer(context)),
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
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _createDeliverToContainer(context)),
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
                  children: List.generate( _con.carts.length, (index) {
                    Cart c = _con.carts.elementAt(index);
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
        ),
        //Bottom Process order space.
        Positioned(
          bottom: 0,
          child: CartBottomButton(
            countItem: widget.countItem,
            grandTotalMoney: widget.grandTotal,
            title: S.of(context).placeOrder,
            onPressed: onPressedOnPlaceOrder,
          ),
        )
      ],
    );
  }

  Container _createSummaryContainer(BuildContext context) {
    return Container(
                    decoration: createRoundedBorderBoxDecoration(),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _createSummaryRow(context, S.of(context).date, fmt.format(DateTime.now())),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).totalItems, '${widget.countItem}'),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).orderValue, '${widget.grandTotal}', isBold: true),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).serviceFee, '\$ xx.xx'),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).deliveryFee, '\$ xx.xx'),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).discount, '\$ xx.xx'),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).total, '\$ xx.xx', isBold: true),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).VAT, '\$ xx.xx'),
                        Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        _createSummaryRow(context, S.of(context).grandTotal.toUpperCase(), '\$ xx.xx', isBold: true),
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
          _createSummaryRow(context, S.of(context).fullName, 'person name'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).phone, 'Phone'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, S.of(context).address, 'asdfdf'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, '', 'xxxxxxxxx'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createSummaryRow(context, '', S.of(context).phnompenh),
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
                            onSubmitted: (input) {
                              print('your input voucher code = input');
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
                      FlatButton(child: Text(S.of(context).apply),
                      onPressed: onPressedOnApplyVoucher, color: DmConst.accentColor,)
                    ],
                  );
  }

  void onPressedOnPlaceOrder() {
    print('onPressedOnDeliveryInfo');
    Navigator.of(context).pushReplacementNamed('/OrderSuccess');
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

  @override
  Widget _build(BuildContext context) {
    return Container();
//    return Scaffold(
//      key: _con.scaffoldKey,
//      appBar: AppBar(
//        backgroundColor: Colors.transparent,
//        elevation: 0,
//        centerTitle: true,
//        leading: new IconButton(
//          icon: new Icon(UiIcons.return_icon,
//              color: Theme.of(context).hintColor),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//        title: Text(
//          S.of(context).deliveryPickup,
//          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
//        ),
//        actions: <Widget>[
//          new ShoppingCartButton(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
//        ],
//      ),
//      body: SingleChildScrollView(
//        padding: EdgeInsets.symmetric(vertical: 10),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          mainAxisAlignment: MainAxisAlignment.start,
//          mainAxisSize: MainAxisSize.max,
//          children: <Widget>[
//            Padding(
//              //padding: const EdgeInsets.only(left: 20, right: 10),
//              padding: const EdgeInsetsDirectional.only(start: 20, end: 10),
//              child: ListTile(
//                contentPadding: EdgeInsets.symmetric(vertical: 0),
//                leading: Icon(
//                  Icons.domain,
//                  color: Theme.of(context).hintColor,
//                ),
//                title: Text(
//                  S.of(context).pickup,
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                  style: Theme.of(context).textTheme.headline4,
//                ),
//                subtitle: Text('pickup_your_product_from_the_store',
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                  style: Theme.of(context).textTheme.caption,
//                ),
//              ),
//            ),
//            ListView.separated(
//              scrollDirection: Axis.vertical,
//              shrinkWrap: true,
//              primary: false,
//              itemCount: list.pickupList.length,
//              separatorBuilder: (context, index) {
//                return SizedBox(height: 10);
//              },
//              itemBuilder: (context, index) {
//                return PaymentMethodListItemWidget(paymentMethod: list.pickupList.elementAt(index));
//              },
//            ),
//            _con.carts.isNotEmpty && Helper.canDelivery(carts: _con.carts)
//                ? Column(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 10),
//                        child: ListTile(
//                          contentPadding: EdgeInsets.symmetric(vertical: 0),
//                          leading: Icon(
//                            Icons.map,
//                            color: Theme.of(context).hintColor,
//                          ),
//                          title: Text(
//                            S.of(context).delivery,
//                            maxLines: 1,
//                            overflow: TextOverflow.ellipsis,
//                            style: Theme.of(context).textTheme.headline4,
//                          ),
//                          subtitle: Text(
//                            S.of(context).click_to_confirm_your_address_and_pay_or_long_press,
//                            maxLines: 3,
//                            overflow: TextOverflow.ellipsis,
//                            style: Theme.of(context).textTheme.caption,
//                          ),
//                        ),
//                      ),
//                      DeliveryAddressesItemWidget(
//                        address: _con.deliveryAddress,
//                        onPressed: (Address _address) {
//                          if (_con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null') {
//                            DeliveryAddressDialog(
//                              context: context,
//                              address: _address,
//                              onChanged: (Address _address) {
//                                _con.addAddress(_address);
//                              },
//                            );
//                          } else {
//                            Navigator.of(context).pushNamed('/PaymentMethod');
//                          }
//                        },
//                        onLongPress: (Address _address) {
//                          DeliveryAddressDialog(
//                            context: context,
//                            address: _address,
//                            onChanged: (Address _address) {
//                              _con.updateAddress(_address);
//                            },
//                          );
//                        },
//                      )
//                    ],
//                  )
//                : SizedBox(
//                    height: 0,
//                  ),
//          ],
//        ),
//      ),
//    );
  }

  void onPressedOnApplyVoucher() {
    print('onPressedOnApplyVoucher');
  }
}
