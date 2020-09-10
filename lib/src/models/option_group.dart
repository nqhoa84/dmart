import '../../utils.dart';
import 'i_name.dart';

class OptionGroup extends IdNameObj {

  OptionGroup();

  OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      name = toStringVal(jsonMap['name']);
    } catch (e, trace) {
      id = -1;
      name = '';
      print('Error parsing data in OptionGroup.fromJSON $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
