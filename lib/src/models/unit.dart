import 'package:dmart/src/models/i_name.dart';
import 'package:dmart/utils.dart';

import '../models/media.dart';

class Unit extends IdNameObj{
  String description;

  Unit();

  Unit.fromJSON(Map<String, dynamic> jsonMap) {
    if(jsonMap == null) return;
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name_en']);
      nameKh = toStringVal(jsonMap['name_kh']);
    } catch (e, trace) {
      id = -1;
      name = '';
      print('Error parsing data in Unit $e \n $trace');
    }
  }

  @override
  String toString() {
    return name;
  }
}

class ProductType extends IdNameObj{
  String description;
  ProductType();

  ProductType.fromJSON(Map<String, dynamic> jsonMap) {
    if(jsonMap == null) return;
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name_en']);
      nameKh = toStringVal(jsonMap['name_kh']);
    } catch (e, trace) {
      id = -1;
      name = '';
      print('Error parsing data in ProductType $e \n $trace');
    }
  }

  @override
  String toString() {
    return name;
  }
}

