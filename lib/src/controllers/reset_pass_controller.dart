import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import 'controller.dart';

class ResetPassController extends Controller {
  User? user = new User();
  bool? hidePassword = true, hidePassword2 = true;
  bool loading = false;
  late GlobalKey<FormState> resetPassFormKey;
  late GlobalKey<FormState> newPassFormKey;
  late GlobalKey<ScaffoldState> scaffoldKey;

  String? otp;

  ResetPassController({
    this.hidePassword,
    this.otp,
  }) {
    resetPassFormKey = GlobalKey<FormState>();
    newPassFormKey = GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<bool> sendOtpForgotPass() async {
    resetPassFormKey.currentState!.save();
    if (resetPassFormKey.currentState!.validate()) {
      setState(() => this.loading = true);
      try {
        this.otp = await repository.sendOtpForgotPass(user!.phoneWith855);

        if (otp != null) {
          showMsg(S.current.resetPassOtpSent);
          return true;
        } else {
          showErrGeneral();
        }
      } on Exception {
        showErrGeneral();
      }
      setState(() => this.loading = false);
    }
    return false;
  }

  Future<bool?> saveNewPasses(String userEnterOtp) async {
    if (this.otp != userEnterOtp) {
      showErr(S.current.invalidOTP);
      return false;
    }
    bool re = false;
    newPassFormKey.currentState!.save();
    if (this.newPassFormKey.currentState!.validate()) {
      setState(() => this.loading = true);
      try {
        re = await repository.resetPassword(
            user!.phoneWith855, userEnterOtp, user!.password!);
      } on Exception {
        showErrGeneral();
      }
      setState(() => this.loading = false);
      return re;
    }
    return null;
  }
}
