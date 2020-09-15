//import 'package:location/location.dart';

import 'package:dmart/src/models/i_name.dart';

import '../../generated/l10n.dart';
import '../../utils.dart';

class Address extends IdObj {
  String fullName, phone;
  String province, district, ward, street, address = 'A215, duong C8, f Tay thanh, Q. tan phu ';
  String description;

//  String address; //fullAddress
  double latitude;
  double longitude;
  bool isDefault;
  int userId;

  Address();
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
      province = map["province"] ?? '';
      district = map["district"] ?? '';
      ward = map["ward"] ?? '';
      street = map["street"] ?? '';
      phone = map["phone"] ?? '';
      fullName = map["full_name"] ?? '';
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
