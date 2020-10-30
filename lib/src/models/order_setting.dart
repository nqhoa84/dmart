import '../../utils.dart';
import 'i_name.dart';

//{"default_tax":"10","delivery_fee":"1","service_fee":"1"}
class OrderSetting extends IdObj {
  OrderSetting();
  double vatTaxPercent = 0.1, deliveryFee = 1.5, serviceFeePercent = 0.01;
  double serviceFeeMin = 0, serviceFeeMax=100000000;
  String phoneSmart = '', phoneCellcard = '', phoneMetfone = '';
  String socialWhatapp = '', socialWechat = '', socialViber = '', socialInstagram = '';
  String socialTelegram = '', socialFb = '', socialFbMess = '', socialLine = '';

  OrderSetting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
//      id = toInt(jsonMap['id']);
      vatTaxPercent = toDouble(jsonMap['default_tax'], errorValue: 0.1);
      deliveryFee = toDouble(jsonMap['delivery_fee'], errorValue: 1.5);
      serviceFeePercent = toDouble(jsonMap['service_fee'], errorValue: 0.01);

      phoneSmart = toStringVal(jsonMap['smart']);
      phoneCellcard = toStringVal(jsonMap['cellcard']);
      phoneMetfone = toStringVal(jsonMap['metfone']);

      socialWhatapp = toStringVal(jsonMap['whatsapp']);
      socialWechat = toStringVal(jsonMap['wechat']);
      socialViber = toStringVal(jsonMap['viber']);
      socialInstagram = toStringVal(jsonMap['instagram']);
      socialTelegram = toStringVal(jsonMap['telegram']);
      socialFb = toStringVal(jsonMap['facebook']);
      socialFbMess = toStringVal(jsonMap['fb_messenger']);
      socialLine = toStringVal(jsonMap['line']);

    } catch (e, trace) {
      print('Error parsing data in Order.fromJSON $e \n $trace');
    }
  }

  @override
  String toString() {
    return 'OrderSetting {id: $id, vatTaxPercent: $vatTaxPercent, deliverFee: $deliveryFee, serviceFeePercent: $serviceFeePercent}';
  }
}

/*
    "default_tax": "0.1",
        "delivery_fee": "1.5",
        "service_fee": "0.01",
        "smart": "+855 10 000 000",
        "cellcard": "+855 12 111 111",
        "metfone": "+855 97 979 7979",
        "facebook": "dmart24",
        "fb_messenger": "dmart24",
        "viber": "dmart24",
        "youtube": "https://youtube.com/dmart24",
        "instagram": "dmart24",
        "telegram": "dmart24",
        "twitter": "dmart24",
        "line": "dmart24",
        "tiktok": "dmart24",
        "whatsapp": "dmart24",
        "google": "dmart24@gmail.com",
        "email": "dmart24@gmail.com",
        "linkedin": "dmart24"
   */
