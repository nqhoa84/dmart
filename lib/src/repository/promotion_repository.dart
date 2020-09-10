import 'dart:convert';
import 'package:http/http.dart';

import '../../src/helpers/custom_trace.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../../src/helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';
import '../models/promotion.dart';

Future<Stream<Promotion>> getPromotions() async {
  Uri uri = Helper.getUri('api/promotions');
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
