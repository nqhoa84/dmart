import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class OrderController extends ControllerMVC {
  List<Order> orders = <Order>[];
  List<Order> ordersUnpaid = <Order>[];
  List<Order> ordersDelivered = <Order>[];
  List<Order> ordersOnTheWay = <Order>[];
  List<Order> ordersPreparing = <Order>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  OrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOrders();
  }
  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
        if(_order.orderStatus.id=='5') ordersDelivered.add(_order);
        if(_order.payment.status!='Paid') ordersUnpaid.add(_order);
        if(_order.orderStatus.id=='4') ordersOnTheWay.add(_order);
        if(_order.orderStatus.id=='3') ordersPreparing.add(_order);

      });
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(context).orderRefreshedSuccessfully);
  }
}
