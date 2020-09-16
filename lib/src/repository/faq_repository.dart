import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart';
import '../helpers/helper.dart';
import '../models/faq_category.dart';
import '../models/user.dart';
import '../repository/user_repository.dart';

Future<Stream<FaqCategory>> getFaqCategories() async {
  User _user = currentUser.value;
//  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getString('api_base_url')}faq_categories?with=faqs';

  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return FaqCategory.fromJSON(data);
  });
}
