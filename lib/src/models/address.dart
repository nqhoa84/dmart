//import 'package:location/location.dart';

import 'package:dmart/src/models/i_name.dart';

import '../../generated/l10n.dart';
import '../../utils.dart';

class Address extends IdObj {
  String fullName = '', phone = '';
  String street = '', address = 'A215, duong C8, f Tay thanh, Q. tan phu ';
  String description = '';
  IdNameObj province , district, ward;

//  String address; //fullAddress
  double latitude;
  double longitude;
  bool isDefault = false;
  int userId = 0;

  Address() {
    id = 0;
  }
/*{
            "id": 16,
            "description": "test address 1",
            "address": "01 ABC, Ward 1, Dist 1, Phnomphenh",
            "province_id": 1,
            "district_id": 1,
            "ward_id": 1,
            "street": "01 ABC",
            "phone": "8550987654321",
            "latitude": 1234.32432,
            "longitude": 211.12321,
            "is_default": true,
            "user_id": 1,
            "created_at": "2020-09-14 08:27:11",
            "updated_at": "2020-09-14 08:27:11",
            "custom_fields": []
        },
 */
  Address.fromJSON(Map<String, dynamic> map) {
    try {
      id = toInt(map['id']);
      description = map["description"] ?? '';
      address = map["address"] ?? '';
      try {
        province = Province.fromJSON(map["province"]);
      } on Exception catch (e) {
        province = Province();
      }
      try {
        district = District.fromJSON(map["district"]);
      } on Exception catch (e) {
        district = District();
      }
      try {
        ward = Ward.fromJSON(map["ward"]);
      } on Exception catch (e) {
        ward = Ward();
      }
      street = toStringVal(map["street"]);
      phone = map["phone"] ?? '';
      fullName = map["full_name"] ?? '';
      latitude = toDouble(map["latitude"], errorValue: null);
      longitude = toDouble(map["longitude"], errorValue: null);
      isDefault = map["isDefault"] ?? false;
    } catch (e, trace) {
      print('Error parsing data in Address $e \n $trace');
    }
  }

  String get getFullAddress => '${address??''}'
      '${isNullOrEmpty(street) ? '' : ', $street'}'
      '${ward == null ? '' : ', ${ward.name}'}'
      '${district == null ? '' : ', ${district.name}'}'
      '${province == null ? '' : ', ${province.name}'}'
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
    map["province_id"] = province.id;
    map["district_id"] = district.id;
    map["ward_id"] = ward.id;
    map["street"] = street??'';
    map["address"] = address??'';
    map["full_name"] = this.fullName??'';
    map["phone"] = phone??'';
    map["description"] = description??'';
    map["is_default"] = isDefault??false;
    map["user_id"] = userId;

    return map;
  }

//  LocationData toLocationData() {
//    return LocationData.fromMap({
//      "latitude": latitude,
//      "longitude": longitude,
//    });
//  }
}

class Province extends IdNameObj{
  String description;

  Province();

  Province.fromJSON(Map<String, dynamic> jsonMap) {
    id = toInt(jsonMap['id']);
    nameEn = toStringVal(jsonMap['name']);
    nameKh = nameEn;
  }
}

class District extends IdNameObj{
  String description;
  int provinceId;

  District();

  District.fromJSON(Map<String, dynamic> jsonMap) {
    id = toInt(jsonMap['id']);
    nameEn = toStringVal(jsonMap['name']);
    nameKh = nameEn;
    provinceId = toInt(jsonMap['province_id']);
  }
}

class Ward extends IdNameObj{
  String description;
  int districtId;

  Ward();

  Ward.fromJSON(Map<String, dynamic> jsonMap) {
    id = toInt(jsonMap['id']);
    nameEn = toStringVal(jsonMap['name']);
    nameKh = nameEn;
    districtId = toInt(jsonMap['district_id']);
  }
}
