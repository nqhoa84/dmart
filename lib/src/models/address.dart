//import 'package:location/location.dart';

import 'package:dmart/src/models/i_name.dart';

import '../../generated/l10n.dart';
import '../../utils.dart';

class Address extends IdObj {
  String fullName, phoneNumber;
  String province, district, ward, street, address = 'A215, duong C8, f Tay thanh, Q. tan phu ';
  String description;

//  String address; //fullAddress
  double latitude;
  double longitude;
  bool isDefault;
  int userId;

  Address();

  Address.fromJSON(Map<String, dynamic> map) {
    try {
      id = toInt(map['id']);
      fullName = map["full_name"] ?? 'n q h ';
      phoneNumber = map["phone_number"] ?? '0988848066';
      province = map["province"] ?? 'quang nam';
      district = map["district"] ?? 'tam ky';
      ward = map["ward"] ?? 'tam thai';
      street = map["street"] ?? 'c8';
      address = map["address"] ?? 'addr';
      description = map["description"] ?? 'desc';
      latitude = toDouble(map["latitude"], errorValue: null);
      longitude = toDouble(map["longitude"], errorValue: null);
      isDefault = map["isDefault"] ?? false;
    } catch (e, trace) {
      id = -1;
      province = '';
      district = '';
      ward = '';
      street = '';
      address = '';
      description = '';
      isDefault = false;
      print('Error parsing data in Address $e \n $trace');
    }
  }

  String get getFullAddress => '${address??''}'
      '${isNullOrEmpty(street) ? '' : ', $street'}'
      '${isNullOrEmpty(ward) ? '' : ', $ward'}'
      '${isNullOrEmpty(district) ? '' : ', $district'}'
      '${isNullOrEmpty(province) ? '' : ', $province'}'
      '${isNullOrEmpty(description) ? '' : ', \n$description'}'
  ;

  bool isNullOrEmpty(String str) {
    return str == null || str.trim().length == 0;
  }
  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["province"] = province;
    map["district"] = district;
    map["ward"] = ward;
    map["street"] = street;
    map["address"] = address;
    map["description"] = description;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["isDefault"] = isDefault;
    return map;
  }

//  LocationData toLocationData() {
//    return LocationData.fromMap({
//      "latitude": latitude,
//      "longitude": longitude,
//    });
//  }
}
