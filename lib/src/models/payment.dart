import '../../utils.dart';
import 'i_name.dart';

class Payment extends IdObj{
  String status;
  String method;

  Payment.init();

  Payment(this.method);

  Payment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      status = jsonMap['status'] ?? '';
      method = jsonMap['method'] ?? '';
    } catch (e, trace) {
      id = -1;
      status = '';
      method = '';
      print('Error parsing data in Payment.fromJSON $e \n $trace');

    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'method': method,
    };
  }
}
