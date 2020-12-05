import '../../utils.dart';
import 'i_name.dart';

class OptionGroup extends IdNameObj {

  OptionGroup();

  OptionGroup.fromJSON(Map<String, dynamic> jsonMap) {
    if(jsonMap == null) return;
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name']);
      this.nameKh = nameEn;
    } catch (e, trace) {
      id = -1;
      nameEn = '';
      this.nameKh = nameEn;
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
