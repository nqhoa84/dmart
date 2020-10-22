import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../src/helpers/helper.dart';
import '../models/promotion.dart';

Future<Stream<Promotion>> getPromotions() async {
  Uri uri = Helper.getApiUri('promotions');
  print(uri.toString());
  try{
    final client = new http.Client();
    StreamedResponse streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Promotion.fromJSON(data);
    });
  }catch (e, trace) {
    print('$e \n $trace');
    return new Stream.value(new Promotion.fromJSON({}));
  }
}
