import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import 'controller.dart';

class ResetPassController extends Controller {
  User user = new User();
  bool hidePassword = true, hidePassword2 = true;
  bool loading = false;
  GlobalKey<FormState> resetPassFormKey;
  GlobalKey<FormState> newPassFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  String otp;

  ResetPassController() {
    resetPassFormKey = GlobalKey<FormState>();
    newPassFormKey = GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void resetPassword() async {
    if (resetPassFormKey.currentState.validate()) {
      resetPassFormKey.currentState.save();
      this.loading = true;
      try {
        this.otp = await repository.resetPassword(user.phone);
        setState((){});

        if(otp != null) {
          showMsg(S.of(context).resetPassOtpSent);
        } else {
          showErrGeneral();
        }
      } on Exception catch (e) {
        showErrGeneral();
      }
      this.loading = false;
    }
  }
}
