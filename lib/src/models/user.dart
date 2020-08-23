import '../models/media.dart';

class User {
  String id;
  String name;
  String email;
  String password;
//  String apiToken = 'acmdOkB9kdh0SuFaopN7TYoSWCCTlihqU9INjumwqGjdDgbUGY88zOhG6Xkm';
  String apiToken;
  String deviceToken;
  String phone;
  String address;
  String bio;
  Media image;

  /// used for indicate if client logged in or not
  bool get isLogin => this.apiToken != null && this.apiToken.length > 10;

  double credit = 0;

//  String role;

  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'] : '';
      email = jsonMap['email'] != null ? jsonMap['email'] : '';
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      try {
        phone = jsonMap['custom_fields']['phone']['view'];
      } catch (e) {
        phone = "";
      }
      try {
        address = jsonMap['custom_fields']['address']['view'];
      } catch (e) {
        address = "";
      }
      try {
        bio = jsonMap['custom_fields']['bio']['view'];
      } catch (e) {
        bio = "";
      }
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone"] = phone;
    map["address"] = address;
    map["bio"] = bio;
    map["media"] = image?.toMap();
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
