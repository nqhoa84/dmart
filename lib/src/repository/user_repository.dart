import 'dart:convert';
import 'dart:io';

import 'package:dmart/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<User> currentUser = new ValueNotifier(User());

Future<User> login(User user) async {
  try {
    final String url = '${GlobalConfiguration().getString('api_base_url')}login';
    final client = new http.Client();
    print('login $url \n map-para ${user.toMap()}');
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//      body: user.toMap(),
      body: json.encode(user.toMap()),
    );
    print('login ${response.body}');
    dynamic js = json.decode(response.body);
    if (js["success"] != null && js["success"] == true) {
      String token = toStringVal(js['data']['token']);
      currentUser.value = User.fromJSON(js['data']['user']);
      currentUser.value.apiToken = token;
      print('=============');
      print(json.encode(currentUser.value.toMap()));
      print('=============');
      setCurrentUser(json.encode(currentUser.value.toMap()));
      print('-----------------------------------');
      print('user: ${currentUser.value.toStringIdName()}');
      print('token: ${currentUser.value.apiToken}');
      print('-----------------------------------');
    }
  } catch (e, trace) {
    print('$e \n $trace');
  }
//  if (response.statusCode == 200) {
//    setCurrentUser(response.body);
//    currentUser.value = User.fromJSON(json.decode(response.body)['data']['user']);
//  } else {
//    throw new Exception(response.body);
//  }
  return currentUser.value;
}

Future<User> register(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  } else {
    throw new Exception(response.body);
  }
  return currentUser.value;
}

Future<bool> resetPassword(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}send_reset_link_email';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  if (response.statusCode == 200) {
    return true;
  } else {
    throw new Exception(response.body);
  }
}

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void setCurrentUser(jsonString) async {
//  if (json.decode(jsonString)['data'] != null) {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
//  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('current_user', jsonString);
}

Future<void> setCreditCard(CreditCard creditCard) async {
  if (creditCard != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('credit_card', json.encode(creditCard.toMap()));
  }
}

Future<User> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('current_user')) {
    currentUser.value = User.fromJSON(json.decode(await prefs.get('current_user')));

    print('------From share preferences---------');
    print('User: ${userRepo.currentUser.value.toStringIdName()}');
    print('token: ${userRepo.currentUser.value.apiToken}');
    print('-----------------------');
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}

Future<CreditCard> getCreditCard() async {
  CreditCard _creditCard = new CreditCard();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('credit_card')) {
    _creditCard = CreditCard.fromJSON(json.decode(await prefs.get('credit_card')));
  }
  return _creditCard;
}

Future<User> update(User user) async {
  final String _apiToken = 'api_token=${currentUser.value.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}users/${currentUser.value.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  setCurrentUser(response.body);
  currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  return currentUser.value;
}

Future<Stream<Address>> getAddresses() async {
//  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?search=user_id:${userRepo.currentUser.value.id}&searchFields=user_id:=&orderBy=updated_at&sortedBy=desc';
  print(url);
  var req = http.Request('get', Uri.parse(url));
  req.headers.addAll(createHeadersRepo());
  final streamedRest = await http.Client().send(req);

  return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) {
//    print(' --+++++++--- $data');
    return Helper.getData(data);
  }).expand((data) {
//        print(' ------------ $data');
    return data as List;
  }).map((data) {
    return Address.fromJSON(data);
  });
}

Future<Address> addAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> updateAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.put(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(address.toMap()),
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}

Future<Address> removeDeliveryAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Address.fromJSON(json.decode(response.body)['data']);
}
