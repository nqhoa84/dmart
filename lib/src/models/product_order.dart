import '../../utils.dart';
import '../models/option.dart';
import '../models/product.dart';
import 'i_name.dart';

class ProductOrder extends IdObj {
  double paidPrice;
  double quantity;

//  List<Option> options;
  Product product;

  ProductOrder();

  @override
  bool get isValid {
    return super.isValid && product != null && product.id > 0 && quantity >= 0 && paidPrice >= 0;
  }

  ProductOrder.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      paidPrice = toDouble(jsonMap['price'], errorValue: 0);
      quantity = toDouble(jsonMap['quantity'], errorValue: 0);
      product = Product.fromJSON(jsonMap['product']);
//      dateTime = DateTime.parse(jsonMap['updated_at']);
//      options = jsonMap['options'] != null
//          ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList()
//          : null;
    } catch (e, trace) {
      id = -1;
      paidPrice = 0.0;
      quantity = 0.0;
      product = new Product();
      print('Error parsing data in ProductOrder.fromJSON $e \n $trace');
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["price"] = paidPrice;
    map["quantity"] = quantity;
    map["product_id"] = product.id;
//    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
