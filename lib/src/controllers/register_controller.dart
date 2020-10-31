import 'dart:async';

import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import 'controller.dart';

class RegController extends Controller {
  User user = new User();
  bool hidePassword = true, hidePassword2 = true;
  bool loading = false;
  GlobalKey<FormState> regFormKey;
  GlobalKey<FormState> locationFormKey;
  GlobalKey<FormState> personalFormKey;
  OverlayEntry loader;

  Address address = new Address();
  bool isRegMobileExistedReg = false;

  List<Province> provinces = [];
  List<District> districts = [];
  List<Ward> wards = [];

  int otpExpInSeconds = 300;
  int get otpSecond => otpExpInSeconds % 60;
  int get otpMin => otpExpInSeconds ~/ 60;

  RegController() {
    regFormKey = GlobalKey<FormState>();
    locationFormKey = GlobalKey<FormState>();
    personalFormKey = GlobalKey<FormState>();
    this.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  String OTP;
  Timer _timer;
  void register() async {
    if (loading) return;
    print('Start registering');
    FocusScope.of(context).unfocus();
    loading = true;
    regFormKey.currentState.save();
    if (regFormKey.currentState.validate()) {
//      Overlay.of(context).insert(loader);
      OTP = await userRepo.register(user);
      startTimerResendOtp();
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

  void startTimerResendOtp() {
    this.otpExpInSeconds = 300;
    if(_timer != null) _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => this.otpExpInSeconds--);
      if(this.otpExpInSeconds <= 0) timer.cancel();
    });
  }

  Future<User> verifyOtp() async {
    if (loading) return currentUser.value;
    loading = true;
    User u = await userRepo.verifyOtp(user.phone, OTP);
    if(u.isValid) currentUser.value = u;
    loading = false;
    return u;
  }

  void resendOtp() async {
    if (loading) return;
    loading = true;
    try {
      OTP = await userRepo.resendOtp(user.phone);
      if(OTP != null) startTimerResendOtp();
    } finally {
      loading = false;
    }
    loading = false;
    if(OTP != null) {
      showMsg(S.of(context).resendOtpSuccess);
    } else {
      showMsg(S.of(context).generalErrorMessage);
    }
  }

  void getProvinces() async {
    if(loading) return;
    setState(() {
      loading = true;
    });

    this.provinces = await userRepo.getProvinces();

    setState(() {
      loading = false;
    });
  }

  void getDistricts(int provinceId) async {
    if(loading) return;
    setState(() {
      loading = true;
    });

    List<District> dis = await userRepo.getDistricts(provinceId);

    setState(() {
      this.districts = dis;
      loading = false;
    });

  }

  void getWards(int districtId) async {
    if(loading) return;
    setState(() {
      loading = true;
    });

    List<Ward> dis = await userRepo.getWards(districtId);

    setState(() {
      this.wards = dis;
      loading = false;
    });

  }

  Future<bool> addAddress() async {
    if (loading) return false;
    try {
      loading = true;
      List a = await userRepo.addAddress(address);
      loading = false;
      if (a != null) {
        showMsg(S.of(context).newAddressAdded);
        return true;
      } else {
        showMsg(S.of(context).generalErrorMessage);
      }
    } on Exception catch (e, trace) {
      loading = false;
      print("$e $trace");
      showMsg(S.of(context).generalErrorMessage);
    }
    return false;
  }

  Future<bool> updateUser() async {
    if (loading) return false;
    User re;
    try {
      loading = true;
      re = await userRepo.update(user);
      loading = false;
      if (re != null) {
        showMsg(S.of(context).accountInfoUpdated);
        this.user = re;
        return true;
      } else {
        showErrGeneral();
      }
    } on Exception catch (e, trace) {
      loading = false;
      print("$e $trace");
      showErrGeneral();
    }
    return false;
  }
}
