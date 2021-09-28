import 'dart:convert';

import 'package:dmart/constant.dart';
import 'package:dmart/src/models/DateSlot.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/models/voucher.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart';
import '../helpers/helper.dart';
import '../models/credit_card.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Order>> getOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Stream.value(null);
  }
//  final String _apiToken = 'api_token=${_user.apiToken}&';
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;productOrders;productOrders.product;orderStatus;deliveryAddress;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=id&sortedBy=desc';
//  print('getOrders $url');
//  final client = new http.Client();
//  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?with=productOrders;productOrders.product;deliveryAddress&orderBy=id&sortedBy=desc';

  print('getOrders $url');
  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
        print(data);
    return Order.fromJSON(data);
  });
}

Future<Order> getOrder({int orderId}) async {
  var url = Uri.parse(
      '${GlobalConfiguration().getValue('api_base_url')}orders/$orderId?with=productOrders;productOrders.product;deliveryAddress');

  print(url);

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  print('getOrder-- $result');
  if(result['success'] != null && result['success'] == true) {
    return Order.fromJSON(result['data']);
  } else {
    return null;
  }
}

///
/// return order if OK, error msg if notOK
Future<dynamic> saveNewOrder(Order order) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return null;
  }

  var url = Uri.parse('${GlobalConfiguration().getValue('api_base_url')}orders');
  print('saveNewOrder $url \n map-para ${order.toMap()}');
  print('saveNewOrder $url \n headers ${createHeadersRepo()}');
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode(order.toMap()),
  );
  print('saveNewOrder ${response.body}');
  dynamic js = json.decode(response.body);
  if (js["success"] != null && js["success"] == true) {
    return Order.fromJSON(js['data']);
  } else {
    return js['message'];
  }
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Stream.value(null);
  }


  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders?with=user;productOrders;productOrders.product;orderStatus;deliveryAddress&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';
  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Order.fromJSON(data);
  });
}


Future<Order> addOrder(Order order) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Order();
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
//  final String _apiToken = 'api_token=${_user.apiToken}';
  var url = Uri.parse('${GlobalConfiguration().getString('api_base_url')}orders');
  print('addOrder $url');


//  final client = new http.Client();
  Map params = order.toMap();
  params.addAll(_creditCard.toMap());
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode(params),
  );

  print('addOrder result ${response.body}');
  return Order.fromJSON(json.decode(response.body)['data']);
}


Future<Voucher> getVoucher(String code) async {
  //vouchers/check?code=quI3mJB5mT
  var url = Uri.parse('${GlobalConfiguration().getString('api_base_url')}vouchers/check?code=$code');
  print(url);

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  if(result['success'] == true) {
    return Voucher.fromJSON(result['data']);
  } else {
    return null;
  }
}

Future<DateSlot> getDeliverSlots(DateTime date) async {
  var url = Uri.parse(
      '${GlobalConfiguration().getValue('api_base_url')}delivery_dates/get?date=${DmConst.dateFormatter.format(date)}');

  print(url);

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  if(result['success'] == true) {
     return DateSlot.fromJSON(result['data']);
  } else {
    return DateSlot()..deliveryDate = date;
  }
}

Future<bool> cancelOrder(int id) async {
  var url = Uri.parse(
      '${GlobalConfiguration().getValue('api_base_url')}orders/$id/cancel');

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  print(result);
  return result['success'] != null && result['success'] == true;
}


Future<Stream<Product>> getBoughtProducts() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}boughs?with=productOrders;productOrders.product;orderStatus;deliveryAddress&orderBy=id&sortedBy=desc';
  var req = http.Request('get', Uri.parse(url));
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
}
