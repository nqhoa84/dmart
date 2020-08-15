import '../models/category.dart';
import '../models/store.dart';
import '../models/media.dart';
import '../models/option.dart';
import '../models/option_group.dart';
import '../models/review.dart';
import '../models/brand.dart';

class Product {
  String id;
  String name;
  double price;
  double discountPrice;
  Media image;
  String description;
  String ingredients;
  String capacity;
  String unit;
  String packageItemsCount;
  String itemsAvailable;
  bool featured;
  bool deliverable;
  String rate;
  Brand brand;
  Store store;
  Category category;
  List<Option> options;
  List<OptionGroup> optionGroups;
  List<Review> productReviews;
  List<SaleTag> saleTags;

  double promotionPrice = 5, originalPrice = 10;
  String currency = '\$';

  //TODO change to return null.
  SaleTag get getDisplaySaleTag =>
      saleTags != null && saleTags.length > 0 ? saleTags[0] : SaleTag.BestSale;
  bool checked;

  Product();

  Product.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      discountPrice = jsonMap['discount_price'] != null
          ? jsonMap['discount_price'].toDouble()
          : 0.0;
      price = discountPrice != 0 ? discountPrice : price;
      discountPrice = discountPrice == 0
          ? discountPrice
          : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
      description =
          jsonMap['description'] != null ? jsonMap['description'] : '';
      capacity = jsonMap['capacity'].toString();
      unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
      packageItemsCount = jsonMap['package_items_count'] != null
          ? jsonMap['package_items_count'].toString()
          : '0';
      featured = jsonMap['featured'] ?? false;
      deliverable = jsonMap['deliverable'] ?? false;
      rate = jsonMap['rate'] ?? '0';
      itemsAvailable = jsonMap['itemsAvailable'] ?? '0';
      brand = jsonMap['brand'] != null
          ? Brand.fromJSON(jsonMap['brand'])
          : new Brand();

      store = jsonMap['store'] != null
          ? Store.fromJSON(jsonMap['store'])
          : new Store();

      category = jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : new Category();

      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();

      options =
          jsonMap['options'] != null && (jsonMap['options'] as List).length > 0
              ? List.from(jsonMap['options'])
                  .map((element) => Option.fromJSON(element))
                  .toSet()
                  .toList()
              : [];
      optionGroups = jsonMap['option_groups'] != null &&
              (jsonMap['option_groups'] as List).length > 0
          ? List.from(jsonMap['option_groups'])
              .map((element) => OptionGroup.fromJSON(element))
              .toSet()
              .toList()
          : [];
      productReviews = jsonMap['product_reviews'] != null &&
              (jsonMap['product_reviews'] as List).length > 0
          ? List.from(jsonMap['product_reviews'])
              .map((element) => Review.fromJSON(element))
              .toSet()
              .toList()
          : [];
      checked = false;
    } catch (e) {
      id = '';
      name = '';
      price = 0.0;
      discountPrice = 0.0;
      description = '';
      capacity = '';
      unit = '';
      packageItemsCount = '';
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
      checked = false;
      print(jsonMap);
    }
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
      '$currency ${originalPrice.toStringAsFixed(2)} / $unit';
  String get getDisplayPromotionPrice => promotionPrice != null
      ? '$currency ${promotionPrice.toStringAsFixed(2)} / $unit'
      : '';
}

enum SaleTag { BestSale, NewArrival, Promotion, Special4U }
