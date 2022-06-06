import 'dart:convert';

import 'package:dmart/utils.dart';
import 'package:http/http.dart';

class ApiResult<T> {
  String? message;
  bool? isSuccess;
  bool? isNoJson = false;
  T? data;

  ApiResult({this.isSuccess, this.message, this.data, this.isNoJson});

  ///Check whether response body is json or not. if json then parse to get message and return the 'data' object.
  dynamic setMsgAndStatus(Response response) {
    printLog(response.body);
    var haveJs = DmUtils.isApiReturnedJson(response);

    if (haveJs) {
      dynamic jsonMap = json.decode(response.body);
      if (jsonMap != null) {
        this.isNoJson = false;
        this.isSuccess = jsonMap['success'] ?? false;
        if (this.isSuccess == false) {
          this.message = '';
          // {"success":false,"message":{"name":["The name must be at least 3 characters."]}}
          //{"success":false,"message":{"email":[""],"name":["The name must be at least 3 characters."]}}
          var jsMsg = jsonMap['message'];
          if (jsMsg != null && jsMsg is Map) {
            jsMsg.forEach((key, value) {
              this.message = this.message! + '$value\n';
            });
          }
        } else {
          this.message = (jsonMap['message'] ?? '').toString();
        }
        // printLog('json decode: $jsonMap');
        return jsonMap['data'];
      }
    }
    this.isNoJson = true;
    this.isSuccess = false;
    this.message = 'Don\'t have data';

    return null;
  }

  @override
  String toString() {
    return 'ApiResult {isSuccess: $isSuccess, isNoJson: $isNoJson, data: $data}';
  }
}
