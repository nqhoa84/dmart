import 'dart:core';

import '../../utils.dart';
import '../models/media.dart';
import 'i_name.dart';

class ProductType extends IdNameObj {
  String description;

  ProductType();

  ProductType.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      name = jsonMap['name'] ?? '';
      description=jsonMap['description'] ?? '';
    } catch (e, trace) {
      id = -1;
      name = '';
      description = '';
      print('Error parsing data in ProductType.fromJSON $e \n $trace');

    }
  }
}

enum SortBy { priceAcs, priceDesc, nameAsc, nameDesc}





