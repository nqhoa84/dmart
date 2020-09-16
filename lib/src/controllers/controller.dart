import 'package:dmart/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class Controller extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  Controller({this.scaffoldKey});

  void showErr(String msg) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text('$msg'),
    ));
  }

  void showMsg(String msg) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text('$msg'),
    ));
  }

  void showErrNoInternet() {
    showErr(S.of(context).verifyYourInternetConnection);
  }

  void showErrGeneral() {
    showErr(S.of(context).generalErrorMessage);
  }
}
