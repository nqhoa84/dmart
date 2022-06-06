import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/api_result.dart';
import 'package:dmart/src/repository/user_repository.dart';

import '../../generated/l10n.dart';
import '../models/i_name.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;
import 'controller.dart';

class RegController extends Controller {
  User? user = new User();
  bool? hidePassword = true, hidePassword2 = true;
  bool loading = false;
  GlobalKey<FormState>? regFormKey;
  GlobalKey<FormState>? locationFormKey;
  GlobalKey<FormState>? personalFormKey;
  OverlayEntry? loader;

  Address? address = new Address();
  bool? isRegMobileExistedReg = false;

  List<Province>? provinces = [];
  List<District>? districts = [];
  List<Ward>? wards = [];

  int otpExpInSeconds = 300;
  int get otpSecond => otpExpInSeconds % 60;
  int get otpMin => otpExpInSeconds ~/ 60;

  RegController({
    this.hidePassword,
    this.regFormKey,
    this.locationFormKey,
    this.personalFormKey,
    this.loader,
    this.isRegMobileExistedReg,
    this.provinces,
    this.districts,
    this.wards,
  }) {
    regFormKey = GlobalKey<FormState>();
    locationFormKey = GlobalKey<FormState>();
    personalFormKey = GlobalKey<FormState>();
    this.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  String? OTP;
  Timer? _timer;
  void register() async {
    if (loading) return;
    print('Start registering');
    // FocusScope.of(context).unfocus();
    loading = true;
    regFormKey!.currentState!.save();
    if (regFormKey!.currentState!.validate()) {
//      Overlay.of(context).insert(loader);
      OTP = await userRepo.register(user!);
      startTimerResendOtp();
//      repository.register(user).then((value) {
//        if (DmUtils.isNotNullEmptyStr(value)) { //register ok
//          OTP = value;
//        } else {
//          OTP = '';
//          scaffoldKey.currentState.showSnackBar(SnackBar(
//            content: Text(S.current.registerError),
//          ));
//        }
//      }).catchError((e) {
//        loader.remove();
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(S.current.registerError),
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
    _timer!.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => this.otpExpInSeconds--);
      if (this.otpExpInSeconds <= 0) {
        setState(() => this.OTP = '');
        timer.cancel();
      }
    });
  }

//   Future<User?> verifyOtpRegFb() async {
// //    if (loading) return currentUser.value;
// //    setState(()=>loading = true);
// //    //TODO check here
// //    User u = await userRepo.verifyOtpToCompleteRegFb(user.phone, OTP);
// //    if(u.isValid) currentUser.value = u;
// //    setState(()=>loading = false);
// //    return u;
//   }

  Future<User> verifyOtp() async {
    if (loading) return currentUser.value;
    setState(() => loading = true);
    User? u = await userRepo.verifyOtp(user!.phone, OTP!);
    if (u!.isValid) currentUser.value = u;
    setState(() => loading = false);
    return u;
  }

  void resendOtp() async {
    if (loading) return;
    loading = true;
    try {
      OTP = await userRepo.resendOtp(user!.phone);
      startTimerResendOtp();
    } finally {
      loading = false;
    }
    loading = false;
    if (OTP != null) {
      showMsg(S.current.resendOtpSuccess);
    } else {
      showMsg(S.current.generalErrorMessage);
    }
  }

  void getProvinces() async {
    if (loading) return;
    setState(() {
      loading = true;
    });

    this.provinces = await userRepo.getProvinces();

    setState(() {
      loading = false;
    });
  }

  void getDistricts(int provinceId) async {
    if (loading) return;
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
    if (loading) return;
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
    setLoadingOn();
    try {
      var re = await userRepo.addAddress(address!);
      if (re.isSuccess!) {
        re.data!.sort(IdObj.idComparerDescending);
        if (re.data!.isNotEmpty) {
          this.address = re.data!.first;
        }
        showMsg(S.current.newAddressAdded);
      }
      setLoadingOff();
      return re.isSuccess!;
    } catch (e, trace) {
      print("$e $trace");
      showMsg(S.current.generalErrorMessage);
    } finally {
      setLoadingOff();
    }
    return false;
  }

  Future<bool> updateUser() async {
    if (loading) return false;
    // User re;
    try {
      loading = true;
      var re = await userRepo.update(user!);
      loading = false;
      if (re.isSuccess!) {
        showMsg(S.current.accountInfoUpdated);
        this.user = re.data;
        return true;
      } else {
        // showErrGeneral();
        showMsg(re.message!);
      }
    } on Exception catch (e, trace) {
      loading = false;
      print("$e $trace");
      showErrGeneral();
    }
    return false;
  }

  Future<void> sendOtpFb() async {
    if (loading) return;
    setState(() => loading = true);

    regFormKey!.currentState!.save();
    if (regFormKey!.currentState!.validate()) {
//      Overlay.of(context).insert(loader);
      ApiResult re = await userRepo.registerFb(user!);
      if (re.isSuccess == true) {}

      startTimerResendOtp();
//      repository.register(user).then((value) {
//        if (DmUtils.isNotNullEmptyStr(value)) { //register ok
//          OTP = value;
//        } else {
//          OTP = '';
//          scaffoldKey.currentState.showSnackBar(SnackBar(
//            content: Text(S.current.registerError),
//          ));
//        }
//      }).catchError((e) {
//        loader.remove();
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text(S.current.registerError),
//        ));
//      }).whenComplete(() {
//        loading = false;
//        Helper.hideLoader(loader);
//      });
    }
    setState(() => loading = false);
  }
}
