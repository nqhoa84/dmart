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

  Gender gender;

  DateTime birthday;

  int point;

  String facebookId;

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
      int i = toInt(jsonMap['gender']);
      gender = i >=0 && i <= 2 ? Gender.values[i] : null;
      birthday = toDateTime(jsonMap['birthday'], errorValue: null);
      credit = toDouble(jsonMap['credit'], errorValue: 0);
      point = toInt(jsonMap['point'], errorValue: 0);
      phone = toStringVal(jsonMap['phone']);
      email = toStringVal(jsonMap['email']);
      facebookId = toStringVal(jsonMap['facebook_id']);
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
    map["gender"] = gender != null?  gender.index: Gender.Others.index;
    map["birthday"] = birthday != null? toDateStr(birthday) : '';
//    map["bio"] = bio;
    map["media"] = [image?.toMap()];
    return map;
  }

  Map toMap4SharePreference() {
    var map = new Map<String, dynamic>();
    map["id"] = id.toString();
    map["email"] = email??'';
    map["phone"] = phone??'';
    map["name"] = name??'';
    map["password"] = password;
    map["address"] = address;
    map["bio"] = bio;
    map["token"] = apiToken;
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

enum Gender {Female, Male, Others}
