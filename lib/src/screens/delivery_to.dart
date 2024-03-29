import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/order_controller.dart';
import 'package:dmart/src/controllers/user_controller.dart';
import 'package:dmart/src/models/DateSlot.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/screens/AddressScreen.dart';
import 'package:dmart/src/screens/place_order.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../models/address.dart';
import '../models/route_argument.dart';
import '../widgets/cart_bottom_button.dart';

class DeliveryToScreen extends StatefulWidget {
  final RouteArgument routeArgument;
  final int countItem = 10;
  final double grandTotal = 100.0;

  DeliveryToScreen({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryToScreenState createState() => _DeliveryToScreenState();
}

class _DeliveryToScreenState extends StateMVC<DeliveryToScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  UserController _con;
  DatePickerController _datePickerController = DatePickerController();

  Order newOrder = Order();
  DateSlot currentDateSlot;

//  double deliverFee = 1.5;
  OrderController _orderCon = OrderController();

  _DeliveryToScreenState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    currentDateSlot = DateSlot();
    newOrder.expectedDeliverDate = DateTime.now();
    _orderCon.listenForDeliverSlot(date: DateTime.now()).then((value) {
      setState(() {
        currentDateSlot = value;
        currentDateSlot.disableCurrentNextSlots();
      });
    });
    _con.listenForDeliveryAddresses(onComplete: () {
      newOrder.deliveryAddress = getDeliverAddr();
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
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        endDrawer: Drawer(
          child: _createSelectAddressWid(context, _con.deliveryAddresses),
        ),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  createSliverTopBar(context),
                  createSliverSearch(context),
                  createSilverTopMenu(context, haveBackIcon: true, title: S.current.myCart),
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
      ),
    );
  }

  Widget _createSelectAddressWid(BuildContext context, List<Address> adds) {
    List<Widget> items = [];
    items.add(Text(S.current.selectDeliveryAddress,
        style: Theme.of(context).textTheme.headline6.copyWith(color: DmConst.accentColor)));
    adds.forEach((Address a) {
      items.add(Column(
        children: [
          ListTile(
            title: Text(S.current.useThisAddr),
            leading: Radio<Address>(
              value: a,
              groupValue: newOrder.deliveryAddress,
              onChanged: (value) {
                setState(() {
                  newOrder.deliveryAddress = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: this.buildDeliverInfo(context, a),
          ),
          Divider(thickness: 1.5)
        ],
      ));
    });

    items.add(TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(S.current.ok),
//                shape: StadiumBorder(),
    ));

    items.add(Divider(thickness: 1.5));

    items.add(OutlineButton(
      onPressed: onPressCreateNewAddress,
      child: Text(S.current.addDeliveryAddress,
        style: TextStyle(color: DmConst.accentColor),
      ),
      borderSide: BorderSide(color: DmConst.accentColor),

    ));

    items.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        onPressed: () {
          RouteGenerator.gotoAddressesScreen(context);
        },
        child: Text(S.current.deliveryAddresses, style: TextStyle(color: DmConst.accentColor)),
        borderSide: BorderSide(color: DmConst.accentColor),
      ),
    ));

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: items,
        ),
      ),
    );
  }

  void onPressCreateNewAddress() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressScreen())).then((value) {
      print('-------value return from pop $value');
      if(value != null && value is List<Address>) {
        setState(() {_con.deliveryAddresses = value;});
      }
    });
  }

  Widget buildBottom(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CartBottomButton(title: S.current.deliverTo, onPressed: _onPressedOnDeliveryInfo),
    );
  }

  void _onPressedOnDeliveryInfo() {
    if (newOrder.deliveryAddress == null || !newOrder.deliveryAddress.isValid) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('${S.current.invalidAddress}', style: TextStyle(color: Colors.red))));
      return;
    }
    if (newOrder.expectedDeliverSlotTime == null || newOrder.expectedDeliverSlotTime < 0) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('${S.current.invalidDeliveryDateTime}', style: TextStyle(color: Colors.red))));
      return;
    }

    if (DmState.amountInCart.value <= 0) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('${S.current.yourCartEmpty}', style: TextStyle(color: Colors.red))));
      return;
    }

    newOrder.applyDeliveryFee(DmState.orderSetting.deliveryFee);
    newOrder.applyCarts(DmState.carts);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceOrderScreen(this.newOrder)));
  }

  Widget buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: SingleChildScrollView(
//        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TitleDivider(title: S.current.deliverTo),
                  ),
                  IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        _scaffoldKey.currentState.openEndDrawer();
                      })
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: buildDeliverInfo(context, newOrder.deliveryAddress)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TitleDivider(title: S.current.selectDeliveryTime),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: buildSelectDeliverTime(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TitleDivider(title: S.current.note),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
//                      color: Colors.grey,
                  decoration: createRoundedBorderBoxDecoration(),
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    style: TextStyle(color: DmConst.accentColor),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onSaved: (input) {
                      newOrder.note = input;
                      print('newOrder.hint = ${newOrder.note}');
                    },
                    onChanged: (value) {
                      newOrder.note = value;
                      print('newOrder.hint = ${newOrder.note}');
                    },
                    decoration: new InputDecoration(
//                              hintText: S.current.emailAddress,
//                              hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                    ),
                  ),
                )),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Address getDeliverAddr() {
    Address re = Address();
    if (_con.deliveryAddresses != null) {
      _con.deliveryAddresses.forEach((element) {
        if (element.isValid && element.isDefault) {
          re = element;
          return;
        }
      });
    }
    //don't have the default address
    if (re.isValid) {
      return re;
    } else if (_con.deliveryAddresses.length > 0) {
      //don't have the default address
      return _con.deliveryAddresses[0];
    } else {
      return Address();
    }
  }

  Container buildSelectDeliverTime(BuildContext context) {
    return Container(
      decoration: createRoundedBorderBoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _createDatePiker(context),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createRowSelectDeliveryTime('08:00 - 10:00',
              isFull: !currentDateSlot.is1slotOK, diFee: DmState.orderSetting.deliveryFee, timeSlotOfThisButton: 1),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createRowSelectDeliveryTime('10:00 - 12:00',
              isFull: !currentDateSlot.is2slotOK, diFee: DmState.orderSetting.deliveryFee, timeSlotOfThisButton: 2),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createRowSelectDeliveryTime('12:00 - 14:00',
              isFull: !currentDateSlot.is3slotOK, diFee: DmState.orderSetting.deliveryFee, timeSlotOfThisButton: 3),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createRowSelectDeliveryTime('14:00 - 16:00',
              isFull: !currentDateSlot.is4slotOK, diFee: DmState.orderSetting.deliveryFee, timeSlotOfThisButton: 4),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createRowSelectDeliveryTime('16:00 - 18:00',
              isFull: !currentDateSlot.is5slotOK, diFee: DmState.orderSetting.deliveryFee, timeSlotOfThisButton: 5),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createRowSelectDeliveryTime('18:00 - 20:00',
              isFull: !currentDateSlot.is6slotOK, diFee: DmState.orderSetting.deliveryFee, timeSlotOfThisButton: 6),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
        ],
      ),
    );
  }

  Container buildDeliverInfo(BuildContext context, Address address) {
//    Address deliverAdd = getDeliverAddr();
    return Container(
      decoration: createRoundedBorderBoxDecoration(),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _createDeliveryRow(context, '${S.current.fullName}', "${address?.fullName}"),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createDeliveryRow(context, '${S.current.phone}', '${address?.phone}'),
          Divider(thickness: 1, color: Colors.grey.shade400, height: 5),
          _createDeliveryRow(context, '${S.current.address}', '${address?.getFullAddress}'),
        ],
      ),
    );
  }

  Widget _createDatePiker(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      height: 110,
      controller: _datePickerController,
      initialSelectedDate: DateTime.now(),
      selectionColor: Theme.of(context).accentColor,
      selectedTextColor: Colors.white,
//      inactiveDates: [
//        DateTime.now().add(Duration(days: 3)),
//        DateTime.now().add(Duration(days: 4)),
//        DateTime.now().add(Duration(days: 7))
//      ],
      onDateChange: _onSelectedDateChanged,
    );
  }

  void _onSelectedDateChanged(DateTime selectedDate) {
    _orderCon.listenForDeliverSlot(date: selectedDate).then((value) {
      setState(() {
        newOrder.expectedDeliverDate = selectedDate;
        currentDateSlot = value;
        currentDateSlot.disableCurrentNextSlots();
        if ((newOrder.expectedDeliverSlotTime == 1 && !currentDateSlot.is1slotOK) ||
            (newOrder.expectedDeliverSlotTime == 2 && !currentDateSlot.is2slotOK) ||
            (newOrder.expectedDeliverSlotTime == 3 && !currentDateSlot.is3slotOK) ||
            (newOrder.expectedDeliverSlotTime == 4 && !currentDateSlot.is4slotOK) ||
            (newOrder.expectedDeliverSlotTime == 5 && !currentDateSlot.is5slotOK) ||
            (newOrder.expectedDeliverSlotTime == 6 && !currentDateSlot.is6slotOK)) {
          newOrder.expectedDeliverSlotTime = -1;
        }

      });
    });
  }

//  DateTime selectedDeliverDate;
//  int selectedDeliverSlot;
  Widget _createRowSelectDeliveryTime(String strTime,
      {bool isFull = false, double diFee = 1.5, int timeSlotOfThisButton}) {
    if (isFull) {
      return Row(
        children: [
          Expanded(flex: 7, child: Text('$strTime')),
          Expanded(
              flex: 3,
              child: OutlineButton(onPressed: null, child: Text(S.current.full),
                  color: DmConst.accentColor,
                borderSide: BorderSide(color: DmConst.accentColor),
              )),
        ],
      );
    } else {
      if (newOrder.expectedDeliverSlotTime == timeSlotOfThisButton) {
        // selected
        return Row(
          children: [
            Expanded(flex: 7, child: Text('$strTime')),
            Expanded(
              flex: 3,
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      newOrder.expectedDeliverSlotTime = timeSlotOfThisButton;
                    });
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
                      setState(() {
                        newOrder.expectedDeliverSlotTime = timeSlotOfThisButton;
                      });
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
  }

  Widget _createDeliveryRow(BuildContext context, String text1, String text2, {bool isBold = false}) {
    if (isBold)
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(text1, style: TextStyle(fontWeight: FontWeight.bold))),
            Text(":"),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(text2, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold)),
                )),
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
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(text2, textAlign: TextAlign.left),
                )),
          ],
        ),
      );
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
//          S.current.deliveryPickup,
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
//                  S.current.pickup,
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
//                            S.current.delivery,
//                            maxLines: 1,
//                            overflow: TextOverflow.ellipsis,
//                            style: Theme.of(context).textTheme.headline4,
//                          ),
//                          subtitle: Text(
//                            S.current.click_to_confirm_your_address_and_pay_or_long_press,
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
