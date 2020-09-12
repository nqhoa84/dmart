import '../../utils.dart';
import 'i_name.dart';

//class OrderStatus extends IdObj{
//  String status;
//
//  OrderStatus({id, this.status}) : super(id: id);
//
//  OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
//    try {
//      id = toInt(jsonMap['id']);
//      status = jsonMap['status'] != null ? jsonMap['status'] : '';
//    } catch (e, trace) {
//      id = -1;
//      status = '';
//      print('Error parsing data in OrderStatus.fromJSON $e \n $trace');
//
//    }
//  }
//}
enum OrderStatus {
  Created, Approved, Denied, Canceled, Preparing, Delivering,
  //= (paid, completed)
  Delivered ,
  DeliverFailed,
  Rejected
}