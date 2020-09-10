import 'package:dmart/utils.dart';

import '../../src/models/media.dart';
import 'i_name.dart';

class Promotion extends SimpleObj{
  String description;

  Promotion();

  Promotion.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      name = toStringVal(jsonMap['name']);
      description=toStringVal(jsonMap['description']);
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e, trace) {
      id = -1;
      name = '';
      description = '';
      image = new Media();
      print('Error parsing data in Promotion.fromJSON $e \n $trace');

    }
  }
}

