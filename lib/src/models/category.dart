import 'dart:core';

import 'package:dmart/src/models/i_name.dart';
import 'package:dmart/utils.dart';

import '../models/media.dart';

class Category extends SimpleObj{
  String description;
  bool selected=false;

  Category({int id, String name = '', this.description=''}) : super(id: id, name: name);

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      name = toStringVal(jsonMap['name']);
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      description=toStringVal(jsonMap['description']);
    } catch (e, trace) {
      id = -1;
      name = '';
      image = new Media();
      description = '';
      print('Error parsing data in Category $e \n $trace');

    }
  }
}





