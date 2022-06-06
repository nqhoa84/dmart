import 'package:dmart/src/models/category.dart';

import '../../utils.dart';
import '../models/field.dart';
import 'brand.dart';

class Filter {
  bool delivery = false;
  bool open = false;
  List<Field> fields = [];

  Filter(
    this.delivery,
    this.open,
    this.fields,
  );

  Filter.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      open = jsonMap['open'] ?? false;
      delivery = jsonMap['delivery'] ?? false;
      fields =
          jsonMap['fields'] != null && (jsonMap['fields'] as List).length > 0
              ? List.from(jsonMap['fields'])
                  .map((element) => Field.fromJSON(element))
                  .toList()
              : [];
    } catch (e, trace) {
      print('Error parsing data in Filter $e \n $trace');
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['open'] = open;
    map['delivery'] = delivery;
    map['fields'] = fields.map((element) => element.toMap()).toList();
    return map;
  }

  @override
  String toString() {
    String filter = "";
    if (delivery) {
      if (open) {
        filter =
            "search=available_for_delivery:1;closed:0&searchFields=available_for_delivery:=;closed:=&searchJoin=and";
      } else {
        filter =
            "search=available_for_delivery:1&searchFields=available_for_delivery:=";
      }
    } else if (open) {
      filter = "search=closed:${open ? 0 : 1}&searchFields=closed:=";
    }
    return filter;
  }

  Map<String, dynamic> toQuery({Map<String, dynamic>? oldQuery}) {
    Map<String, dynamic> query = {};
    String relation = '';
    relation = oldQuery!['with'] != null ? oldQuery['with'] + '.' : '';
    query['with'] = oldQuery['with'] != null ? oldQuery['with'] : null;
    if (delivery) {
      if (open) {
        query['search'] = relation + 'available_for_delivery:1;closed:0';
        query['searchFields'] = relation + 'available_for_delivery:=;closed:=';
      } else {
        query['search'] = relation + 'available_for_delivery:1';
        query['searchFields'] = relation + 'available_for_delivery:=';
      }
    } else if (open) {
      query['search'] = relation + 'closed:${open ? 0 : 1}';
      query['searchFields'] = relation + 'closed:=';
    }
    if (fields.isNotEmpty) {
      query['fields[]'] = fields.map((element) => element.id).toList();
    }
    if (query['search'] != null) {
      query['search'] += ';' + oldQuery['search'];
    } else {
      query['search'] = oldQuery['search'];
    }

    if (query['searchFields'] != null) {
      query['searchFields'] += ';' + oldQuery['searchFields'];
    } else {
      query['searchFields'] = oldQuery['searchFields'];
    }
    query['searchJoin'] = 'and';
    return query;
  }
}

class FilterCondition {
  List<Category>? cates = [];
  List<Brand>? brands = [];
  List<String>? countries = [];

  FilterCondition({
    this.brands,
    this.cates,
    this.countries,
  });

  ///null means customer doesn't care<br/>
  bool? isPromotion;

  ///null means customer doesn't care<br/>
  bool? isNewArrival;

  ///nll means customer doesn't care<br/>
  bool? isBestSale;

  ///null means customer doesn't care<br/>
  ///true: price from low to high, other wise false.
  bool? isPriceUp;

  ///null means customer doesn't care<br/>
  ///true: latest first. false: oldest first.
  bool? isLatest;

  addCate(Category cat) {
    if (this.cates == null) cates = [];
    if (!this.cates!.contains(cat)) this.cates!.add(cat);
  }

  removeCate(Category cat) {
    if (this.cates == null) cates = [];
    if (this.cates!.contains(cat)) this.cates!.remove(cat);
  }

  addBrand(Brand brand) {
    if (this.brands == null) brands = [];
    if (!this.brands!.contains(brand)) this.brands!.add(brand);
  }

  removeBrand(Brand brand) {
    if (this.brands == null) brands = [];
    if (this.brands!.contains(brand)) this.brands!.remove(brand);
  }

  addCountry(String country) {
    if (this.countries == null) countries = [];
    if (!this.countries!.contains(country)) this.countries!.add(country);
  }

  removeCountry(String country) {
    if (this.countries == null) countries = [];
    if (this.countries!.contains(country)) this.countries!.remove(country);
  }

  void clear() {
    cates = null;
    brands = null;
    countries = null;
    this.isLatest = null;
    this.isPriceUp = null;
    this.isPromotion = null;
    this.isNewArrival = null;
    this.isBestSale = null;
  }

  bool get haveCondition {
    return DmUtils.isNotNullEmptyList(cates!) ||
        DmUtils.isNotNullEmptyList(brands!) ||
        DmUtils.isNotNullEmptyList(countries!) ||
        isLatest != null ||
        isPriceUp != null ||
        isPromotion != null ||
        isNewArrival != null ||
        isBestSale != null;
  }

  void copyFrom(FilterCondition filter) {
    this.cates = filter.cates;
    this.brands = filter.brands;
    this.countries = filter.countries;
    this.isLatest = filter.isLatest;
    this.isPriceUp = filter.isPriceUp;
    this.isPromotion = filter.isPromotion;
    this.isNewArrival = filter.isNewArrival;
    this.isBestSale = filter.isBestSale;
  }

  @override
  String toString() {
    return 'FilterCondition {cates: $cates, brands: $brands, countries: $countries, '
        'isLatest: $isLatest, isPriceUp: $isPriceUp, isPromotion: $isPromotion, '
        'isNewArrival: $isNewArrival, isBestSale: $isBestSale}';
  }
}
