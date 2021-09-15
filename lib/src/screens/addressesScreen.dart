import 'package:dmart/src/screens/AddressScreen.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/IconWithText.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
//import 'package:google_map_location_picker/google_map_location_picker.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/DeliveryAddressDialog.dart';
import '../widgets/DeliveryAddressesItemWidget.dart';
import '../widgets/ShoppingCartButton.dart';
import '../models/address.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class AddressesScreen extends StatefulWidget {
  final RouteArgument routeArgument;

  AddressesScreen({Key key, this.routeArgument}) : super(key: key);

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends StateMVC<AddressesScreen> {
  DeliveryAddressesController _con;

  _AddressesScreenState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForAddresses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(context, haveBackIcon: true, title: S.current.deliveryAddresses),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                    child: buildContent(context)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    if(_con.addresses == null) {
      return Center(child: CircularProgressIndicator());
    }

    if(_con.addresses.length == 0) {
      return Column(children: [
        IconWithText(title: S.current.addressesEmpty),

        buildRowButton(context),
      ],);
    }
    List<Widget> its = [];
    _con.addresses.forEach((a) {
      its.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.current.fullName}: '),
                  Expanded(child: Text('${a.fullName}')),
                ],
              ),
            ),
            Divider(thickness: 1, height: 2),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.current.phone}: '),
                  Expanded(child: Text('${a.phone}')),
                ],
              ),
            ),
            Divider(thickness: 1, height: 2),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.current.address}: '),
                  Expanded(child: Text('${a.getFullAddress}')),
                ],
              ),
            ),
            Divider(thickness: 1, height: 2),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.current.defaultDeliveryAddress}: '),
                  Expanded(child: Text('${a.isDefault ? S.current.yes : S.current.no}')),
                ],
              ),
            ),
            Divider(thickness: 1, height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonTheme(
                  minWidth: 80,
                  height: 30,
                  child: FlatButton(
                    onPressed: () {
                      onPressEditAddress(a);
                    },
                    child: Text(S.current.edit, style: TextStyle(color: Colors.white)),
                    color: DmConst.accentColor,
                  ),
                ),
                ButtonTheme(
                  minWidth: 80,
                  height: 30,
                  child: OutlineButton(
                    onPressed: () {
                      onPressDeleteAddress(a);
                    },
                    child: Text(S.current.delete, style: TextStyle(color: Colors.red)),
                    borderSide: BorderSide(color: DmConst.accentColor),
                  ),
                ),
              ],
            ),
            Divider(thickness: 2, height: 4)
          ],
        )
      );
    });
    its.add(SizedBox(height: 8));
    its.add(buildRowButton(context));
    return Column(children: its);
  }

  Widget buildRowButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlatButton(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            onPressed: onPressCreateNewAddress,
            child: Text(S.current.addDeliveryAddress,
                style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
            color: DmConst.accentColor,
//                    shape: StadiumBorder(),
          ),
        ),
      ],
    );
  }

  void onPressCreateNewAddress() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressScreen())).then((value) {
      print('-------value return from pop $value');
      if(value != null && value is List<Address>) {
        setState(() {_con.addresses = value;});
      }
    });
  }

  void onPressEditAddress(Address a) {
    print('onPressEditAddress ');
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressScreen(address: a))).then((value) {
      print('-------value return from pop $value');
      if(value != null && value is List<Address>) {
        setState(() {_con.addresses = value;});
      }
    });
  }

  void onPressDeleteAddress(Address a) {
    void _ok() {
      _con.removeDeliveryAddress(a);
      Navigator.of(context).pop<bool>(true);
    }

    void _cancel() {
      Navigator.of(context).pop<bool>(false);
    }

    showAlertDialog(context,
        onPressedOK: _ok, onPressedCancel: _cancel);
  }

  showAlertDialog(BuildContext context, {Function() onPressedOK, Function() onPressedCancel}) {
    // set up the buttons
    Widget cancelButton = OutlineButton(
      child: Text(S.current.cancel),
      onPressed: onPressedCancel,
      borderSide: BorderSide(color: DmConst.accentColor),
    );
    Widget continueButton = OutlineButton(
      child: Text(S.current.delete),
      onPressed: onPressedOK,
      borderSide: BorderSide(color: DmConst.accentColor),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${S.current.delete} ${S.current.address}'),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

///Widget to display Address. Note: display only.
class AddressInfoWid extends StatelessWidget {
  Address a;
  AddressInfoWid({@required Address address}) {
    this.a = address??Address();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.current.fullName}: '),
              Expanded(child: Text('${a.fullName}')),
            ],
          ),
        ),
        Divider(thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.current.phone}: '),
              Expanded(child: Text('${a.phone}')),
            ],
          ),
        ),
        Divider(thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.current.address}: '),
              Expanded(child: Text('${a.getFullAddress}')),
            ],
          ),
        ),
        Divider(thickness: 1, height: 1),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.current.defaultDeliveryAddress}: '),
              Expanded(child: Text('${a.isDefault ? S.current.yes : S.current.no}')),
            ],
          ),
        ),
      ],
    );
  }
}

