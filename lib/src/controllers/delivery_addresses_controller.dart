import 'package:dmart/src/controllers/controller.dart';
import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/i_name.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class DeliveryAddressesController extends Controller //    with ChangeNotifier
{
  late GlobalKey<FormState> formKey;
  late GlobalKey<ScaffoldState> scaffoldKey;

  List<Address>? addresses;
  Address? address;

  static List<Province>? PROVINCES;

  List<Province> get provinces => PROVINCES ?? [];
  static Map<int, List<District>> _mapDistricts = {};
  List<District>? districts = [];
  static Map<int, List<Ward>> _mapWards = {};
  List<Ward>? wards = [];

  DeliveryAddressesController(
      {this.address, this.addresses, this.wards, this.districts}) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.formKey = GlobalKey<FormState>();
  }

  void listenForAddresses({String? message}) async {
    if (this.addresses == null) {
      this.addresses = [];
    } else {
      this.addresses!.clear();
    }
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses!.add(_address);
      });
    }, onError: (a) {
      print(a);
      showErr(S.current.verifyYourInternetConnection);
    }, onDone: () {
      showMsg(message!);
    });
  }

  Future<void> refreshAddresses() async {
    addresses!.clear();
    listenForAddresses(message: S.current.addressesRefreshedSuccessfully);
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
//        content: Text(S.current.newAddressAdded),
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
      addresses!.clear();
      listenForAddresses(message: S.current.addressUpdated);
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses!.remove(address);
      });
      showMsg(S.current.deliveryAddressRemovedSuccessfully);
    });
  }

  void getProvinces() async {
    return;
    if (loading) return;
    setState(() {
      loading = true;
    });

    PROVINCES = await userRepo.getProvinces();

    setState(() {
      loading = false;
    });
    setState(() {});
  }

  void getDistricts(int provinceId) async {
    if (_mapDistricts.containsKey(provinceId)) {
      districts = _mapDistricts[provinceId];
      return;
    }
    if (loading) return;
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
    if (_mapWards.containsKey(districtId)) {
      this.wards = _mapWards[districtId];
      return;
    }
    if (loading) return;
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
    if (loading) return false;

    bool re = false;

    this.formKey.currentState!.save();
    if (this.formKey.currentState!.validate()) {
      setLoadingOn();
      if (this.address!.id <= 0) {
        var apiRe = await userRepo.addAddress(this.address!);
        if (apiRe.isSuccess!) {
          setState(() {
            apiRe.data?.sort(IdObj.idComparerDescending);
            this.address = apiRe.data?.first;
            this.addresses = apiRe.data ?? [];
          });
          showMsg(S.current.newAddressAdded);
        } else {
          showMsg(apiRe.message!);
        }
        re = apiRe.isSuccess!;
      } else {
        var apiRe = await userRepo.updateAddress(this.address!);
        if (apiRe.isSuccess!) {
          showMsg(S.current.addressUpdated);
        } else {
          showMsg(apiRe.message!);
        }
        re = apiRe.isSuccess!;
      }
      setLoadingOff();
    }
    return re;
  }
}
