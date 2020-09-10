import '../../utils.dart';
import '../models/media.dart';
import 'i_name.dart';

class Store extends IdNameObj{
  Media image;
  String rate;
  String description;
  String phone;
  String mobile;
  String information;
  double deliveryFee;
  double adminCommission;
  double defaultTax;
  bool closed;
  bool availableForDelivery;
  double deliveryRange;
  double distance;

  Store();

  Store.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      name = toStringVal(jsonMap['name']);
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
//      rate = jsonMap['rate'] ?? '0';
//      deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
//      adminCommission = jsonMap['admin_commission'] != null ? jsonMap['admin_commission'].toDouble() : 0.0;
//      deliveryRange = jsonMap['delivery_range'] != null ? jsonMap['delivery_range'].toDouble() : 0.0;
//      description = jsonMap['description'];
//      phone = jsonMap['phone'];
//      mobile = jsonMap['mobile'];
//      defaultTax = jsonMap['default_tax'] != null ? jsonMap['default_tax'].toDouble() : 0.0;
//      information = jsonMap['information'];
//      closed = jsonMap['closed'] ?? false;
//      availableForDelivery = jsonMap['available_for_delivery'] ?? false;
//      distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
    } catch (e, trace) {
      id = -1;
      name = '';
      image = new Media();
      rate = '0';
      deliveryFee = 0.0;
      adminCommission = 0.0;
      deliveryRange = 0.0;
      description = '';
      phone = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      closed = false;
      availableForDelivery = false;
      distance = 0.0;
      print('Error parsing data in Store.fromJSON $e \n $trace');

    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }
}
