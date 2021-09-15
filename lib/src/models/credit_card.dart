import 'package:dmart/src/models/i_name.dart';

import '../../utils.dart';

class CreditCard extends IdObj {
  String number = '';
  String expMonth = '';
  String expYear = '';
  String cvc = '';

  CreditCard();

  CreditCard.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      number = jsonMap['stripe_number'].toString();
      expMonth = jsonMap['stripe_exp_month'].toString();
      expYear = jsonMap['stripe_exp_year'].toString();
      cvc = jsonMap['stripe_cvc'].toString();
    } catch (e, trace) {
      id = -1;
      number = '';
      expMonth = '';
      expYear = '';
      cvc = '';
      print('Error parsing data in CreditCard $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["stripe_number"] = number;
    map["stripe_exp_month"] = expMonth;
    map["stripe_exp_year"] = expYear;
    map["stripe_cvc"] = cvc;
    return map;
  }

  bool validated() {
    return number != null && number != '' && expMonth != null && expMonth != '' && expYear != null && expYear != '' && cvc != null && cvc != '';
  }
}
