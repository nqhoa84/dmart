import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/unit.dart';

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
  static Comparator<Product> priceComparatorUp = (a, b) => a.paidPrice?.compareTo(b.paidPrice);
  static Comparator<Product> priceComparatorDown = (a, b) => b.paidPrice?.compareTo(a.paidPrice);
  static Comparator<Product> dateComparatorUp = (a, b) => a.updatedAt?.compareTo(b.updatedAt);
  static Comparator<Product> dateComparatorDown = (a, b) => b.updatedAt?.compareTo(a.updatedAt);
  double price;
  double discountPrice;
  Media image;
  String descriptionEn = '', descriptionKh = '';
  String get description => DmState.isKhmer ? descriptionKh : descriptionEn;
  String ingredients;
  String capacity;
  Unit unit;
  double packageItemsCount;
  String itemsAvailable;
  bool featured;
  bool deliverable;
  String rate;
  Brand brand;
  Store store;
  Category category;
  ProductType productType;
  List<Option> options;
  List<Media> medias;
  List<OptionGroup> optionGroups;
  List<Review> productReviews;

  String currency = '\$';

  bool isSpecial4U = false;

  bool isNewArrival, isBestSale;
  double totalSale;
  String country, code, barCode;
  
  DateTime updatedAt;

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
    try {
//      print('---------------------');
//      print(jsonMap);
      convert(jsonMap);
//      checked = false;
    } catch (e, trace) {
      id = -1;
      nameEn = '';
      this.nameKh = nameEn;
      price = 0.0;
      discountPrice = 0.0;
      capacity = '';
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
    nameEn = toStringVal(jsonMap['name_en']);
    nameKh = toStringVal(jsonMap['name_kh']);
    price = toDouble(jsonMap['price'], errorValue: 0.0);
    discountPrice = toDouble(jsonMap['discount_price'], errorValue: null);
    descriptionEn = jsonMap['description_en'] ?? '';
    descriptionKh = jsonMap['description_kh'] ?? '';
    capacity = toStringVal(jsonMap['capacity']);
    try {
      unit = jsonMap['unit'] != null && jsonMap['unit'] is Map<String, dynamic>
          ? Unit.fromJSON(jsonMap['unit']) : null;
      this.productType = jsonMap['type'] != null && jsonMap['type'] is Map<String, dynamic>
          ? ProductType.fromJSON(jsonMap['type']) : null;
    } catch (e, trace) {
      print('$e $trace');
    }
    packageItemsCount = toDouble(jsonMap['package_items_count'], errorValue: 0.0);
    featured = jsonMap['featured'] ?? false;
    deliverable = jsonMap['deliverable'] ?? false;
    isNewArrival = jsonMap['is_new_arrival'] ?? false;
    isBestSale = jsonMap['is_best_sale'] ?? false;
    totalSale = toDouble(jsonMap['total_sale'], errorValue: 0.0);
    rate = toStringVal(jsonMap['rate']);
    itemsAvailable = toStringVal(jsonMap['itemsAvailable']);
    try {
      brand = jsonMap['brand'] != null && jsonMap['brand'] is Map<String, dynamic>
          ? Brand.fromJSON(jsonMap['brand'])
          : new Brand();
    } on Exception catch (e, trace) {
      print('$e $trace');
    }
    code = toStringVal(jsonMap['code']);
    country = toStringVal(jsonMap['country_code']);
    barCode = toStringVal(jsonMap['barcode']);
    updatedAt = toDateTime(jsonMap['updated_at']);
//    store = jsonMap['store'] != null
//        ? Store.fromJSON(jsonMap['store'])
//        : new Store();

    try {
      category = jsonMap['category'] != null && jsonMap['category'] is Map<String, dynamic>
          ? Category.fromJSON(jsonMap['category'])
          : new Category();
    } on Exception catch (e, trace) {
      print('$e $trace');
    }

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
      '$currency ${price.toStringAsFixed(2)} ${unit != null ? '/ $unit' : ''}';

  String get getDisplayPromotionPrice => discountPrice != null
      ? '$currency ${discountPrice.toStringAsFixed(2)} ${unit != null ? '/ $unit' : ''}'
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

  bool match(FilterCondition conditions) {
    if(conditions == null) return true;
    if(conditions.isBestSale != null && conditions.isBestSale != this.isBestSale)
      return false;
    if(conditions.isPromotion != null && conditions.isPromotion != this.isPromotion)
      return false;
    if(conditions.isNewArrival != null && conditions.isNewArrival != this.isNewArrival)
      return false;

    if(DmUtils.isNotNullEmptyList(conditions.cates)) {
      if(!conditions.cates.contains(this.category))
        return false;
    }
    if(DmUtils.isNotNullEmptyList(conditions.brands)) {
      if(!conditions.brands.contains(this.brand))
        return false;
    }
    if(DmUtils.isNotNullEmptyList(conditions.countries)) {
      if(!conditions.countries.contains(this.country))
        return false;
    }
    return true;
  }

  String get cateName => this.category != null ? this.category.name??'' : '';
  String get typeName => this.productType != null ? this.productType.name??'' : '';
  String get brandName => this.brand != null ? this.brand.name??'' : '';
  String get storeName => this.store != null ? this.store.name??'' : '';
  String get unitName => this.unit != null ? this.unit.name??'' : '';


}
