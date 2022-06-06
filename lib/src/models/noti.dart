//import 'package:location/location.dart';

import 'dart:convert';

import 'package:dmart/src/models/i_name.dart';

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
  DateTime? dateTime = DateTime.now();
  String? title = '';
  String? body;
  String? image, icon;
  NotiType type = NotiType.broadcast;
  dynamic objectId;
  Noti({this.title, this.body, this.icon, this.objectId});
  // {image: http://dmart24.khmermedia.xyz/logo.png, object_type: Product, icon: http://dmart24.khmermedia.xyz/logo.png,
  // body: 333333333333333333, type: NOTIFY, title: បេះដូងម៉ែពិត, click_action: FLUTTER_NOTIFICATION_CLICK, object_id: 0}

  /// {sound: default, id: 89, type: CHANGE_STATUS_ORDER, click_action: FLUTTER_NOTIFICATION_CLICK,
  /// message: {"image":"http:\/\/dmartdev2.khmermedia.xyz\/storage\/157\/conversions\/burger-bun-500x500-thumb.jpg",
  /// "text":"Your order #89 has change status to Canceled","type":"ORDER","title":"Your order #89 is Canceled",
  /// "body":"Your order #89 has change status to Canceled","order_id":89,"status":4}, order_id: 89, status: 4}
  Noti.fromJSON(Map<String, dynamic> map) {
    if (map == null) return;
    id = toInt(map['id']);
    title = map["title"] ?? '';
    body = map["body"] ?? '';
    type = getType(map['object_type']);
    objectId = map['object_id'] ?? '';
    image = map['image'] ?? '';
    icon = map['icon'] ?? '';

    if (title == '' && body == '' && map['message'] != null) {
      var m = map['message'];
      if (m is String) {
        m = jsonDecode(m);
      }
      title = m["title"] ?? '';
      body = m["body"] ?? '';
      type = getType(m['type']);
      objectId = m['order_id'] ?? '';
      image = m['image'] ?? '';
    }

    dateTime = toDateTime(map['dateTime']);
  }

  bool read = false;

  get tapable =>
      ((type == NotiType.order ||
              type == NotiType.promotion ||
              type == NotiType.product ||
              type == NotiType.category) &&
          toInt(objectId) > 0) ||
      type == NotiType.bestSale ||
      type == NotiType.newArrival ||
      type == NotiType.special4U;

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["body"] = body;
    map["object_type"] = type.toString();
    map["object_id"] = objectId;
    map['image'] = image;
    map['icon'] = icon;
    map["dateTime"] = toDateTimeStr(dateTime!);
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
    if (other is Noti) {
      return toDateTimeStr(dateTime!) == toDateTimeStr(other.dateTime!);
    }
    return false;
  }

  NotiType getType(op) {
    if (op == null) return NotiType.broadcast;
    var re = NotiType.broadcast;
    NotiType.values.forEach((element) {
      // print('---${element.toString().toLowerCase()} --- ${op.toString().trim().toLowerCase()}');
      if (element
          .toString()
          .trim()
          .toLowerCase()
          .endsWith(op.toString().trim().toLowerCase())) {
        re = element;
      }
    });
    return re;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
