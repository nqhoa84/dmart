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
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class DeliveryAddressesWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryAddressesWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryAddressesWidgetState createState() => _DeliveryAddressesWidgetState();
}

class _DeliveryAddressesWidgetState extends StateMVC<DeliveryAddressesWidget> {
  DeliveryAddressesController _con;
  PaymentMethodList list;

  _DeliveryAddressesWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  void initState() {
    list = new PaymentMethodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                _con.addAddress(new Address.fromJSON({
                  'address': result.address,
                  'latitude': result.latLng.latitude,
                  'longitude': result.latLng.longitude,
                }));
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
}
