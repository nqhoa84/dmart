import 'dart:io';

import 'package:dmart/constant.dart';
import 'package:dmart/src/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import './src/repository/user_repository.dart' as userRepo;
import 'package:url_launcher/url_launcher.dart' as launcher;


/// Parse a object to double. if error return the [errorValue] data.
double toDouble(var obj, {double errorValue = -1}) {
  if(obj == null)
    return errorValue;
  if(obj is num) return obj.toDouble();
  double v = double.tryParse(obj.toString());
  return v??errorValue;
}

DateTime toDateTime (var obj, {String format = 'yyyy-MM-dd HH:mm:ss',  DateTime errorValue}) {
  if(obj == null) return null;
  if(obj is DateTime) return obj;
  try {
    return DateFormat(format).parse(obj.toString());
  } catch (e) {
    return null;
  }
}

String toDateStr(DateTime date){
  if(date == null) return '';

  return DmConst.dateFormatter.format(date);
}

String toDateTimeStr(DateTime dateTime){
  if(dateTime == null) return '';

  return DmConst.datetimeFormatter.format(dateTime);
}

/// Parse a object to int. if error return the [errorValue] data.
int toInt(var obj, {int errorValue = -1}) {
  if(obj == null)
    return errorValue;
  if(obj is num) return obj.toInt();

  int v = int.tryParse(obj.toString());
  return v??errorValue;
}

/// Parse a object to String. if error return the [errorValue] data.
String toStringVal(var obj, {String errorValue = ''}) {
  if(obj == null)
    return errorValue;
  return obj.toString();
}



  Map<String, String> createHeaders(User u) {
    Map<String, String> header = Map();
    //HttpHeaders.contentTypeHeader: 'application/json'
    header[HttpHeaders.contentTypeHeader] = 'application/json';
    header['Authorization'] = 'Bearer ${u.apiToken}';
//    header['device-token'] = AppState.udid;
//    header['device-type'] = Platform.isIOS ? 'iOS' : 'Android';
    return header;
  }

Map<String, String> createHeadersRepo() {
  return createHeaders(userRepo.currentUser.value);
}

String getDisplayMoney(double value) {
  return '\$ ${value != null ? value.toStringAsFixed(2) : '0.00'}';
}


class DmUtils {
  static bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return em != null && regExp.hasMatch(em);
  }

  static isNotEmail(String value) {
    return !isEmail(value);
  }

  static bool isPhone(String value) {
    String pattern = r'^(?:[+0][0-9])?[ 0-9]{8,15}[0-9]$';
    RegExp regExp = new RegExp(pattern);

    return regExp.hasMatch(value.trim());
//    ^ beginning of a string
//      (?:[+0][1-9])? optionally match a + or 0 followed by a digit from 0 to 9
//    [ 0-9]{10,12} match 10 to 12 digits
//    $ end of the string
  }

  static String addCountryCode({@required String phone, String code = '855'}) {
    String _phone;
    if(phone == null) {
      _phone = '';
    } else {
      _phone = phone.replaceAll(RegExp(r"[^0-9]"), '');
      while(_phone.startsWith('0')) {
        _phone = _phone.substring(1);
      }
      if(!_phone.startsWith(code)) {
        _phone = '$code$_phone';
      }
    }
    return _phone;
  }

  static isNotPhoneNo(String value) {
    return !isPhone(value);
  }


  static bool isNullOrEmptyStr(String value) {
    return value == null || value.trim().isEmpty;
  }

  static bool isNotNullEmptyStr(String value) {
    return !isNullOrEmptyStr(value);
  }



  static bool isNullOrEmptyList(List value) {
    return value == null || value.isEmpty;
  }

  static bool isNotNullEmptyList(List value) {
    return ! isNullOrEmptyList(value);
  }


  static bool isNullOrEmptyMap(Map value) {
    return value == null || value.isEmpty;
  }

  static Future<bool> launchUrl(
      {@required String webUrl, String deepLinkAn, String deepLinkIos}) async {
    String deep = Platform.isIOS ? deepLinkIos : deepLinkAn;
    try {
      bool ok = await launcher.launch(deep, forceSafariVC: false);
      if (!ok) {
        if (await launcher.canLaunch(webUrl)) {
          return await launcher.launch(webUrl, forceSafariVC: false);
        } else {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}