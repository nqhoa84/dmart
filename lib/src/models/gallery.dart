import '../../utils.dart';
import '../models/media.dart';
import 'i_name.dart';

class Gallery extends IdObj {
  Media? image;
  String? description;

  Gallery({required this.image, required this.description});

  Gallery.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      description = jsonMap['description'];
    } catch (e, trace) {
      id = -1;
      image = new Media();
      description = '';
      print('Error parsing data in Gallery $e \n $trace');
    }
  }
}
