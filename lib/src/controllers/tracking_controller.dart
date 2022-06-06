import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/order_status.dart';

class TrackingController extends ControllerMVC {
  Order? order;
  List<OrderStatus>? orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState>? scaffoldKey;

  TrackingController({
    this.order,
    this.orderStatus,
    this.scaffoldKey,
  }) {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForOrder({int? orderId, String? message}) async {
    // final Stream<Order> stream = await getOrder(orderId);
    // stream.listen((Order _order) {
    //   setState(() {
    //     order = _order;
    //   });
    // }, onError: (a) {
    //   print(a);
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(S.current.verifyYourInternetConnection),
    //   ));
    // }, onDone: () {
    // });
  }

//  void listenForOrderStatus() async {
//    final Stream<OrderStatus> stream = await getOrderStatus();
//    stream.listen((OrderStatus _orderStatus) {
//      setState(() {
//        orderStatus.add(_orderStatus);
//      });
//    }, onError: (a) {}, onDone: () {});
//  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    this.orderStatus!.forEach((OrderStatus _orderStatus) {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          '$_orderStatus',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '${Helper.skipHtml(order!.note!)}',
            )),
        isActive: false,
      ));
    });
    return _orderStatusSteps;
  }

  Future<void> refreshOrder() async {
    order = new Order();
    listenForOrder(message: 'tracking_refreshed_successfuly');
  }
}
