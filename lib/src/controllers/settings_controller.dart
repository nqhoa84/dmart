import 'package:dmart/src/models/address.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import 'controller.dart';

class ProfileInfoController extends Controller {
  bool loading = false;
  bool isPersonalChange = false;
  bool isAddrChanged = false;
  GlobalKey<FormState> personalDetailFormKey;
  GlobalKey<FormState> addressFormKey;
  GlobalKey<FormState> changePassFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  User user = User();

  String newPass;
  String currentPass;

  Address defaultAddress;
  List<Address> _allAddrs = [];

//  Address defaultAddress;

  ProfileInfoController() {
    personalDetailFormKey = GlobalKey<FormState>();
    addressFormKey = GlobalKey<FormState>();
    changePassFormKey = GlobalKey<FormState>();
    this.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<bool> updatePersonDetail() async {
//    if (loading) return false;
//    loading = true;
//    User u = await userRepo.updatePersonalDetail(user);
//    setState((){
//      this.isPersonalChange = false;
//    });
//    loading = false;
//    return u.isValid;

    if (loading) return false;
    User u;
    bool re = false;
    try {
      setState(() => loading = true);
      u = await userRepo.updatePersonalDetail(user);
      setState(() => this.isPersonalChange = false);
      if (u != null) {
        showMsg(S.current.accountInfoUpdated);
        this.user = u;
        re = true;
      } else {
        showErrGeneral();
      }
    } on Exception catch (e, trace) {
      setState(() => loading = false);
      print("$e $trace");
      showErrGeneral();
    }
    setState(() => loading = false);
    return re;
  }

  Future<bool> changePwd() async {
    if (loading) return false;
    bool re = false;
    try {
      setState(() => loading = true);
      re = await userRepo.changePwd(user.phoneWith855, this.currentPass, this.newPass);
      if (re == true) {
        showMsg(S.current.passwordChanged);
      } else {
        showErrGeneral();
      }
    } on Exception catch (e, trace) {
//      setState(() => loading = false);
      print("$e $trace");
      showErrGeneral();
    }
    setState(() => loading = false);
    return re;
  }

  getAddrs() async {
    final Stream<Address> stream = await userRepo.getAddresses();
    this._allAddrs.clear();
    this.defaultAddress = null;
    stream.listen(
      (Address a) {
        if (a.isValid) {
          _allAddrs.add(a);
          if (a.isDefault && this.defaultAddress == null) {
            setState((){this.defaultAddress = a;});
          }
        }
      },
      onError: (a) {
        print(a);
      },
      onDone: () {
        if (_allAddrs.length > 0 && this.defaultAddress == null) {
          setState((){this.defaultAddress = _allAddrs[0];});
        }
      },
    );
  }
}
