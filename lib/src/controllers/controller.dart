import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class Controller extends ControllerMVC {
  bool loading = false;

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  Controller() ;

  void showErr(String msg) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text('$msg', style: TextStyle(color: DmConst.colorFavorite)),
    ));
  }

  void showMsg(String msg) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(
      content: Text('$msg', style: TextStyle(color: DmConst.accentColor)),
    ));
  }

  void showErrNoInternet() {
    showErr(S.current.verifyYourInternetConnection);
  }

  void showErrGeneral() {
    showErr(S.current.generalErrorMessage);
  }

  void setLoadingOn() {
    setState((){
      this.loading = true;
    });
  }

  void setLoadingOff() {
    setState((){
      this.loading = false;
    });
  }
}
