import '../../src/models/media.dart';

class Slider {
  String id;
  Media image;
  String description;

  Slider();

  Slider.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      description=jsonMap['description'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      description = '';
      image = new Media();
      print(e);
    }
  }
}

