import '../../utils.dart';
import '../models/address.dart';
import '../models/order_status.dart';
import '../models/payment.dart';
import '../models/product_order.dart';
import '../models/user.dart';
import 'i_name.dart';

class Order extends IdObj {
  List<ProductOrder> productOrders;
  OrderStatus orderStatus = OrderStatus.Created; //create = post, cancel = put
  double tax;
  double deliveryFee, serviceFee;
  String hint;
  DateTime expectedDeliverDate;
  int expectedDeliverSlotTime;
  DateTime updatedAt;
  Address deliveryAddress;
//  DateTime dateTime; //??
  User user;
//  Payment payment;


  Order({int id, this.orderStatus}) : super(id: id);

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      tax = toDouble(jsonMap['tax'], errorValue: 0);
      deliveryFee = toDouble(jsonMap['delivery_fee'], errorValue: 0);
      serviceFee = toDouble(jsonMap['service_fee'], errorValue: 0);
      hint = jsonMap['hint']??'';
      expectedDeliverDate = DateTime.tryParse(jsonMap['expectedDeliverDate'])??DateTime.now();
      expectedDeliverSlotTime = toInt(jsonMap['expectedDeliverSlotTime']);
      updatedAt = DateTime.tryParse(jsonMap['updated_at'])??DateTime.now();
      deliveryAddress =
          jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : new Address();
      productOrders = jsonMap['product_orders'] != null
          ? List.from(jsonMap['product_orders']).map((element) => ProductOrder.fromJSON(element)).toList()
          : [];
    } catch (e, trace) {
      id = -1;
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      deliveryAddress = new Address();
      productOrders = [];
      print('Error parsing data in Order.fromJSON $e \n $trace');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
//    map["user_id"] = user?.id;
//    map["order_status_id"] = orderStatus?.id;
    map["tax"] = tax;
    map["delivery_fee"] = deliveryFee;
    map["products"] = productOrders.map((element) => element.toMap()).toList();
//    map["payment"] = payment?.toMap();
    map["delivery_address"] = deliveryAddress.toMap();
    return map;
  }
}
