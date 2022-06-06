import 'package:flutter/material.dart';

import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import 'cart_controller.dart';

class DeliveryPickupController extends CartController {
  late GlobalKey<ScaffoldState> scaffoldKey;
  model.Address? deliveryAddress;
  List<Cart>? cart;

  DeliveryPickupController(
    this.deliveryAddress,
    this.cart,
  ) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForCart();
    listenForDeliveryAddress();
    print(settingRepo.deliveryAddress.value.toMap());
  }

  void listenForCart() async {
    final Stream<Cart?> stream = await getCarts();
    stream.listen((Cart? _cart) {
      setState(() {
        carts.add(_cart!);
      });
    });
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
    print(this.deliveryAddress!.id);
  }

  void addAddress(model.Address address) {
//    userRepo.addAddress(address).then((value) {
//      setState(() {
//        settingRepo.deliveryAddress.value = value;
//        this.deliveryAddress = value;
//      });
//    }).whenComplete(() {
//      scaffoldKey?.currentState?.showSnackBar(SnackBar(
//        content: Text(S.current.newAddressAdded),
//      ));
//    });
  }

  void updateAddress(model.Address address) {
//    userRepo.updateAddress(address).then((value) {
//      setState(() {
//        settingRepo.deliveryAddress.value = value;
//        this.deliveryAddress = value;
//      });
//    }).whenComplete(() {
//      scaffoldKey?.currentState?.showSnackBar(SnackBar(
//        content: Text(S.current.addressUpdated),
//      ));
//    });
  }

  /*@override
  void goCheckout(BuildContext context) {
    Navigator.of(context).pushNamed(route);
  }*/
}
