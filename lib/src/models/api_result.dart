

class ApiResult<T> {
  String message;
  bool isSuccess;
  bool isNoJson = false;
  T data;

  ApiResult({this.isSuccess, this.message, this.data, this.isNoJson});

  void setMsgAndStatus(Map<String, dynamic> jsonMap) {
    this.message = jsonMap.containsKey('message') ? jsonMap['message'] ?? '' : '';
    this.isSuccess = jsonMap.containsKey('success') ? jsonMap['success']  ?? false : false;
  }
}
