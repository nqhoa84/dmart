import 'package:dmart/constant.dart';
import 'package:dmart/utils.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../src/models/media.dart';
import 'i_name.dart';


/*
{
            "id": 2,
            "delivery_date": "2020-09-15 00:00:00",
            "note": null,
            "slot_1": true,
            "slot_2": true,
            "slot_3": false,
            "slot_4": true,
            "slot_5": false,
            "slot_6": true,
            "created_at": "2020-09-14 08:44:14",
            "updated_at": "2020-09-14 08:44:25",
            "custom_fields": []
        }
 */
class DateSlot extends IdObj{
  DateTime deliveryDate;
  String description;
  bool is1slotOK, is2slotOK, is3slotOK, is4slotOK,is5slotOK,is6slotOK;

  DateSlot() {
    deliveryDate = DateTime.now();
    is1slotOK = false;
    is2slotOK = false;
    is3slotOK = false;
    is4slotOK = false;
    is5slotOK = false;
    is6slotOK = false;
  }

  bool disableCurrentNextSlots() {
    var now = DateTime.now();
    if(now.year == deliveryDate.year
        && now.month == deliveryDate.month
        && now.day == deliveryDate.day) {
      if(now.hour == 6 || now.hour == 7) {
        this.is1slotOK = false;
      } else if(now.hour == 8 || now.hour == 9) {
        this.is1slotOK = false;
        this.is2slotOK = false;
      } else if(now.hour == 10 || now.hour == 11) {
        this.is1slotOK = false;
        this.is2slotOK = false;
        this.is3slotOK = false;
      } else if(now.hour == 12 || now.hour == 13) {
        this.is1slotOK = false;
        this.is2slotOK = false;
        this.is3slotOK = false;
        this.is4slotOK = false;
      } else if(now.hour == 14 || now.hour == 15) {
        this.is1slotOK = false;
        this.is2slotOK = false;
        this.is3slotOK = false;
        this.is4slotOK = false;
        this.is5slotOK = false;
      } else if(now.hour >= 16) {
        this.is1slotOK = false;
        this.is2slotOK = false;
        this.is3slotOK = false;
        this.is4slotOK = false;
        this.is5slotOK = false;
        this.is6slotOK = false;
      }
    }
  }


  DateSlot.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      deliveryDate = toDateTime(jsonMap['delivery_date'],
          format: DmConst.dateTimeFormat,
          errorValue: null);
      if(deliveryDate == null) {
        deliveryDate = toDateTime(jsonMap['delivery_date'],
            format: DmConst.dateFormat,
            errorValue: null);
      }
      description=toStringVal(jsonMap['description']);
      is1slotOK = jsonMap['slot_1'] ?? true;
      is2slotOK = jsonMap['slot_2'] ?? true;
      is3slotOK = jsonMap['slot_3'] ?? true;
      is4slotOK = jsonMap['slot_4'] ?? true;
      is5slotOK = jsonMap['slot_5'] ?? true;
      is6slotOK = jsonMap['slot_6'] ?? true;

    } catch (e, trace) {
      id = -1;
      print('Error parsing data in DateSlot.fromJSON $e \n $trace');
    }
  }

  @override
  String toString() {
    return 'DateSlot {id: $id, deliveryDate: $deliveryDate, $is1slotOK-$is2slotOK-$is3slotOK-$is4slotOK-$is5slotOK-$is6slotOK }';
  }
}

