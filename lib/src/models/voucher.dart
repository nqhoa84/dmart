import 'package:dmart/utils.dart';

import '../../src/models/media.dart';
import 'i_name.dart';

class Voucher extends IdNameObj{
  String code;
  int type;
  double maxDiscount;
  double minOrderValue;
  ///Được áp dụng nếu [value] is invalid (null or <=0). Lúc này điều kiện [maxDiscount] sẽ được áp dụng.
  double percent;

  ///Giảm chính xác số tiền [value]. Không quan tâm tới điều kiện [maxDiscount] và [percent].
  double value;
  String description;

  ///Format: yyyy-MM-dd HH:mm:ss, example: 2020-02-28 01:01:01
  DateTime from, to;

  Voucher();

  /*
   "id": 3,
        "name": "Covid-19",
        "code": "wK7vV5uOgc",
        "type": 1,
        "value": 1,
        "max_discount": null,
        "min_order_value": 20,
        "start_date": "2020-09-14 00:00:00",
        "end_date": "2020-12-13 00:00:00",
        "description": "",
        "status": 1,
        "order_id": null,
        "deleted_at": null,
        "created_at": "2020-09-14 15:20:42",
        "updated_at": "2020-09-14 15:20:42"
   */
  Voucher.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name']);
      this.nameKh = nameEn;
      description=toStringVal(jsonMap['description']);
      type = toInt(jsonMap['type']);
      code=toStringVal(jsonMap['code']);
      maxDiscount = toDouble(jsonMap['max_discount'], errorValue: null);
      minOrderValue = toDouble(jsonMap['min_order_value'], errorValue: null);
      value = toDouble(jsonMap['value'], errorValue: 0);
      from = toDateTime(jsonMap['from'], format: 'yyyy-MM-dd HH:mm:ss');
      to = toDateTime(jsonMap['to'], format: 'yyyy-MM-dd HH:mm:ss');
    } catch (e, trace) {
      id = -1;
      print('Error parsing data in Voucher.fromJSON $e \n $trace');
    }
  }

  bool get isFixedDiscount => type == 1;

  @override
  bool get isValid => super.isValid && (type == 1 || type == 2);

  @override
  String toString() {
    return 'Voucher {id:$id, code:$code, type:$type, value:$value, minOrderVal:$minOrderValue, maxDiscount:$maxDiscount}';
  }
}

