import '../../utils.dart';
import 'i_name.dart';

//{"default_tax":"10","delivery_fee":"1","service_fee":"1"}
class OrderSetting extends IdObj {
  OrderSetting();
  double vatTaxPercent = 0.1, deliveryFee = 1.5, serviceFeePercent = 0.01;
  double serviceFeeMin = 0, serviceFeeMax=100;

  OrderSetting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
//      id = toInt(jsonMap['id']);
      vatTaxPercent = toDouble(jsonMap['default_tax'], errorValue: 0.1);
      deliveryFee = toDouble(jsonMap['delivery_fee'], errorValue: 1.5);
      serviceFeePercent = toDouble(jsonMap['service_fee'], errorValue: 0.01);

    } catch (e, trace) {
      vatTaxPercent = 0.1;
      deliveryFee = 1.5;
      serviceFeePercent = 0.01;
      print('Error parsing data in Order.fromJSON $e \n $trace');
    }
  }

  @override
  String toString() {
    return 'OrderSetting {id: $id, vatTaxPercent: $vatTaxPercent, deliverFee: $deliveryFee, serviceFeePercent: $serviceFeePercent}';
  }
}
