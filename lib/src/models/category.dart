import 'dart:core';

import 'package:dmart/src/models/i_name.dart';
import 'package:dmart/utils.dart';

import '../models/media.dart';

class Category extends NameImageObj {
  String description = '';
  bool? selected = false;

//  Category({int id, String name = '', this.description=''}) : super(id: id, name: name);

  Category({
    required this.description,
    this.selected,
  }) {
    this.id = -1;
  }

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    if (jsonMap == null) return;
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name_en']);
      nameKh = toStringVal(jsonMap['name_kh']);
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      description = toStringVal(jsonMap['description']);
    } catch (e, trace) {
      id = -1;
      nameEn = '';
      image = new Media();
      description = '';
      print('Error parsing data in Category $e \n $trace');
    }
  }

  @override
  String toString() {
    return 'Cate {id: $id, name: $name}';
  }
}
