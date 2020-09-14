import 'dart:io';

import 'package:dmart/src/models/user.dart';
import 'package:intl/intl.dart';
import './src/repository/user_repository.dart' as userRepo;


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