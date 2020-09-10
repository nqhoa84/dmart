import 'package:dmart/utils.dart';
import 'package:global_configuration/global_configuration.dart';

import 'i_name.dart';

class Media extends IdNameObj{
  String url;
  String thumb;
  String icon;
  String size;


  Media() {
    url = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
    thumb = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
    icon = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
  }

  Media.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      name = toStringVal(jsonMap['name']);
      url = toStringVal(jsonMap['url']);
      thumb = toStringVal(jsonMap['thumb']);
      icon = toStringVal(jsonMap['icon']);
      size = toStringVal(jsonMap['formated_size']);
    } catch (e, trace) {
      url = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
      thumb = "${GlobalConfiguration().getString('base_url')}images/image_default.png";
      icon = "${GlobalConfiguration().getString('base_url')}images/image_default.png";

      print('Error parsing data in Media $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["thumb"] = thumb;
    map["icon"] = icon;
    map["formated_size"] = size;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
