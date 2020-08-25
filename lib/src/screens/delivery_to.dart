import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dmart/src/screens/contactus.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/IconWithText.dart';
import 'package:flutter/rendering.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../widgets/DeliveryAddressDialog.dart';
import '../widgets/DeliveryAddressesItemWidget.dart';
import '../widgets/PaymentMethodListItemWidget.dart';
import '../widgets/ShoppingCartButton.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/route_argument.dart';

class DeliveryToScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  final int countItem = 10;
  final double grandTotal = 100.0;

  DeliveryToScreen({Key key, this.routeArgument}) : super(key: key) {}

  @override
  _DeliveryToScreenState createState() => _DeliveryToScreenState();
}

class _DeliveryToScreenState extends StateMVC<DeliveryToScreen> {
  DeliveryPickupController _con;
  DatePickerController _datePickerController = DatePickerController();

  _DeliveryToScreenState() : super(DeliveryPickupController()) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TitleDivider(
                      title: S.of(context).deliverTo,
                      titleTextColor: Theme.of(context).accentColor,
                      dividerColor: Colors.grey.shade400,
                      dividerThickness: 2),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
//                      color: Colors.grey,
                      decoration: createRoundedBorderBoxDecoration(),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: DmConst.accentColor),

                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) {
                              print('afddf _con.user.email = input');
                            },
//                            validator: (input) => !input.contains('@') ? S.of(context).invalidAddress : null,
                            decoration: new InputDecoration(
//                              hintText: S.of(context).emailAddress,
//                              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
//                              prefixStyle: Theme.of(context).textTheme.headline5.copyWith(color: DmConst.accentColor),
                              labelText: S.of(context).fullName + ':',
                            ),

                          ),
                          TextFormField(
                            style: TextStyle(color: DmConst.accentColor),
                            keyboardType: TextInputType.phone,
                            onSaved: (input) {
                              print('afddf _con.user.email = input');
                            },
//                            validator: (input) => !input.contains('@') ? S.of(context).invalidAddress : null,
                            decoration: new InputDecoration(
//                              hintText: S.of(context).emailAddress,
//                              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                              labelText: S.of(context).phone + ':',
                            ),
                          ),
                          TextFormField(
                            style: TextStyle(color: DmConst.accentColor),
                            keyboardType: TextInputType.multiline, maxLines: 3,
                            onSaved: (input) {
                              print('afddf _con.user.email = input');
                            },
//                            validator: (input) => !input.contains('@') ? S.of(context).invalidAddress : null,
                            decoration: new InputDecoration(
//                              hintText: S.of(context).emailAddress,
//                              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                              labelText: S.of(context).address + ':',
                            ),
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TitleDivider(
                      title: S.of(context).selectDeliveryTime,
                      titleTextColor: Theme.of(context).accentColor,
                      dividerColor: Colors.grey.shade400,
                      dividerThickness: 2),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Container(
                      decoration: createRoundedBorderBoxDecoration(),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          _createDatePiker(context),
                          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                          _createRowSelectDeliveryTime('10:00 - 12:00', 0, 1.5),
                          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                          _createRowSelectDeliveryTime('12:00 - 14:00', 1, 1.5),
                          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                          _createRowSelectDeliveryTime('14:00 - 16:00', -10, 1.5),
                          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                          _createRowSelectDeliveryTime('16:00 - 18:00', -10, 1.5),
                          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                          _createRowSelectDeliveryTime('18:00 - 20:00', -10, 1.5),
                          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TitleDivider(
                      title: S.of(context).note,
                      titleTextColor: Theme.of(context).accentColor,
                      dividerColor: Colors.grey.shade400,
                      dividerThickness: 2),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
//                      color: Colors.grey,
                      decoration: createRoundedBorderBoxDecoration(),
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        style: TextStyle(color: DmConst.accentColor),
                        keyboardType: TextInputType.multiline, maxLines: 3,
                        onSaved: (input) {
                          print('afddf _con.user.email = input');
                        },
//                            validator: (input) => !input.contains('@') ? S.of(context).invalidAddress : null,
                        decoration: new InputDecoration(
//                              hintText: S.of(context).emailAddress,
//                              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                        ),
                      ),
                    )),
                SizedBox(height: 50),
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
            title: S.of(context).deliveryInfo,
            onPressed: onPressedOnDeliveryInfo,
          ),
        )
      ],
    );
  }

  void onPressedOnDeliveryInfo() {
    print('onPressedOnDeliveryInfo');
    Navigator.of(context).pushNamed('/PlaceOrder');
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
}

class CartBottomButton extends StatelessWidget {
  const CartBottomButton({Key key, this.countItem = 0, this.grandTotalMoney = 0, this.title = '', this.onPressed})
      : super(key: key);

  final int countItem;
  final double grandTotalMoney;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 2,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      decoration: BoxDecoration(
//                color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
//                border: Border.all(color: Colors.red, width: 2),
          boxShadow: [
            BoxShadow(color: DmConst.colorFavorite.withOpacity(0.9), offset: Offset(0, -2), blurRadius: 5.0)
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconWithText(
                      title: '$countItem',
                      icon: UiIcons.shopping_cart,
                      color: Colors.white,
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                  child: IconWithText(
                      title: '${this.grandTotalMoney.toStringAsFixed(2)}',
                      icon: UiIcons.money,
                      color: Colors.white,
                      style: Theme.of(context).textTheme.headline6),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          VerticalDivider(thickness: 2, color: Colors.white),
          Expanded(
              child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: Text(title, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
            onPressed: onPressed,
          ))
//                FlatButton(child: Text(S.of(context).processOrder))
        ],
      ),
    );
  }
}
