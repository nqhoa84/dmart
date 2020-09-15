import 'dart:math' as math;
import 'package:dmart/DmState.dart';
import 'package:dmart/src/models/DateSlot.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/order_status.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/models/product_order.dart';
import 'package:dmart/src/models/voucher.dart';
import 'package:dmart/src/repository/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';
import 'controller.dart';

class OrderController extends Controller {
  List<Order> historyOrders = <Order>[];
  List<Order> confirmedOrders = <Order>[];
  List<Order> pendingOrders = <Order>[];

  List<Product> boughtProducts;

  Order order;

  OrderController();

  void listenForBoughtProducts({Function() onDone}) async {
    final Stream<Product> stream = await getBoughtProducts();
    boughtProducts = [];
    stream.listen((Product _product) {
      setState(() {
        boughtProducts.add(_product);
        print('boughtProduct - ${_product.id}');
      });
    }, onError: (a) {
      print(a);
    }, onDone: onDone
    );
  }

  void listenForOrders({String message}) async {
    final Stream<Order> stream = await getOrders();
    stream.listen((Order _order) {
      if(_order.isValid) {
        setState(() {
          historyOrders.add(_order);
          switch(_order.orderStatus) {
            case OrderStatus.Created :
              pendingOrders.add(_order);
              break;
            case OrderStatus.Approved :
            case OrderStatus.Preparing :
            case OrderStatus.Delivering :
            case OrderStatus.DeliverFailed :
            confirmedOrders.add(_order);
              break;
          }
        });
      }

    }, onError: (a) {
      print(a);
      showError(S.of(context).verifyYourInternetConnection);
    }, onDone: () {
      if (message != null) {
        showError(message);
      }
    });
  }

  Future<void> refreshOrders() async {
    historyOrders.clear();
    confirmedOrders.clear();
    pendingOrders.clear();
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

  bool checkOrderBeforePost() {
    return order != null &&
        order.totalItems > 0 &&
        order.orderVal > 0 &&
        order.expectedDeliverDate != null &&
        order.expectedDeliverSlotTime >= 0;
  }

  bool isSavingOrder = false;

  Future<Order> saveOrder({String errMsg, String successMsg}) {
    return saveNewOrder(order);
    isSavingOrder = true;
    saveNewOrder(order).then((value) {
      return value;
    }).catchError((err) {
      if (errMsg != null) showError(errMsg);
      isSavingOrder = false;
    }).whenComplete(() {
      isSavingOrder = false;
    });
  }
}
