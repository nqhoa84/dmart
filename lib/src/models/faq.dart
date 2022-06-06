import 'package:dmart/DmState.dart';

import '../../utils.dart';
import 'i_name.dart';

class Faq extends IdObj {
  String questionEn = '';
  String questionKh = '';
  String answerEn = '';
  String answerKh = '';

  String get question => DmState.isKhmer ? questionKh : questionEn;
  String get answer => DmState.isKhmer ? answerKh : answerEn;

  Faq(this.answerKh, this.answerEn, this.questionKh, this.questionEn);

  Faq.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      questionEn = toStringVal(jsonMap['question_en']);
      questionKh = toStringVal(jsonMap['question_kh']);
      answerEn = toStringVal(jsonMap['answer_en']);
      answerKh = toStringVal(jsonMap['answer_kh']);
    } catch (e, trace) {
      id = -1;
      questionEn = '';
      questionKh = '';
      answerEn = '';
      answerKh = '';
      print('Error parsing data in Faq $e \n $trace');
    }
  }
}
