import '../../utils.dart';
import 'i_name.dart';

class Faq extends IdObj{
  String question;
  String answer;

  Faq();

  Faq.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      question = jsonMap['question'] != null ? jsonMap['question'] : '';
      answer = jsonMap['answer'] != null ? jsonMap['answer'] : '';
    } catch (e, trace) {
      id = -1;
      question = '';
      answer = '';
      print('Error parsing data in Faq $e \n $trace');

    }
  }
}
