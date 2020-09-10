import 'package:dmart/utils.dart';

import '../models/option.dart';
import '../models/product.dart';
import 'i_name.dart';

class Cart extends IdObj{
  Product product;
  double quantity;
  List<Option> options;
  int userId;


  @override
  String toString(){
    return 'Cart {id: $id, productId: ${product.id}, quantity: $quantity, userId: $userId}';
  }

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      quantity = toDouble(jsonMap['quantity'], errorValue: 0);
      product = jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : new Product();
      userId = toInt(jsonMap['user_id']);
//      options = jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : [];
    }
    catch (e, trace) {
      id = -1;
      quantity = 0.0;
      product = new Product();
      options = [];
      print('Error parsing data in Cart $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["product_id"] = product.id;
    map["user_id"] = userId;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;
}
