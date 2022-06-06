import 'package:dmart/src/models/i_name.dart';

import '../../utils.dart';

class RadioItem extends IdObj {
  static int? ONE_TIME = 1;
  static int? REPEAT = 2;
  DateTime? startTime, endTime;
  String? mediaUrl;
  int? duration;

  ///1: onetime, 2: repeat
  int? type;
  RadioItem({this.endTime, this.mediaUrl, this.duration, this.type});
  RadioItem.fromJSON(Map<String, dynamic> map) {
    if (map == null) return;
    try {
      id = toInt(map['id']);
      mediaUrl = map["media"] ?? '';
      mediaUrl = mediaUrl!.replaceFirst("http://", "https://");

      startTime = toDateTime(map["start_time"]);
      endTime = toDateTime(map["end_time"]);
      duration = toInt(map["duration"]);
      type = toInt(map["type"]);
    } catch (e, trace) {
      print('Error parsing data in RadioItem $e \n $trace');
    }
  }

  @override
  String toString() {
    return "RadioItem{ id: $id, isRepeat: ${isRepeat()}, mediaUrl: $mediaUrl, startTime: $startTime , endTime: $endTime }";
  }

  bool isRepeat() {
    return type == REPEAT;
  }
}
