import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  String resetPassPhone;
  bool hidePassword = true, hidePassword2 = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> resetPassFormKey;
  GlobalKey<FormState> newPassFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  OverlayEntry loader;

  Address address = new Address();

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    resetPassFormKey = GlobalKey<FormState>();
    newPassFormKey = GlobalKey<FormState>();

    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured $e');
    });
  }

  bool isLoginError = false;
  void login() async {
    isLoginError = false;
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);

      repository.login(user).then((value) {
        if (value != null && value.id > 0) {
          RouteGenerator.gotoPromotions(context);
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.of(context).wrongEmailOrPassword),
          ));
          setState(() {
            isLoginError = true;
          });
        }
      }).catchError((e) {
        print(e);
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.of(context).emailAccountExists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  List<Address> deliveryAddresses = [];
  void listenForDeliveryAddresses({Function() onComplete}) async {
    final Stream<Address> stream = await getAddresses();
    deliveryAddresses.clear();
    stream.listen((Address addr) {
      setState(() {
        if(addr.isValid)
          deliveryAddresses.add(addr);
      });
//      print('new arrival, pro id =${_product.id}, name=${_product.name}');
    }, onError: (a) {
      print(a);
    }, onDone: onComplete,
    );
  }
}
