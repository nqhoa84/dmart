import '../../utils.dart';
import '../models/faq.dart';
import 'i_name.dart';

class FaqCategory extends IdNameObj{
  List<Faq> faqs;

  FaqCategory();

  FaqCategory.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      nameEn = toStringVal(jsonMap['name_en']);
      nameKh = toStringVal(jsonMap['name_kh']);

      faqs =
          jsonMap['faqs'] != null ? List.from(jsonMap['faqs']).map((element) => Faq.fromJSON(element)).toList() : null;
    } catch (e, trace) {
      id = -1;
      nameEn = ''; nameKh = '';
      faqs = [];
      print('Error parsing data in FaqCategory $e \n $trace');

    }
  }
}
