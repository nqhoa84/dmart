import '../../utils.dart';
import 'i_name.dart';

class Notification extends IdObj{
  String type;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification({id='', this.type='', this.read=false}) : super(id: id);

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      data = jsonMap['data'] != null ? {} : {};
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = DateTime.parse(jsonMap['created_at']);
    } catch (e, trace) {
      id = -1;
      type = '';
      data = {};
      read = false;
      createdAt = new DateTime(0);
      print('Error parsing data in Notification $e \n $trace');
    }
  }
}
