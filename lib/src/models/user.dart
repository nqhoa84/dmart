import 'package:dmart/src/models/address.dart';

import '../../utils.dart';
import '../models/media.dart';
import 'i_name.dart';

class User extends IdNameObj{
  String email;
  String password;
  String apiToken;
  String deviceToken;
  String _phone;
  String get phone => _phone;
  set phone(String value) {
    if(value == null) {
      _phone = '';
    } else {
      _phone = value.replaceAll(RegExp(r"[^0-9]"), '');
      while(_phone.startsWith('0')) {
        _phone = _phone.substring(1);
      }
      if(!_phone.startsWith('855')) {
        _phone = '855$_phone';
      }
    }
  }

  String address;
  List<Address> addresses = [];
  String bio;
  Media image;

  /// Used for indicate if client logged in or not. This is the token value returned from BD
  bool get isLogin => this.apiToken != null && this.apiToken.length > 10;
  bool get isNotLogin => isLogin == false;

  double credit = 0;

//  String role;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name']);
      this.nameKh = nameEn;
      email = toStringVal(jsonMap['email']);
      apiToken = toStringVal(jsonMap['token']);
      deviceToken = toStringVal(jsonMap['device_token']);
      try {
        phone = toStringVal(jsonMap['custom_fields']['phone']['view']);
      } catch (e, trace) {
        phone = "";
      }
      try {
        address = toStringVal(jsonMap['custom_fields']['address']['view']);
      } catch (e, trace) {
        address = "";
      }
      try {
        bio = toStringVal(jsonMap['custom_fields']['bio']['view']);
      } catch (e, trace) {
        bio = "";
      }
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e, trace) {
      print('Error parsing data in User.fromJSON $e \n $trace');
    }
  }


  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id.toString();
    map["email"] = email??'';
    map["phone"] = phone??'';
    map["name"] = name??'';
    map["password"] = password;
    map["device_token"] = deviceToken??'';
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = [image?.toMap()];
    return map;
  }

  Map toMapReg() {
    var map = new Map<String, dynamic>();
    map["phone"] = phone??'';
    map["name"] = DmUtils.isNotNullEmptyStr(name)? name : phone;
    map["password"] = password;
    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    return map.toString();
  }
  bool profileCompleted() {
    return address != null && address != '' && phone != null && phone != '';
  }
}
