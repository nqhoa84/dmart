//import 'package:location/location.dart';

import 'package:dmart/src/models/i_name.dart';

import '../../utils.dart';

class Address extends IdObj {
  String? fullName = '';
  String? street = '';
  String? address = '';
  String? description = '';
  Province? province;
  District? district;
  Ward? ward;
  double? latitude;
  double? longitude;
  bool? isDefault;
  int? userId;
  String? districtName;
  String? wardName;
  String _phone = '';

  Address({
    id,
    phone,
    this.fullName,
    this.street,
    this.address,
    this.description,
    this.province,
    this.district,
    this.ward,
    this.latitude,
    this.longitude,
    this.isDefault = false,
    this.userId = 0,
    this.districtName,
    this.wardName,
  }) : super(id: id);

  set phone(String v) => _phone = DmUtils.addCountryCode(phone: v);

  String get phone {
    if (_phone.startsWith("855")) {
      return _phone.replaceFirst('855', '0');
    }
    return _phone;
  }

  Address clone() {
    Address a = Address();
    a.id = this.id;
    a.address = this.address;
    a.fullName = this.fullName;
    a.phone = this.phone;
    a.street = this.street;
    a.description = this.description;
    a.isDefault = this.isDefault;
    a.userId = this.userId;
    a.province = this.province!.clone();
    a.wardName = this.wardName;
    a.districtName = this.districtName;
    // a.district = this.district!= null ? this.district.clone() : null;
    // a.ward = this.ward!= null ? this.ward.clone() : null;
    return a;
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
    if (map == null) return;
    try {
      id = toInt(map['id']);
      description = map["description"] ?? '';
      address = map["address"] ?? '';
      try {
        province = Province.fromJSON(map["province"]);
        districtName = map['district'];
        wardName = map['ward'];
      } on Exception {
        // district = District();
      }

      street = toStringVal(map["street"]);
      phone = map["phone"] ?? '';
      fullName = map["full_name"] ?? '';
      latitude = toDouble(map["latitude"]);
      longitude = toDouble(map["longitude"]);
      isDefault = map["is_default"] ?? false;
    } catch (e, trace) {
      print('Error parsing data in Address $e \n $trace');
    }
  }

  String get getFullAddress => '${address ?? ''}'
      '${isNullOrEmpty(street!) ? '' : ', $street'}'
      '${wardName == null ? '' : ', $wardName'}'
      '${districtName == null ? '' : ', $districtName'}'
      '${province == null ? '' : ', ${province!.name}.'}'
      '${isNullOrEmpty(description!) ? '' : '\n$description'}';

  bool isNullOrEmpty(String str) {
    return str.trim().length == 0;
  }

  bool isUnknown() {
    return longitude == null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["province_id"] = province!.id;
    map["district_id"] = district != null ? district!.id : 0;
    map["district"] = districtName ?? "";
    map["ward_id"] = ward != null ? ward!.id : 0;
    map["ward"] = this.wardName ?? '';
    map["street"] = street ?? '';
    map["address"] = address ?? '';
    map["full_name"] = this.fullName ?? '';
    map["phone"] = _phone ?? '';
    map["description"] = description ?? '';
    map["is_default"] = isDefault ?? false;
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

class Province extends IdNameObj {
  String? description;

  Province({
    this.description,
  });

  Province.fromJSON(Map<String, dynamic> jsonMap) {
    if (jsonMap == null) return;
    id = toInt(jsonMap['id']);
    nameEn = toStringVal(jsonMap['name_en']);
    nameKh = toStringVal(jsonMap['name_kh']);
  }

  Province clone() {
    Province p = Province();
    p.id = this.id;
    p.nameEn = this.nameEn;
    p.nameKh = this.nameKh;
    p.description = this.description;
    return p;
  }
}

class District extends IdNameObj {
  String? description;
  int? provinceId;

  District({
    this.description,
    this.provinceId,
  });

  District.fromJSON(Map<String, dynamic> jsonMap) {
    if (jsonMap == null) return;
    id = toInt(jsonMap['id']);
    nameEn = toStringVal(jsonMap['name_en']);
    nameKh = toStringVal(jsonMap['name_kh']);
    provinceId = toInt(jsonMap['province_id']);
  }

  District clone() {
    District p = District();
    p.id = this.id;
    p.nameEn = this.nameEn;
    p.nameKh = this.nameKh;
    p.description = this.description;
    return p;
  }
}

class Ward extends IdNameObj {
  String? description;
  int? districtId;

  Ward({this.description, this.districtId});

  Ward.fromJSON(Map<String, dynamic> jsonMap) {
    if (jsonMap == null) return;
    id = toInt(jsonMap['id']);
    nameEn = toStringVal(jsonMap['name_en']);
    nameKh = toStringVal(jsonMap['name_kh']);
    districtId = toInt(jsonMap['district_id']);
  }

  Ward clone() {
    Ward p = Ward();
    p.id = this.id;
    p.nameEn = this.nameEn;
    p.nameKh = this.nameKh;
    p.description = this.description;
    return p;
  }
}
