import 'package:dmart/src/models/i_name.dart';
import 'package:dmart/utils.dart';

import '../models/media.dart';

class Unit extends IdNameObj{
  String description;
  bool selected=false;

  Unit();

  Unit.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name_en']);
      nameKh = toStringVal(jsonMap['name_kh']);
    } catch (e, trace) {
      id = -1;
      name = '';
      print('Error parsing data in Brand $e \n $trace');
    }
  }

  @override
  String toString() {
    return name;
  }
}
