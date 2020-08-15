import 'dart:convert';

import '../../src/models/product.dart';

import '../../src/models/brand.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/filter.dart';

Future<Stream<Brand>> getBrands() async {
  Uri uri = Helper.getUri('api/brands');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  filter.delivery = false;
  filter.open = false;

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
        .map((data) => Brand.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Brand.fromJSON({}));
  }
}

Future<Stream<Brand>> getBrand(String id) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}brands/$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) => Brand.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Brand.fromJSON({}));
  }
}


