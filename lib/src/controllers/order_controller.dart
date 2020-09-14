import 'dart:math' as math;
import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/DateSlot.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/models/product_order.dart';
import 'package:dmart/src/models/voucher.dart';
import 'package:dmart/src/repository/product_repository.dart';
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
//  Voucher voucher;
  GlobalKey<ScaffoldState> scaffoldKey;

  List<Product> boughtProducts = [];

  Order order;

  OrderController();

  void listenForBoughtProducts({Function() onDone}) async {
    print(' listenForBoughtProducts on order controller called. ${boughtProducts.length}');
//    final Stream<Product> stream = await getProductsByCategory(1,1);
//    boughtProducts.clear();
//    stream.listen((Product _product) {
//      setState(() {
//        boughtProducts.add(_product);
//        print('----------- ${_product.id}');
//      });
//    }, onError: (a) {
//      print(a);
//    }, onDone: (){
//      print(' onDone boughtProducts ${boughtProducts.length}');
//    }
//    );
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      setState(() {
        orders.add(_order);
        // TODO
//        if(_order.orderStatus.id=='5') ordersDelivered.add(_order);
//        if(_order.payment.status!='Paid') ordersUnpaid.add(_order);
//        if(_order.orderStatus.id=='4') ordersOnTheWay.add(_order);
//        if(_order.orderStatus.id=='3') ordersPreparing.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verifyYourInternetConnection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshOrders() async {
    orders.clear();
    listenForOrders(message: S.of(context).orderRefreshedSuccessfully);
  }

  void listenVoucher({@required code, String message}) async {
    await getVoucher(code).then((voucher) {
      print('Voucher --- $voucher');
      if (voucher == null || voucher.isValid == false) {
        showError(S.of(context).invalidVoucher);
      } else {
        setState(() {
          this.order.applyVoucher(voucher);
//          this.order.voucher = voucher;
          print('-------${order.voucherDiscount} -- ${order.voucher}');
        });
        showMsg(S.of(context).voucherApplied);
      }
    });
  }

  void showError(String msg) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  }

  void showMsg(String msg) {
    scaffoldKey?.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  }

  List<DateSlot> dateSlots = [];
  Future<DateSlot> listenForDeliverSlot({DateTime date}) async {
//    final Stream<DateSlot> stream = await getDeliverSlots(date);
    var ds = findDateSlot(date);
    if (ds != null) return ds;
    final DateSlot v = await getDeliverSlots(date);
    print('dateslot return: $v');
    dateSlots.add(v);
    return v;
//    stream.listen((DateSlot v) {
//      if(v.isValid) {
//        print('result from delivery - date $v');
//        setState(() {
//          dateSlots.add(v);
//        });
//      }
//    }, onError: (a) {
//      print(a);
//      scaffoldKey?.currentState?.showSnackBar(SnackBar(
//        content: Text(S.of(context).verifyYourInternetConnection),
//      ));
//    }, onDone: onDone
//    );
  }

  DateSlot findDateSlot(DateTime date) {
    DateSlot re;
    dateSlots.forEach((element) {
      if (element.deliveryDate != null &&
          element.deliveryDate.year == date.year &&
          element.deliveryDate.month == date.month &&
          element.deliveryDate.day == date.day) {
        re = element;
      }
    });
    return re;
  }

}
