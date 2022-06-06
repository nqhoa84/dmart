import 'dart:async';
import 'dart:convert';

import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/RadioItem.dart';
import 'package:dmart/src/models/order_setting.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/address.dart';
import '../models/setting.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<Address> deliveryAddress = new ValueNotifier(new Address());
final navigatorKey = GlobalKey<NavigatorState>();
//LocationData locationData;

///Load radio items for current time. Data store on DmState.currentRadio and DmState.nextRadio
Future<bool> loadCurrentRadio() async {
  try {
    var url =
        Uri.parse('${GlobalConfiguration().get('api_base_url')}broadcast');
    final response = await http.get(url);
    var re = json.decode(response.body);
    DmState.currentRadio = null;
    DmState.nextRadio = null;
    if (re['data'] != null) {
      if (re['data']['current'] != null) {
        DmState.currentRadio = RadioItem.fromJSON(re['data']['current']);
      }

      if (re['data']['next'] != null) {
        DmState.nextRadio = RadioItem.fromJSON(re['data']['next']);
      }
    }
    return true;
  } on Exception catch (e) {
    print(e);
  }
  return false;
}

///Read the local settings (language, radio) from SharedPreferences
Future<bool> initLocalSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('language from share = [${prefs.get('language')}]');
  if (prefs.containsKey('language')) {
    DmState.mobileLanguage.value = Locale(prefs.get('language') as dynamic, '');
//    DmState.mobileLanguage.notifyListeners();
  }

  if (prefs.containsKey('radio')) {
    DmState.isRadioOn = prefs.getBool('radio') ?? true;
//    DmState.mobileLanguage.notifyListeners();
  } else {
    DmState.isRadioOn = true;
  }
  return true;
}

Future<void> setDefaultLanguage(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', languageCode);

  DmState.mobileLanguage.value = Locale(languageCode, '');
}

Future<void> setRadioSetting({bool isSoundOn = true}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('radio', isSoundOn);
}

Future<OrderSetting?> listenOrderSetting() async {
  //vouchers/check?code=quI3mJB5mT
  var url = Uri.parse(
      '${GlobalConfiguration().getString('api_base_url')}order_settings');
  print(url);

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  print(result);
  if (result['success'] == true) {
    return OrderSetting.fromJSON(result['data']);
  } else {
    return null;
  }
}

Future<Address> changeCurrentLocation(Address _address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('delivery_address', json.encode(_address.toMap()));
  return _address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('delivery_address')) {
    deliveryAddress.value = Address.fromJSON(
        json.decode(prefs.getString('delivery_address') as dynamic));
    return deliveryAddress.value;
  } else {
    deliveryAddress.value = Address();
    return Address();
  }
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness == Brightness.dark
      ? prefs.setBool("isDark", true)
      : prefs.setBool("isDark", false);
}

Future<void> saveMessageId(String messageId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('google.message_id', messageId);
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.get('google.message_id') as dynamic;
}
