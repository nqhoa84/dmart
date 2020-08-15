import 'dart:convert';
import '../../src/helpers/custom_trace.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../../src/helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';
import '../models/slider.dart';

Future<Stream<Slider>> getSliders() async {
  Uri uri = Helper.getUri('api/sliders');
  print(uri.toString());
  try{
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return Slider.fromJSON(data);
    });
  }catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Slider.fromJSON({}));

  }



}
