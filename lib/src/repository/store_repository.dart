import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/filter.dart';
import '../models/store.dart';
import '../models/review.dart';
import '../repository/user_repository.dart';

Future<Stream<Store>> getNearStores(Address myLocation, Address areaLocation) async {
  Uri uri = Helper.getUri('api/stores');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '6';
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Store.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Store.fromJSON({}));
  }
}

Future<Stream<Store>> getPopularStores(Address myLocation) async {
  Uri uri = Helper.getUri('api/stores');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '6';
  _queryParams['popular'] = 'all';
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Store.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Store.fromJSON({}));
  }
}

Future<Stream<Store>> searchStores(String search, Address address) async {
  final String _searchParam = 'search=name:$search;description:$search&searchFields=name:like;description:like';
  final String _orderLimitParam = 'orderBy=area&limit=5';
  final String url = '${GlobalConfiguration().getString('api_base_url')}stores?$_searchParam&$_orderLimitParam';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Store.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Store.fromJSON({}));
  }
}

Future<Stream<Store>> getStore(String id, Address address) async {
  Uri uri = Helper.getUri('api/stores/$id');
  Map<String, dynamic> _queryParams = {};
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) => Store.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Store.fromJSON({}));
  }
}

Future<Stream<Review>> getStoreReviews(String id) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}store_reviews?with=user&search=store_id:$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Stream<Review>> getRecentReviews() async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}store_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Review> addStoreReview(Review review, Store store) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}store_reviews';
  final client = new http.Client();
  review.user = currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofStoreToMap(store)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}
