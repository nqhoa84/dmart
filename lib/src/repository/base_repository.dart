import 'dart:convert';
import 'dart:io';

import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/api_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

///This will post data in json format to server.<br/>
///[shortUrl] is the String without host. The real url to post will be [apiBaseUrl + shortUrl].<br/>
///The header is minimal data with 'language' value.
Future<http.Response> post({@required String shortUrl, Map body}) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}$shortUrl';
  print('url: $url \nParas: $body');
  return await http.Client().post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json', 'language': DmState.isKhmer ? 'kh' : 'en'},
    body: json.encode(body),
  );
}

///This will post data in json format to server.<br/>
///[shortUrl] is the String without host. The real url to post will be [apiBaseUrl + shortUrl].<br/>
///[paras] must NOT contain keys: 'language' because it wil be added before submitting.<br/>
Future<http.Response> get({@required String shortUrl, Map paras}) async {
  final String url = '${GlobalConfiguration().getString('api_base_url')}$shortUrl';
  print('url: $url \nParas: $paras');
  if (paras != null) {
    Map newParas = {HttpHeaders.contentTypeHeader: 'application/json', 'language': DmState.isKhmer ? 'kh' : 'en'};
    newParas.addAll(paras);
    return await http.Client().get(url, headers: newParas);
  } else {
    return await http.Client().get(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json', 'language': DmState.isKhmer ? 'kh' : 'en'},
    );
  }
}


///Determine is the api request return in json format
///
/// 404	Not Found (page or other resource doesn’t exist)
///    401	Not authorized (not logged in)
///    403	Logged in but access to requested area is forbidden
///    400	Bad request (something wrong with URL or parameters)
///    422	Unprocessable Entity (validation failed)
///    500	General server error
bool isApiReturnedJson(http.Response response) {
  return response.statusCode != 404 && response.statusCode != 400;
}

///Decode response into Map object. 
dynamic decodeResponse(ApiResult apiResult, http.Response response) {
  if (isApiReturnedJson(response)) {
    apiResult.isNoJson = false;
    dynamic js = json.decode(response.body);
    apiResult.setMsgAndStatus(js);
    if(apiResult.isSuccess) {
      return js['data'];
    }
  } else {
    apiResult.isNoJson = true;
  }
  return null;
}
