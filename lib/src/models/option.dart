import '../../utils.dart';
import '../models/media.dart';
import 'i_name.dart';

class Option extends IdObj{
  String optionGroupId;
  String name;
  double price;
  Media image;
  String description;
  bool checked;

  Option();

  Option.fromJSON(Map<String, dynamic> jsonMap) {
    if(jsonMap == null) return;
    try {
      id = toInt(jsonMap['id']);
      optionGroupId = jsonMap['option_group_id'] != null ? jsonMap['option_group_id'].toString() : '0';
      name = jsonMap['name'].toString();
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0;
      description = jsonMap['description'];
      checked = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e, trace) {
      id = -1;
      optionGroupId = '0';
      name = '';
      price = 0.0;
      description = '';
      checked = false;
      image = new Media();
      print('Error parsing data in Option.fromJSON $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
