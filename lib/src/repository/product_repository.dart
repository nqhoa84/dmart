import 'dart:convert';
import 'dart:io';

import 'package:dmart/utils.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/favorite.dart';
import '../models/filter.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Product>> getTrendingProducts() async {
  Uri uri = Helper.getApiUri('products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  filter.delivery = false;
  filter.open = false;
  _queryParams['limit'] = '6';
  _queryParams['trending'] = 'week';
  _queryParams['search'] = 'itemsAvailable:0';
  _queryParams['searchFields'] = 'itemsAvailable:<>';
  _queryParams['searchJoin'] = 'and';
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProducts() async {
  Uri uri = Helper.getApiUri('products');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProduct(int productId) async {
  Uri uri = Helper.getApiUri('products/$productId');
  uri = uri.replace(queryParameters: {
    'with': 'store;category;brand;options;optionGroups;productReviews;productReviews.user',
    'search': 'itemsAvailable:0',
    'searchFields': 'itemsAvailable:<>'
  });


  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> searchProducts(String search, {int page = 1}) async {

//  Uri uri = Helper.getApiUri('products');
//  uri = uri.replace(queryParameters: {
//    'search': '$search',
//    'page':'$page',
//    'searchFields': 'name:like;description:like;brand.name:like;category.name:like;itemsAvailable:<>',
//    'limit': '5',
//  });
//search=aaaaaa&searchFields=name;brand.name:like;category.name:like&page=2
  //'search=name:abc;description:abc;itemsAvailable:0&searchFields=name:like;description:like;itemsAvailable:<>'

//  http://dmart.khmermedia.xyz/api/v1/products?search=Vegetables&searchFields=name:like;description:like;brand.name:like;category.name:like

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products?search=$search&page=$page&searchFields=name:like;description:like;brand.name:like;category.name:like';

  print('$url');

  try {
    var req = Request('get', Uri.parse(url));
    req.headers.addAll(createHeadersRepo());
    final streamedRest = await http.Client().send(req);

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProductsByCategory(int categoryId, int pageIdx) async {
  print('---getProductsByCategory called in Product repository');
  Uri uri = Helper.getApiUri('products');

  uri = uri.replace(queryParameters: {
    'page': '$pageIdx',
    'with': 'store',
    'search': 'category_id:$categoryId;itemsAvailable:0',
    'searchFields': 'category_id:=;itemsAvailable:<>',
    'searchJoin': 'and'
  });
  print('$uri \n ${uri.queryParameters}');

//  Map<String, dynamic> _queryParams = {};
////  SharedPreferences prefs = await SharedPreferences.getInstance();
////  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  _queryParams['with'] = 'store';
//  _queryParams['search'] = 'category_id:$categoryId;itemsAvailable:0';
//  _queryParams['searchFields'] = 'category_id:=;itemsAvailable:<>';
//  _queryParams['searchJoin'] = 'and';
//  _queryParams['page'] = '$pageIdx';

//  _queryParams = filter.toQuery(oldQuery: _queryParams);
//  uri = uri.replace(queryParameters: _queryParams);
//  print('$uri \n ${uri.queryParameters}');

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProductsByPromotion(int promotionId, int pageIdx) async {
  Uri uri = Helper.getApiUri('promotions/$promotionId');
  uri = uri.replace(queryParameters: {'page': pageIdx.toString()});
  print('$uri \n ${uri.queryParameters}');

  try {
    final client = new http.Client();
    StreamedResponse streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
//          print('data $data');
          return Helper.getData(data);
//      return data['data']['products'];
        })
        .map((event) {
//      print('event $event');
          return Helper.getProducts(event);
        })
        .expand((data) => (data as List))
        .map((data) {
          return Product.fromJSON(data);
        });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getRelatedProducts(int productId) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}related_products/$productId';
  print('getRelatedProducts $url');

  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getBestSale(int pageIdx) async {
  Uri uri = Helper.getApiUri('best_sale');
  uri = uri.replace(queryParameters: {'page': pageIdx.toString()});
  print('$uri \n ${uri.queryParameters}');
  try {
    final client = new http.Client();
    StreamedResponse streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
//      print('data $data');
          return Helper.getData(data);
//      return data['data']['products'];
        })
        .map((event) {
//      print('event $event');
          return Helper.getData(event);
        })
        .expand((data) => (data as List))
        .map((data) {
//      print('best_sale data $data');
          return Product.fromJSON(data);
        });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getNewArrivals(int pageIdx) async {
  Uri uri = Helper.getApiUri('new_arrival');
  uri = uri.replace(queryParameters: {'page': pageIdx.toString()});
  print('$uri \n ${uri.queryParameters}');
  try {
    final client = new http.Client();
    StreamedResponse streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          return Helper.getData(data);
        })
        .map((event) {
          return Helper.getData(event);
        })
        .expand((data) => (data as List))
        .map((data) {
//      print('new_arrival data $data');
          return Product.fromJSON(data);
        });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getSpecial4U(int pageIdx) async {
  Uri uri = Helper.getApiUri('special_offer');
  uri = uri.replace(queryParameters: {'page': pageIdx.toString()});
  print('$uri \n ${uri.queryParameters}');
  try {
    final client = new http.Client();
    StreamedResponse streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
          return Helper.getData(data);
        })
        .map((event) {
          return Helper.getData(event);
        })
        .expand((data) => (data as List))
        .map((data) {
          return Product.fromJSON(data);
        });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProductsByBrand(brandId) async {
  Uri uri = Helper.getApiUri('products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'store';
  _queryParams['search'] = 'brand_id:$brandId;itemsAvailable:0';
  _queryParams['searchFields'] = 'brand_id:=;itemsAvailable:<>';
  _queryParams['searchJoin'] = 'and';

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Favorite>> getFavorites(int pageIdx) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return Stream.value(null);
  }
//  final String _apiToken = 'api_token=${_user.apiToken}&';
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}favorites?page=$pageIdx&${_apiToken}with=product&search=user_id:${_user.id}&searchFields=user_id:=';

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?page=$pageIdx&with=product&search=user_id:${_user.id}&searchFields=user_id:=';

  print('$url');

//  final client = new http.Client();
  var req = Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);
//  final response = await client.get(
//    url,
//    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
////      body: user.toMap(),
//    body: json.encode(user.toMap()),
//  );
  try {
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Favorite.fromJSON(data));
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Favorite> addFavorite(int productId) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Favorite();
  }
//  final String _apiToken = 'api_token=${_user.apiToken}';
  var favorite = Favorite();
  favorite.userId = _user.id;
  favorite.product = new Product()..id = productId;
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites';
  print(url);
  print(favorite.toMap());
  try {
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: createHeadersRepo(),
      body: json.encode(favorite.toMap()),
    );
    return favorite;
//    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e, trace) {
    print('$e \n $trace');
    return Favorite.fromJSON({});
  }
}

removeFavorite(Favorite favorite) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}';
  print('remove fav $url');
//  print(favorite.toMap());
  try {
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: createHeadersRepo(),
    );
//    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e, trace) {
    print('$e \n $trace');
//    return Favorite.fromJSON({});
  }
}

Future<Stream<Product>> getProductsOfStore(int marketId) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products?with=store&search=store.id:$marketId&searchFields=store.id:=';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getTrendingProductsOfStore(int marketId) async {
  Uri uri = Helper.getApiUri('products');
  uri = uri.replace(queryParameters: {
    'with': 'store',
    'search': 'store_id:$marketId;featured:1;itemsAvailable:0',
    'searchFields': 'store_id:=;featured:=;itemsAvailable:<>',
    'searchJoin': 'and',
  });
  // TODO Trending products only
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getFeaturedProductsOfStore(int marketId) async {
  Uri uri = Helper.getApiUri('products');
  uri = uri.replace(queryParameters: {
    'with': 'store',
    'search': 'store_id:$marketId;featured:1',
    'searchFields': 'store_id:=;featured:=',
  });
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Product.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Review> addProductReview(Review review, Product product) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}product_reviews';
  final client = new http.Client();
  review.user = userRepo.currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofProductToMap(product)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e, trace) {
    print('$e \n $trace');
    return Review.fromJSON({});
  }
}

Future<Stream<Review>> getProductReviews(int id) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}product_reviews?with=user&search=product_id:$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Review.fromJSON(data);
    });
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Review.fromJSON({}));
  }
}
