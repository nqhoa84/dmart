import '../../utils.dart';
import '../models/store.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'i_name.dart';

class Review extends IdObj{
  String review;
  String rate;
  User user;

  Review();
  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    if(jsonMap == null) return;
    try {
      id = toInt(jsonMap['id']);
      review = jsonMap['review'];
      rate = jsonMap['rate'].toString() ?? '0';
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    } catch (e, trace) {
      id = -1;
      review = '';
      rate = '0';
      user = new User();
      print('Error parsing data in Review.fromJSON $e \n $trace');

    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofStoreToMap(Store store) {
    var map = this.toMap();
    map["store_id"] = store.id;
    return map;
  }

  Map ofProductToMap(Product product) {
    var map = this.toMap();
    map["product_id"] = product.id;
    return map;
  }
}
