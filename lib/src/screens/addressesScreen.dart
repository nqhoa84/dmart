import 'package:dmart/src/screens/AddressScreen.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/IconWithText.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).deliveryAddresses),
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

  Widget _build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(UiIcons.return_icon,
              color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          S.of(context).deliveryAddresses,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButton(),
        ],
      ),
      floatingActionButton:// _con.cart != null && _con.cart.product.store.availableForDelivery
           FloatingActionButton(
              onPressed: () async {
                LocationResult result = await showLocationPicker(
                  context,
                  setting.value.googleMapsKey,
                  initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0, deliveryAddress.value?.longitude ?? 0),
                  //automaticallyAnimateToCurrentLocation: true,
                  //mapStylePath: 'assets/mapStyle.json',
                  myLocationButtonEnabled: true,
                  //resultCardAlignment: Alignment.bottomCenter,
                );
//                _con.addAddress(new Address.fromJSON({
//                  'address': result.address,
//                  'latitude': result.latLng.latitude,
//                  'longitude': result.latLng.longitude,
//                }));
                print("result = $result");
                //setState(() => _pickedLocation = result);
              },
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              )),
          //: SizedBox(height: 0),
      body: RefreshIndicator(
        onRefresh: _con.refreshAddresses,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.map,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).deliveryAddresses,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text('long_press_to_edit_item_swipe_item_to_delete_it',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              _con.addresses.isEmpty
                  ? CircularLoadingWidget(height: 250)
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.addresses.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15);
                      },
                      itemBuilder: (context, index) {
                        return DeliveryAddressesItemWidget(
                          address: _con.addresses.elementAt(index),
                          onPressed: (Address _address) {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.updateAddress(_address);
                              },
                            );
                          },
                          onLongPress: (Address _address) {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.updateAddress(_address);
                              },
                            );
                          },
                          onDismissed: (Address _address) {
                            _con.removeDeliveryAddress(_address);
                          },
                        );
                      },
                    ),
            ],
          ),
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
        IconWithText(title: S.of(context).addressesEmpty),

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
                  Text('${S.of(context).fullName}: '),
                  Expanded(child: Text('${a.fullName}')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.of(context).phone}: '),
                  Expanded(child: Text('${a.phone}')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.of(context).address}: '),
                  Expanded(child: Text('${a.getFullAddress}')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text('${S.of(context).defaultDeliveryAddress}: '),
                  Expanded(child: Text('${a.isDefault ? S.of(context).yes : S.of(context).no}')),
                ],
              ),
            ),
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
                    child: Text(S.of(context).edit, style: TextStyle(color: Colors.white)),
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
                    child: Text(S.of(context).delete, style: TextStyle(color: Colors.red)),
//                  color: DmConst.accentColor,
                  ),
                ),
              ],
            ),
            Divider(thickness: 2, height: 4)
          ],
        )
      );
    });
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
            child: Text(S.of(context).addDeliveryAddress,
                style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
            color: DmConst.accentColor,
//                    shape: StadiumBorder(),
          ),
        ),
      ],
    );
  }

  void onPressCreateNewAddress() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressWid())).then((value) {
      print('-------value return from pop $value');
      if(value != null && value is List<Address>) {
        setState(() {_con.addresses = value;});
      }
    });
  }

  void onPressEditAddress(Address a) {
    print('onPressEditAddress ');
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddressWid(address: a))).then((value) {
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
      child: Text(S.of(context).cancel),
      onPressed: onPressedCancel,
    );
    Widget continueButton = OutlineButton(
      child: Text(S.of(context).delete),
      onPressed: onPressedOK,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${S.of(context).delete} ${S.of(context).address}'),
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
              Text('${S.of(context).fullName}: '),
              Expanded(child: Text('${a.fullName}')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.of(context).phone}: '),
              Expanded(child: Text('${a.phone}')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.of(context).address}: '),
              Expanded(child: Text('${a.getFullAddress}')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Text('${S.of(context).defaultDeliveryAddress}: '),
              Expanded(child: Text('${a.isDefault ? S.of(context).yes : S.of(context).no}')),
            ],
          ),
        ),
      ],
    );
  }
}

