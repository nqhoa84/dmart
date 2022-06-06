import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/DateSlot.dart';
import 'package:dmart/src/models/order_status.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';
import 'controller.dart';

class OrderController extends Controller {
  List<Order>? historyOrders = <Order>[];
  List<Order>? confirmedOrders = <Order>[];
  List<Order>? pendingOrders = <Order>[];

  List<Product>? boughtProducts;

  Order? order;

  BuildContext? context;

  OrderController({
    this.historyOrders,
    this.confirmedOrders,
    this.pendingOrders,
    this.boughtProducts,
    this.order,
    this.context,
  });

  void listenForBoughtProducts({Function()? onDone}) async {
    final Stream<Product> stream = await getBoughtProducts();
    boughtProducts = [];
    stream.listen((Product _product) {
      setState(() {
        boughtProducts!.add(_product);
        print('boughtProduct - ${_product.id}');
      });
    }, onError: (a) {
      print('listenForBoughtProducts----- $a');
    }, onDone: onDone);
  }

  void listenForOrders({String? message}) async {
    final Stream<Order?> stream = await getOrders();
    stream.listen((Order? _order) {
      if (_order!.isValid) {
        setState(() {
          historyOrders!.add(_order);
          switch (_order.orderStatus) {
            case OrderStatus.created:
              pendingOrders!.add(_order);
              break;
            case OrderStatus.approved:
            case OrderStatus.preparing:
            case OrderStatus.delivering:
            case OrderStatus.deliverFailed:
              confirmedOrders!.add(_order);
              break;
          }
        });
      }
    }, onError: (a) {
      print('listenForOrders ---- $a');
      showError(S.current.verifyYourInternetConnection);
    }, onDone: () {
      showError(message!);
    });
  }

  void listenForOrder({int? orderId}) async {
    if (!DmState.isLoggedIn()) {
      RouteGenerator.gotoHome(context!);
    } else {
      var order = await getOrder(orderId: orderId!);
      setState(() {
        this.order = order;
      });
    }
  }

  Future<void> refreshOrders() async {
    historyOrders!.clear();
    confirmedOrders!.clear();
    pendingOrders!.clear();
    listenForOrders(message: S.current.orderRefreshedSuccessfully);
  }

  void listenVoucher({@required code, String? message}) async {
    await getVoucher(code).then((voucher) {
      print('Voucher --- $voucher');
      if (voucher == null || voucher.isValid == false) {
        showError(S.current.invalidVoucher);
      } else {
        setState(() {
          this.order!.applyVoucher(voucher);
//          this.order.voucher = voucher;
          print('-------${order!.voucherDiscount} -- ${order!.voucher}');
        });
        showMsg(S.current.voucherApplied);
      }
    });
  }

  void showError(String msg) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  }

  void showMsg(String msg) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(msg)));
  }

  List<DateSlot> dateSlots = [];

  Future<DateSlot?> listenForDeliverSlot({DateTime? date}) async {
//    final Stream<DateSlot> stream = await getDeliverSlots(date);
    var ds = findDateSlot(date!);
    return ds;
    // final DateSlot v = await getDeliverSlots(date);
    // print('dateslot return: $v');
    // dateSlots.add(v);
    // return v;
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
//        content: Text(S.current.verifyYourInternetConnection),
//      ));
//    }, onDone: onDone
//    );
  }

  DateSlot? findDateSlot(DateTime date) {
    DateSlot? re;
    dateSlots.forEach((element) {
      if (element.deliveryDate != null &&
          element.deliveryDate!.year == date.year &&
          element.deliveryDate!.month == date.month &&
          element.deliveryDate!.day == date.day) {
        re = element;
      }
    });
    return re;
  }

  bool checkOrderBeforePost() {
    bool result = true;
    bool isOK = order!.totalItems > 0 &&
        order!.orderVal > 0 &&
        order!.expectedDeliverSlotTime! >= 0;
    if (!isOK) {
      showErr(S.current.invalidOrder);
      result = false;
    }
    order!.productOrders?.forEach((po) {
      if (po.quantity! > toDouble(po.product!.itemsAvailable)) {
        showErr(S.current.orderItemOutOfStock);
        result = false;
      }
    });
    return result;
  }

  bool isSavingOrder = false;

  saveOrder({String? errMsg, String? successMsg}) async {
    isSavingOrder = true;
    var re = await saveNewOrder(order!);
    isSavingOrder = false;
    if (re != null && re is Order) {
      return re;
    } else {
      // showError(S.current.placeOrderError);
      showError("$re");
    }
  }

  Future<bool> cancelPendingOrder(Order order) async {
    if (order.canCancel()) {
      var re = await cancelOrder(order.id);
      if (re) {
        showMsg(S.current.cancelOrderSuccess);
        return true;
      } else {
        showMsg(S.current.cancelOrderFail);
      }
    } else {
      showErr(S.current.cantCancelProcessingOrder);
    }
    return false;
  }

  // api/orders/$id?api_token=${_apiToken}
}
