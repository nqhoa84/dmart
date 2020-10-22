import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:dmart/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import 'controller.dart';

class RegController extends Controller {
  User user = new User();
  bool hidePassword = true, hidePassword2 = true;
  bool loading = false;
  GlobalKey<FormState> regFormKey;
  GlobalKey<FormState> locationFormKey;
  OverlayEntry loader;

  Address address = new Address();
  bool isRegMobileExistedReg = false;


  RegController() {
    loader = Helper.overlayLoader(context);
    regFormKey = GlobalKey<FormState>();
    locationFormKey = GlobalKey<FormState>();
    this.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  String OTP;
  void register() async {
    if(loading) return;
    print('Start registering');
    FocusScope.of(context).unfocus();
    loading = true;
    regFormKey.currentState.save();
    if (regFormKey.currentState.validate()) {
//      Overlay.of(context).insert(loader);
      OTP = await userRepo.register(user);
//      repository.register(user).then((value) {
//        if (DmUtils.isNotNullEmptyStr(value)) { //register ok
//          OTP = value;
//        } else {
//          OTP = '';
//          scaffoldKey.currentState.showSnackBar(SnackBar(
//            content: Text(S.of(context).registerError),
//          ));
//        }
//      }).catchError((e) {
//        loader.remove();
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(S.of(context).registerError),
//        ));
//      }).whenComplete(() {
//        loading = false;
//        Helper.hideLoader(loader);
//      });
    }
    loading = false;
  }

  void resetPassword() {
    FocusScope.of(context).unfocus();
    if (regFormKey.currentState.validate()) {
      regFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      userRepo.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.of(context).resetLinkHasBeenSentToEmail),
            action: SnackBarAction(
              label: S.of(context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.of(context).errorVerifyEmail),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  Future<User> verifyOtp() async {
    if(loading) return currentUser.value;
    loading = true;
    User u = await userRepo.verifyOtp(user.phone, OTP);
    loading = false;
    return u;
  }

  Future<void> addAddress() async {
    if(loading) return;
    loading = true;
    this.address = await userRepo.addAddress(address);

    loading = false;
  }
}
