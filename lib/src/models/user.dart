import 'package:dmart/constant.dart';
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
  String fbAvatar;

  String get phone {
    if(_phone == null) return '';
    if(_phone.startsWith("855")) {
      return _phone.replaceFirst('855', '0');
    }
    return _phone;
  }

  String get phoneWith855 {
    return _phone;
  }

  String get fullNameWithTitle {
    if(gender == null || gender == Gender.Others) {
      return name;
    }
    if(gender == Gender.Female) {
      return "Mrs $name";
    }
    return "Mr $name";
  }

  set phone(String value) {
    _phone = DmUtils.addCountryCode(phone: value);
//    if(value == null) {
//      _phone = '';
//    } else {
//      _phone = value.replaceAll(RegExp(r"[^0-9]"), '');
//      while(_phone.startsWith('0')) {
//        _phone = _phone.substring(1);
//      }
//      if(!_phone.startsWith('855')) {
//        _phone = '855$_phone';
//      }
//    }
  }

  String address;
  List<Address> addresses = [];
  String bio;
  Media image;

  String get avatarUrl {

    if(DmUtils.isNotNullEmptyStr(fbAvatar)) {
      return fbAvatar;
    }
    if(image != null && image.thumb != null) {
      return image.thumb;
    }
    return 'http://dmartdev2.khmermedia.xyz/images/image_default.png';
  }

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
      if(jsonMap.containsKey('fb_avatar')) {
        fbAvatar = toStringVal(jsonMap['fb_avatar']);
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
    map["phone"] = _phone??'';
    map["name"] = name??'';
    map["password"] = password;
    // map["device_token"] = deviceToken??'';
    map["device_token"] = '${DmConst.deviceToken}';
    map["address"] = address;
    map["gender"] = gender != null?  gender.index: Gender.Others.index;
    map["birthday"] = birthday != null? toDateStr(birthday) : '';
    map["media"] = [image?.toMap()];
    return map;
  }

  Map toMapUpdateInfo() {
    var map = new Map<String, dynamic>();
    map["id"] = id.toString();
//    map["phone"] = phone??'';
    map["gender"] = gender != null?  gender.index: Gender.Others.index;
    map["name"] = name??'';
    map["birthday"] = birthday != null? toDateStr(birthday) : '';
    map["email"] = email??'';
    map["device_token"] = DmConst.deviceToken??'';
    return map;
  }

  Map toMap4SharePreference() {
    var map = new Map<String, dynamic>();
    map["id"] = id.toString();
    map["email"] = email??'';
    map["phone"] = _phone??'';
    map["name"] = name??'';
    map["password"] = password;
    map["gender"] = gender != null?  gender.index: Gender.Others.index;
    map["birthday"] = birthday != null? toDateTimeStr(birthday) : '';
    map["media"] = [image?.toMap()];
    map["token"] = apiToken;
    map["facebook_id"] = facebookId;
    map["fb_avatar"] = fbAvatar;

    return map;
  }

  Map toMapReg() {
    var map = new Map<String, dynamic>();
    map["phone"] = _phone??'';
    map["name"] = DmUtils.isNotNullEmptyStr(name)? name : phone;
    map["password"] = password;
    map["device_token"] = DmConst.deviceToken??'';
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
