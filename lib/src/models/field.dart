import 'package:dmart/utils.dart';

import '../models/media.dart';
import 'i_name.dart';

class Field extends IdNameObj {
  String? description = '';
  Media? image;
  bool? selected;

  Field(
    this.description,
    this.image,
    this.selected,
  );

  Field.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name']);
      nameKh = nameEn;
      description = jsonMap['description'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      selected = jsonMap['selected'] ?? false;
    } catch (e, trace) {
      id = -1;
      nameEn = '';
      nameKh = nameEn;
      description = '';
      image = new Media();
      selected = false;
      print('Error parsing data in Field $e \n $trace');
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = id;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
