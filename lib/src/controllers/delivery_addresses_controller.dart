import 'package:dmart/src/controllers/controller.dart';
import 'package:dmart/src/models/address.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends Controller
//    with ChangeNotifier
{
  GlobalKey<FormState> formKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  List<Address> addresses;
  Address address;

  static List<Province> PROVINCES;
  List<Province> get provinces => PROVINCES??[];
  static Map<int, List<District>> _mapDistricts = {};
  List<District> districts = [];
  static Map<int, List<Ward>> _mapWards = {};
  List<Ward> wards = [];

  DeliveryAddressesController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
    formKey = GlobalKey<FormState>();
  }

  void listenForAddresses({String message}) async {
    if(this.addresses == null) {
      this.addresses = [];
    } else {
      this.addresses.clear();
    }
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      print(a);
      showErr(S.of(context).verifyYourInternetConnection);
    }, onDone: () {
      if (message != null) {
        showMsg(message);
      }
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses(message: S.of(context).addressesRefreshedSuccessfully);
  }

  Future<void> changeDeliveryAddress(model.Address address) async {
    await settingRepo.changeCurrentLocation(address);
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

//  Future<void> changeDeliveryAddressToCurrentLocation() async {
//    model.Address _address = await settingRepo.setCurrentLocation();
//    setState(() {
//      settingRepo.deliveryAddress.value = _address;
//    });
//    settingRepo.deliveryAddress.notifyListeners();
//  }

//  void addAddress(model.Address address) {
//    userRepo.addAddress(address).then((value) {
//      setState(() {
//        this.addresses.insert(0, value);
//      });
//      scaffoldKey?.currentState?.showSnackBar(SnackBar(
//        content: Text(S.of(context).newAddressAdded),
//      ));
//    });
//  }

  void chooseDeliveryAddress(model.Address address) {
    setState(() {
      settingRepo.deliveryAddress.value = address;
    });
    settingRepo.deliveryAddress.notifyListeners();
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {});
      addresses.clear();
      listenForAddresses(message: S.of(context).addressUpdated);
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      showMsg(S.of(context).deliveryAddressRemovedSuccessfully);
    });
  }

  void getProvinces() async {
    if(PROVINCES != null) return;
    if(loading) return;
    setState(() {
      loading = true;
    });

    PROVINCES = await userRepo.getProvinces();

    setState(() {
      loading = false;
    });
    setState((){});
  }

  void getDistricts(int provinceId) async {
    if(_mapDistricts.containsKey(provinceId)) {
      districts = _mapDistricts[provinceId];
      return;
    }
    if(loading) return;
    setState(() {
      loading = true;
    });

    List<District> dis = await userRepo.getDistricts(provinceId);
    _mapDistricts[provinceId] = dis;

    setState(() {
      this.districts = dis;
      loading = false;
    });

  }

  void getWards(int districtId) async {
    if(_mapWards.containsKey(districtId)) {
      this.wards = _mapWards[districtId];
      return;
    }
    if(loading) return;
    setState(() {
      loading = true;
    });

    List<Ward> ws = await userRepo.getWards(districtId);
    _mapWards[districtId] = ws;
    setState(() {
      this.wards = ws;
      loading = false;
    });

  }

  Future<bool> saveAddress() async {
    bool re = false;
    this.formKey.currentState.save();
    if(this.formKey.currentState.validate()) {
//      if(loading) return false;
      setState(() {
        loading = true;
      });
      if(this.address.id <= 0) {
        List<Address> a = await userRepo.addAddress(this.address);
        if(a != null) {
          setState(() { this.addresses = a;});
          re = true;
        }
        showMsg(S.of(context).newAddressAdded);
      } else {
        List<Address> a = await userRepo.updateAddress(this.address);

        showMsg(S.of(context).addressUpdated);
      }

      setState(() {
        loading = false;
      });
    }

    return re;
  }
}
