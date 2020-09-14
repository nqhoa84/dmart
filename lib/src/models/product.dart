import '../../utils.dart';
import '../models/category.dart';
import '../models/store.dart';
import '../models/media.dart';
import '../models/option.dart';
import '../models/option_group.dart';
import '../models/review.dart';
import '../models/brand.dart';
import 'i_name.dart';

class Product extends IdNameObj{
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String capacity;
  String unit;
  double packageItemsCount;
  String itemsAvailable;
  bool featured;
  bool deliverable;
  String rate;
  Brand brand;
  Store store;
  Category category;
  List<Option> options;
  List<Media> medias;
  List<OptionGroup> optionGroups;
  List<Review> productReviews;

  String currency = '\$';

  bool isSpecial4U = false;

  bool isNewArrival, isBestSale;
  double totalSale;

  Product();

  bool get isPromotion => discountPrice != null && discountPrice > 0 && discountPrice < price;

  @override
  bool get isValid {
    return
      super.isValid
      && image != null && image.thumb!= null && image.thumb.length > 10
      && price != null && price >= 0
        ;
  }

  Product.fromJSON(Map<String, dynamic> jsonMap) {
//    convert(jsonMap);
    try {
      convert(jsonMap);
//      checked = false;
    } catch (e, trace) {
      id = -1;
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      capacity = '';
      unit = '';
      packageItemsCount = 0;
      featured = false;
      deliverable = false;
      rate = '0';
      itemsAvailable = '0';
      brand = new Brand();
      category = new Category();
      store = new Store();
      image = new Media();
      options = [];
      optionGroups = [];
      productReviews = [];
      print('Error parsing data in Product.fromJSON $e \n $trace');
    }
  }

  ///get the smaller value of [promotion price and original price]
  num get paidPrice => isPromotion ? discountPrice : price;

  convert(Map<String, dynamic> jsonMap){
    id = toInt(jsonMap['id']);
    name = toStringVal(jsonMap['name']);
    price = toDouble(jsonMap['price'], errorValue: 0.0);
    discountPrice = toDouble(jsonMap['discount_price'], errorValue: null);
    description = jsonMap['description'] ?? '';
    capacity = toStringVal(jsonMap['capacity']);
    unit = toStringVal(jsonMap['unit']);
    packageItemsCount = toDouble(jsonMap['package_items_count'], errorValue: 0.0);
    featured = jsonMap['featured'] ?? false;
    deliverable = jsonMap['deliverable'] ?? false;
    isNewArrival = jsonMap['is_new_arrival'] ?? false;
    isBestSale = jsonMap['is_best_sale'] ?? false;
    totalSale = toDouble(jsonMap['total_sale'], errorValue: 0.0);
    rate = toStringVal(jsonMap['rate']);
    itemsAvailable = toStringVal(jsonMap['itemsAvailable']);
    brand = jsonMap['brand'] != null
        ? Brand.fromJSON(jsonMap['brand'])
        : new Brand();

//    store = jsonMap['store'] != null
//        ? Store.fromJSON(jsonMap['store'])
//        : new Store();

    category = jsonMap['category'] != null
        ? Category.fromJSON(jsonMap['category'])
        : new Category();

    medias = jsonMap['media'] != null &&
        (jsonMap['media'] as List).length > 0
        ? List.from(jsonMap['media'])
        .map((element) => Media.fromJSON(element)).toSet().toList()
        : [];
    image = medias != null && medias.length > 0 ? medias[0] : Media();

//    options =
//    jsonMap['options'] != null && (jsonMap['options'] as List).length > 0
//        ? List.from(jsonMap['options'])
//        .map((element) => Option.fromJSON(element))
//        .toSet()
//        .toList()
//        : [];

//    optionGroups = jsonMap['option_groups'] != null &&
//        (jsonMap['option_groups'] as List).length > 0
//        ? List.from(jsonMap['option_groups'])
//        .map((element) => OptionGroup.fromJSON(element))
//        .toSet()
//        .toList()
//        : [];

//    productReviews = jsonMap['product_reviews'] != null &&
//        (jsonMap['product_reviews'] as List).length > 0
//        ? List.from(jsonMap['product_reviews'])
//        .map((element) => Review.fromJSON(element))
//        .toSet()
//        .toList()
//        : [];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["discountPrice"] = discountPrice;
    map["description"] = description;
    map["capacity"] = capacity;
    map["package_items_count"] = packageItemsCount;
    map["itemsAvailable"] = itemsAvailable;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => super.hashCode;

  String get getDisplayOriginalPrice =>
      '$currency ${price.toStringAsFixed(2)} / $unit';
  String get getDisplayPromotionPrice => discountPrice != null
      ? '$currency ${discountPrice.toStringAsFixed(2)} / $unit'
      : '';

  String getTagAssetImage() {
    if(isPromotion == true)
      return 'assets/img/Tag_Promotion.png';
    else if(isBestSale == true)
      return 'assets/img/Tag_Best_Sale.png';
    else if(isNewArrival == true)
      return 'assets/img/Tag_NewArrival.png';
    else if(isSpecial4U == true)
      return 'assets/img/Tag_Special4u.png';
    else
      return null;
  }
}
