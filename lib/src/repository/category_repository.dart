import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/filter.dart';

Future<Stream<Category>> getCategories() async {
  Uri uri = Helper.getApiUri('categories');
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
        .map((data) => Category.fromJSON(data));
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Stream<Category>> getCategory(int id) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}categories/$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) => Category.fromJSON(data));
  } catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Category> loadCategory(int id) async {
  // final String url = '${GlobalConfiguration().getValue('api_base_url')}categories/$id';
  var url = Uri.parse(
      '${GlobalConfiguration().getValue('api_base_url')}categories/$id');
  print(url);

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  print(result);
  if(result['success'] == true) {
    return Category.fromJSON(result['data']);
    // return OrderSetting.fromJSON(result['data']);
  } else {
    return null;
  }
}




