import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dmart/src/models/order_setting.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
//import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../helpers/custom_trace.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/setting.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<Address> deliveryAddress = new ValueNotifier(new Address());
final navigatorKey = GlobalKey<NavigatorState>();
LocationData locationData;


Future<Setting> initSettings() async {
  Setting _setting;
  final String url = '${GlobalConfiguration().getString('api_base_url')}settings';
  print('initSettings $url');
  final response = await http.get(url, headers: createHeadersRepo());
//  print('response.body ${response.body}');
  if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
    if (json.decode(response.body)['data'] != null) {




      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('settings', json.encode(json.decode(response.body)['data']));
      _setting = Setting.fromJSON(json.decode(response.body)['data']);
      print('language from share = [${prefs.get('language')}]');
      if (prefs.containsKey('language')) {
        _setting.mobileLanguage = new ValueNotifier(Locale(prefs.get('language'), ''));
      }
      setting.value = _setting;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      setting.notifyListeners();
    }
  } else {
    print(CustomTrace(StackTrace.current, message: response.body).toString());
  }
//  try {
//
//  } catch (e, trace) {
//    print(CustomTrace(StackTrace.current, message: e).toString());
//    return Setting.fromJSON({});
//  }
  return setting.value;
}

Future<OrderSetting> listenOrderSetting() async {
  //vouchers/check?code=quI3mJB5mT
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}order_settings';
  print(url);

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  print(result);
  if(result['success'] == true) {
    return OrderSetting.fromJSON(result['data']);
  } else {
    return null;
  }
}

Future<dynamic> setCurrentLocation() async {
  var location = new Location();
  MapsUtil mapsUtil = new MapsUtil();
  final whenDone = new Completer();
  Address _address = Address.fromJSON({'address': 'S.current.unknown'});
  location.requestService().then((value) async {
    location.getLocation().then((_locationData) async {
      String _addressName = await mapsUtil.getAddressName(new LatLng(_locationData?.latitude, _locationData?.longitude), setting.value.googleMapsKey);
      _address = Address.fromJSON({'address': _addressName, 'latitude': _locationData?.latitude, 'longitude': _locationData?.longitude});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('delivery_address', json.encode(_address.toMap()));
      whenDone.complete(_address);
    }).timeout(Duration(seconds: 10), onTimeout: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('delivery_address', json.encode(_address.toMap()));
      whenDone.complete(_address);
      return null;
    }).catchError((e) {
      whenDone.complete(_address);
    });
  });
  return whenDone.future;
}

Future<Address> changeCurrentLocation(Address _address) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('delivery_address', json.encode(_address.toMap()));
  return _address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('delivery_address')) {
    deliveryAddress.value = Address.fromJSON(json.decode(prefs.getString('delivery_address')));
    return deliveryAddress.value;
  } else {
    deliveryAddress.value = Address.fromJSON({});
    return Address.fromJSON({});
  }
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness == Brightness.dark ? prefs.setBool("isDark", true) : prefs.setBool("isDark", false);
}

Future<void> setDefaultLanguage(String language) async {
  if (language != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = await prefs.get('language');
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  if (messageId != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('google.message_id');
}
