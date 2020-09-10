//import 'package:location/location.dart';

import 'package:dmart/src/models/i_name.dart';

import '../../generated/l10n.dart';
import '../../utils.dart';

class Address extends IdObj{
  String description;
  String address;
  double latitude;
  double longitude;
  bool isDefault;
  int userId;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      description = jsonMap['description'] != null ? jsonMap['description'].toString() : null;
      address = jsonMap['address'] != null ? jsonMap['address'] : 'S.of(context).unknown';
      latitude = jsonMap['latitude'] != null ? jsonMap['latitude'] : null;
      longitude = jsonMap['longitude'] != null ? jsonMap['longitude'] : null;
      isDefault = jsonMap['is_default'] ?? false;
    } catch (e, trace) {
      id = -1;
      description = '';
      address = 'S.current.unknown';
      latitude = null;
      longitude = null;
      isDefault = false;
      print('Error parsing data in Address $e \n $trace');
    }
  }

  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
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
