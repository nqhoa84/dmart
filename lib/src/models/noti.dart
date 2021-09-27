//import 'package:location/location.dart';

import 'package:dmart/src/models/i_name.dart';

import '../../generated/l10n.dart';
import '../../utils.dart';

enum NotiType {
  order, // to order detail page
  promotion, // goto products of this promotion id
  bestSale, //no need object id >> go to bestsale page
  newArrival, // no need object id >> go to new arrival page
  special4U, //no need object id >> go to special4U page
  product, //to product detail page

  category, // to category detail page

  broadcast //just broadcast
}

class Noti extends IdObj {
  Noti() {
    this.dateTime = DateTime.now();
  }

  DateTime dateTime;
  String title = '';
  String body;
  String image, icon;
  NotiType type = NotiType.broadcast;
  dynamic objectId;

  // {image: http://dmart24.khmermedia.xyz/logo.png, object_type: Product, icon: http://dmart24.khmermedia.xyz/logo.png,
  // body: 333333333333333333, type: NOTIFY, title: បេះដូងម៉ែពិត, click_action: FLUTTER_NOTIFICATION_CLICK, object_id: 0}
  Noti.fromJSON(Map<String, dynamic> map) {
    if(map == null) return;
    id = toInt(map['id']);
    title = map["title"] ?? '';
    body = map["body"] ?? '';
    type = getType(map['object_type']);
    objectId = map['object_id'] ?? '';
    image = map['image'] ?? '';
    icon = map['icon'] ?? '';

    dateTime = toDateTime(map['dateTime'], errorValue: DateTime.now());
  }

  bool read = false;

  get tapable => ((type == NotiType.order || type == NotiType.promotion || type == NotiType.product || type == NotiType.category) && toInt(objectId) > 0)
  || type == NotiType.bestSale || type == NotiType.newArrival || type==NotiType.special4U;

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["body"] = body;
    map["object_type"] = type.toString();
    map["object_id"] = objectId;
    map['image'] = image;
    map['icon'] = icon;
    map["dateTime"] = toDateTimeStr(dateTime);
    return map;
  }

  Map toMap() {
    return toJson();
  }
  @override
  String toString() {
   return 'Noti {id: $id, title:$title, body:$body, type:$type, data:$objectId, date: $dateTime}';
  }

  @override
  bool operator ==(other) {
    if(other is Noti) {
      return toDateTimeStr(dateTime) == toDateTimeStr(other.dateTime);
    }
    return false;
  }

  NotiType getType(op) {
    if(op == null) return NotiType.broadcast;
    var re = NotiType.broadcast;
    NotiType.values.forEach((element) {
      // print('---${element.toString().toLowerCase()} --- ${op.toString().trim().toLowerCase()}');
      if(element.toString().trim().toLowerCase().endsWith(op.toString().trim().toLowerCase())) {
        re = element;
      }
    });
    return re;
  }
}
