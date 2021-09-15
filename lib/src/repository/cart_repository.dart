import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Cart>> getCarts() async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Stream.value(null);
  }
//  final String _apiToken = 'api_token=${_user.apiToken}&';
//  final String url =
//  '${GlobalConfiguration().getString('api_base_url')}carts?${_apiToken}with=product;product.store;options&search=user_id:${_user.id}&searchFields=user_id:=';

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}carts?with=product;product.store;options&searchFields=user_id:=';
  print('getCarts $url');

  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);

//  final client = new http.Client();
//  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Cart.fromJSON(data);
  });
}

///Add cart for this user.
///return the up-to-state cart-list of current user.
Future<List<Cart>> addCart(int productId, {int quality = 1}) async {
//  Map<String, dynamic> decodedJSON = {};
//  final String _apiToken = 'api_token=${_user.apiToken}';
//  final String _resetParam = 'reset=${reset ? 1 : 0}';
//  cart.userId = _user.id;
  var url = Uri.parse('${GlobalConfiguration().getString('api_base_url')}carts');
  print('addCart $url');

//  final client = new http.Client();
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode({
      "product_id" : '$productId',
      "quantity" : '$quality'
    }),
  );
  List<Cart> re = [];
    print('addCart result\n${response.body}');
    var decodedJSON = json.decode(response.body)['data'] as List<dynamic>;
    decodedJSON.forEach((element) {
      Cart c = Cart.fromJSON(element);
      if(c.isValid) {
        re.add(c);
      }
    });
    return re;
}

Future<List<Cart>> updateCart(Cart cart) async {
  var url = Uri.parse('${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}');
  print('updateCart $url');
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: createHeadersRepo(),
    body: json.encode(cart.toMap()),
  );
  List<Cart> re = [];
  print('updateCart result\n${response.body}');
  var decodedJSON = json.decode(response.body)['data'] as List<dynamic>;
  decodedJSON.forEach((element) {
    Cart c = Cart.fromJSON(element);
    if(c.isValid) {
      re.add(c);
    }
  });
  return re;
}

Future<List<Cart>> removeCart(Cart cart) async {
  var url = Uri.parse('${GlobalConfiguration().getString('api_base_url')}carts/${cart.id}');
  print('removeCart $url');
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: createHeadersRepo(),
  );
  List<Cart> re = [];
  print('updateCart result\n${response.body}');
  var decodedJSON = json.decode(response.body)['data'] as List<dynamic>;
  decodedJSON.forEach((element) {
    Cart c = Cart.fromJSON(element);
    if(c.isValid) {
      re.add(c);
    }
  });
  return re;
}
