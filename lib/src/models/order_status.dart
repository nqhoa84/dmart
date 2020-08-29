class OrderStatus {
  String id;
  String status;

  OrderStatus({this.id, this.status});

  OrderStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'] != null ? jsonMap['status'] : '';
    } catch (e) {
      id = '';
      status = '';
      print(e);
    }
  }
}
