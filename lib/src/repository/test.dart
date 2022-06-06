import 'dart:async';
import 'dart:io';

import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/repository/network/api_enpoint.dart';
import 'package:http/http.dart' as http;

class RestClient {
  Map<String, String> createHeaders({User? u}) {
    Map<String, String> header = Map();
    header[HttpHeaders.contentTypeHeader] = 'application/json';
    header['Authorization'] = 'Bearer ${u?.apiToken}';
    header['Language'] = DmState.getCurrentLanguage();
    return header;
  }



  Future<dynamic> get(String path, dynamic params) {
    return http.get(Uri.https(Endpoints.baseUrl, path));
  }

  Future<dynamic> post(String path, {body, encoding}) {
    return http.post(
      Uri.https(Endpoints.baseUrl, path),
      body: body,
      headers: createHeaders(),
      encoding: encoding,
    );
  }

  Future<dynamic> put(String path,
      {Map<String, String>? headers, body, encoding}) {
    return http.put(
      Uri.https(Endpoints.baseUrl, path),
      body: body,
      headers: createHeaders(),
      encoding: encoding,
    );
  }

  Future<dynamic> delete(String path,
      {Map<String, String>? headers, body, encoding}) {
    return http.delete(
      Uri.https(Endpoints.baseUrl, path),
      body: body,
      headers: createHeaders(),
      encoding: encoding,
    );
  }
}
