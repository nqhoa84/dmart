import 'dart:convert';
import 'dart:io';

import 'package:dmart/src/models/api_result.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
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
      saveUserToShare(currentUser.value);
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

Future<ApiResult<User>> loginFB({@required String fbId, String accessToken, String name, String avatarUrl}) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}login/facebook';
  var paras = {
    'facebook_id': '$fbId',
    'access_token': '$accessToken',
    'name': '$name',
    'avatar_url': '$avatarUrl',
    'device_token': '${DmConst.deviceToken}'
  };

  print(url);
  print(paras);
  final response = await http.Client().post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
//      body: user.toMap(),
    body: json.encode(paras),
  );
  print('login ${response.body}');

  ApiResult<User> re = ApiResult<User>();
  if (response.statusCode == 200 && response.headers.containsValue('application/json')) {
    dynamic js = json.decode(response.body);
    re.setMsgAndStatus(js);
    if(re.isSuccess) {
      String token = toStringVal(js['data']['token']);
      re.data = User.fromJSON(js['data']['user']);
      currentUser.value = re.data;
      currentUser.value.apiToken = token;
    }
  } else {
    re.isNoJson = true;
  }
  return re;
}

///return OTP if register ok. if not, return nullOrEmpty
Future<String> register(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}register';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMapReg()),
  );

  print('register ${response.body}');
  dynamic js = json.decode(response.body);
  /**
   * {
      "success": true,
      "data": {
      "phone": "0123456790",
      "OTP": "145321",
      "expired": 300
      },
      "message": "Successfully! Please verify by OTP code has been received in your phone!"
      }
   */

  if (js["success"] != null && js["success"] == true) {
    return toStringVal(js['data']['OTP']);
  } else {
    return null;
  }
}


Future<String> resendOtp(String phone) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}otp/resend';
  final response = await http.Client().post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'phone': phone}),
  );

  print('resendOtp ${response.body}');
  dynamic js = json.decode(response.body);
  /**
   * {
      "success": false,
      "message": "User is not exist or activated"
      }

   */

  if(js["success"] != null && js["success"] == true) {
    return js['data']['OTP'];
  } else {
    return null;
  }
}
///Verify Otp to complete registration.
///This will also automatic login for customer.
Future<User> verifyOtp(String phone, String otp) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}otp/verify';
  final response = await http.Client().post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'phone': phone, 'OTP': otp}),
  );

  print('verifyOtp ${response.body}');
  dynamic js = json.decode(response.body);
  /**
   * {
      "success": true,
      "data": {
      "user:{},
      "token":xxxx
      },
      "message": "Successfully! Please verify by OTP code has been received in your phone!"
      }
   */

  if (js["success"] != null && js["success"] == true) {
    String token = toStringVal(js['data']['token']);
    currentUser.value = User.fromJSON(js['data']['user']);
    currentUser.value.apiToken = token;
    print(json.encode(currentUser.value.toMap()));
    saveUserToShare(currentUser.value);
    print('user: ${currentUser.value.toStringIdName()}');
    print('token: ${currentUser.value.apiToken}');
    print('-----------------------------------');
    return currentUser.value;
  } else {
    return null;
  }
}

///return the OTP send to client.
Future<String> sendOtpForgotPass(String phone) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}forgot_password';
  final response = await http.Client().post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'phone': phone}),
  );
  print('forgot_password ${response.body}');
  dynamic js = json.decode(response.body);

  if (js["success"] != null && js["success"] == true) {
    return toStringVal(js['data']['OTP']);
  } else {
    return null;
  }
}

Future<bool> resetPassword(String phoneWith855, String userEnterOtp, String password) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}reset_password';
  final response = await http.Client().post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode({'phone': phoneWith855, 'OTP': userEnterOtp, 'password': password,
      'device_token': DmConst.deviceToken??''}),
  );
  print('reset_password ${response.body}');
  dynamic js = json.decode(response.body);

  if (js["success"] != null && js["success"] == true) {
    return true;
  } else {
    return false;
  }
}

Future<bool> changePwd(String phoneWith855, String currentPass, String newPass) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}change_password';
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode({'old_password': currentPass, 'new_password': newPass}),
  );
  print('change_password ${response.body}');
  dynamic js = json.decode(response.body);

  if (js["success"] != null && js["success"] == true) {
    return true;
  } else {
    return false;
  }
}

Future<void> logout() async {
  currentUser.value = new User();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

void saveUserToShare(User u) async {
//  if (json.decode(jsonString)['data'] != null) {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
//  }
  if (u != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(u.toMap4SharePreference()));
  }
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
  final String url = '${GlobalConfiguration().getString('api_base_url')}profile/update';

  print("update User - $url");
  print(user.toMap());
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode(user.toMap()),
  );
  dynamic js = json.decode(response.body);
  print(response.body);
  if (js["success"] != null && js["success"] == true) {
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
    saveUserToShare(user);
  } else {
    return null;
  }

  return currentUser.value;
}

Future<User> updatePersonalDetail(User user) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}profile/update';

  print("update User - $url");
  print(user.toMapUpdateInfo());
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode(user.toMapUpdateInfo()),
  );
  dynamic js = json.decode(response.body);
  print(response.body);
  if (js["success"] != null && js["success"] == true) {
    currentUser.value = User.fromJSON(json.decode(response.body)['data']);
    saveUserToShare(user);
  } else {
    return null;
  }

  return currentUser.value;
}

Future<List<Province>> getProvinces() async {

  List<Province> re = [];

  try {
    final String url = '${GlobalConfiguration().getString('api_base_url')}provinces';
    print('getProvinces $url');
    final response = await http.Client().get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    print('getProvinces ${response.body}');
    dynamic js = json.decode(response.body);
    if (js["success"] != null && js["success"] == true) {
      (js['data'] as List).forEach((element) {
        re.add(Province.fromJSON(element));
      });
    }
  } catch (e, trace) {
    print('$e \n $trace');
  }
  return re;
}

Future<List<District>> getDistricts(int provinceId) async {
  List<District> re = [];
  try {
    final String url = '${GlobalConfiguration().getString('api_base_url')}districts?province_id=$provinceId';
    print('getDistricts $url');
    final response = await http.Client().get( url );
    print('getDistricts ${response.body}');
    dynamic js = json.decode(response.body);
    if (js["success"] != null && js["success"] == true) {
      (js['data'] as List).forEach((element) {
        re.add(District.fromJSON(element));
      });
    }
  } catch (e, trace) {
    print('$e \n $trace');
  }
  return re;
}

Future<List<Ward>> getWards(int districtId) async {
  List<Ward> re = [];
  try {
    final String url = '${GlobalConfiguration().getString('api_base_url')}wards?district_id=$districtId';
    print('getWards $url');
    final response = await http.Client().get( url );
    print('getWards ${response.body}');
    dynamic js = json.decode(response.body);
    if (js["success"] != null && js["success"] == true) {
      (js['data'] as List).forEach((element) {
        re.add(Ward.fromJSON(element));
      });
    }
  } catch (e, trace) {
    print('$e \n $trace');
  }
  return re;
}

Future<Stream<Address>> getAddresses() async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses';
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
//    print('address data: $data');
    Address a = Address.fromJSON(data);
//    print('address obj: $a');
    return a;
  });
}

Future<List<Address>> addAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/add';
  print('addAddress $url');
  print(address.toMap());
  final response = await http.Client().post(
    url,
    headers: createHeadersRepo(),
    body: json.encode(address.toMap()),
  );

  print(response.body);

  dynamic js = json.decode(response.body);
  List<Address> re = [];
  if (js["success"] != null && js["success"] == true) {
    (js['data'] as List).forEach((element) {
      re.add(Address.fromJSON(element));
    });
  }
  return re;
}

Future<List<Address>> updateAddress(Address address) async {
  User _user = userRepo.currentUser.value;
  address.userId = _user.id;
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}';
  final response = await http.Client().put(
    url,
    headers: createHeadersRepo(),
    body: json.encode(address.toMap()),
  );
  dynamic js = json.decode(response.body);
  List<Address> re = [];
  if (js["success"] != null && js["success"] == true) {
    (js['data'] as List).forEach((element) {
      re.add(Address.fromJSON(element));
    });
  }
  return re;
}

Future<bool> removeDeliveryAddress(Address address) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}delivery_addresses/${address.id}';
  final response = await http.Client().delete(
    url,
    headers: createHeadersRepo(),
  );
  dynamic js = json.decode(response.body);
  return js["success"] != null && js["success"] == true;
}
