import '../../utils.dart';
import '../models/option.dart';
import '../models/product.dart';
import 'i_name.dart';

class Favorite extends IdObj{
  Product product;
  List<Option> options;
  int userId;

  Favorite();

  Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      product = jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : new Product();
      options = jsonMap['options'] != null
          ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList()
          : null;
    } catch (e, trace) {
      id = -1;
      product = new Product();
      options = [];
      print('Error parsing data in Favorite $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["product_id"] = product.id;
    map["user_id"] = userId;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
