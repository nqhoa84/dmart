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
  created, approved, denied, canceled, preparing,
  delivering,
  //= (paid, completed)
  delivered ,
  deliverFailed,
  rejected, confirmed,
  unknown
}