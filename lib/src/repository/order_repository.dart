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

Future<Stream<Order>> getOrder(orderId) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Stream.value(null);
  }
//  final String _apiToken = 'api_token=${_user.apiToken}&';
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?${_apiToken}with=user;productOrders;productOrders.product;orderStatus;deliveryAddress;payment';
//  print ('getOrder $url');
//  final client = new http.Client();
//  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  final String url =
      '${GlobalConfiguration().getString('api_base_url')}orders/$orderId?with=user;productOrders;productOrders.product;orderStatus;deliveryAddress';
  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Order.fromJSON(data);
  });
}

Future<Order> saveNewOrder(Order order) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return null;
  }

  final String url = '${GlobalConfiguration().getString('api_base_url')}orders';
  print('saveNewOrder $url \n map-para ${order.toMap()}');
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
    return null;
  }
}

Future<Stream<Order>> getRecentOrders() async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Stream.value(null);
  }
//  final String _apiToken = 'api_token=${_user.apiToken}&';
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}orders?${_apiToken}with=user;productOrders;productOrders.product;orderStatus;deliveryAddress;payment&search=user.id:${_user.id}&searchFields=user.id:=&orderBy=updated_at&sortedBy=desc&limit=3';
//
//  final client = new http.Client();
//  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

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

//Future<Stream<OrderStatus>> getOrderStatus() async {
//  User _user = userRepo.currentUser.value;
//  if (_user.apiToken == null) {
//    return new Stream.value(null);
//  }
//  final String _apiToken = 'api_token=${_user.apiToken}';
//  final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';
//  print('getOrderStatus $url');
//
//  final client = new http.Client();
//  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
//
//  return streamedRest.stream
//      .transform(utf8.decoder)
//      .transform(json.decoder)
//      .map((data) => Helper.getData(data))
//      .expand((data) => (data as List))
//      .map((data) {
//    return OrderStatus.fromJSON(data);
//  });
//}

Future<Order> addOrder(Order order) async {
  User _user = userRepo.currentUser.value;
  if (_user.isLogin == false) {
    return new Order();
  }
  CreditCard _creditCard = await userRepo.getCreditCard();
  order.user = _user;
//  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}orders';
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
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}vouchers/check?code=$code';
  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
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
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}delivery_dates/get?date=${DmConst.dateFormatter.format(date)}';
  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  print(url);
//  final streamedRest = await http.Client().send(req);
//
//  return streamedRest.stream
//      .transform(utf8.decoder)
//      .transform(json.decoder)
//      .map((data) => Helper.getData(data))
//      .map((data) {
//    return DateSlot.fromJSON(data);
//  });

  http.Response res = await http.get(url, headers: createHeadersRepo());
  var result = json.decode(res.body);
  if(result['success'] == true) {
     return DateSlot.fromJSON(result['data']);
  } else {
    return DateSlot()..deliveryDate = date;
  }
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
