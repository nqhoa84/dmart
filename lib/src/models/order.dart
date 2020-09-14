import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/models/cart.dart';
import 'package:dmart/src/models/voucher.dart';
import 'dart:math' as math;
import '../../utils.dart';
import '../models/address.dart';
import '../models/order_status.dart';
import '../models/product_order.dart';
import '../models/user.dart';
import 'i_name.dart';

class Order extends IdObj {
  List<ProductOrder> productOrders = [];
  OrderStatus orderStatus = OrderStatus.Created; //create = post, cancel = put
  double tax;
  double deliveryFee, serviceFee;
  String hint;
  DateTime expectedDeliverDate;
  int expectedDeliverSlotTime;
  DateTime updatedAt;
  Address deliveryAddress;
//  DateTime dateTime; //??
  User user;
  String voucherCode;
  double voucherDiscount = 0;

  Voucher voucher;

  double _totalItems;

  double _orderVal;

  double totalBeforeTax;

  double grandTotal;
//  Payment payment;

  String get getFullName  {
    return deliveryAddress != null ? deliveryAddress.fullName??'' : '';
  }

  String get getPhone  {
    return deliveryAddress != null ? deliveryAddress.phoneNumber??'' : '';
  }

  String get getAddress  {
    return deliveryAddress != null ? deliveryAddress.getFullAddress : '';
  }

  Order({int id, this.orderStatus}) : super(id: id);

  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      tax = toDouble(jsonMap['tax'], errorValue: 0);
      deliveryFee = toDouble(jsonMap['delivery_fee'], errorValue: 0);
      serviceFee = toDouble(jsonMap['service_fee'], errorValue: 0);
      hint = jsonMap['hint']??'';
      expectedDeliverDate = DateTime.tryParse(jsonMap['expectedDeliverDate'])??DateTime.now();
      expectedDeliverSlotTime = toInt(jsonMap['expectedDeliverSlotTime']);
      updatedAt = DateTime.tryParse(jsonMap['updated_at'])??DateTime.now();
      voucherCode = toStringVal(jsonMap['tax']);
      deliveryAddress =
          jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : new Address();
      productOrders = jsonMap['product_orders'] != null
          ? List.from(jsonMap['product_orders']).map((element) => ProductOrder.fromJSON(element)).toList()
          : [];
    } catch (e, trace) {
      id = -1;
      tax = 0.0;
      deliveryFee = 0.0;
      hint = '';
      deliveryAddress = new Address();
      productOrders = [];
      print('Error parsing data in Order.fromJSON $e \n $trace');
    }
  }

  String get getDeliverDateSlot {
    String slot = '';
    switch (this.expectedDeliverSlotTime) {
      case 1:
        slot = '8:00-10:00';
        break;
      case 2:
        slot = '10:00-12:00';
        break;
      case 3:
        slot = '12:00-14:00';
        break;
      case 4:
        slot = '14:00-16:00';
        break;
      case 5:
        slot = '16:00-18:00';
        break;
      case 6:
        slot = '18:00-20:00';
        break;
    }
   return '${DmConst.dateFormatter.format(this.expectedDeliverDate)}, $slot';
  }

  int get totalItems => _totalItems.round();

  double get orderVal => _orderVal;

  Map toMap() {
      var map = new Map<String, dynamic>();
      map["id"] = id;
//    map["user_id"] = user?.id;
//    map["order_status_id"] = orderStatus?.id;
      map["tax"] = tax;
      map["delivery_fee"] = deliveryFee;
      map["products"] = productOrders.map((element) => element.toMap()).toList();
//    map["payment"] = payment?.toMap();
      map["delivery_address"] = deliveryAddress.toMap();
      return map;
    }

  void clearProducts() {
    if(productOrders != null) productOrders.clear();
    else productOrders = [];
  }

  void applyCarts(List<Cart> carts) {
    clearProducts();
    carts?.forEach((element) {
      ProductOrder po = ProductOrder();
      po.product = element.product;
      po.quantity = element.quantity;
      productOrders.add(po);
    });

    _recalculate();
  }

  void _recalculate(){
    _totalItems = 0;
    _orderVal = 0;
    this.productOrders.forEach((element) {
      _totalItems += element.quantity;
      _orderVal += element.quantity * element.product.paidPrice;
    });

    serviceFee = math.max(DmState.serviceFeeMin,
        math.min(_orderVal * DmState.serviceFeePercent, DmState.serviceFeeMax));
    voucherDiscount = _calculateVoucherDiscount();
    totalBeforeTax = _orderVal + serviceFee + deliveryFee - voucherDiscount;
    tax = DmState.vatPercent * totalBeforeTax;
    grandTotal = totalBeforeTax + tax;
  }

  double _calculateVoucherDiscount () {
    if(voucher == null) return 0;
    double re = 0;
    if(voucher.minOrderValue != null && voucher.minOrderValue > orderVal) {
      return 0;
    }

    if(voucher!= null && voucher.isValid) {
      if(voucher.isFixedDiscount) {
        return math.max(0, voucher.value);
      } else {
        if(voucher.maxDiscount != null && voucher.maxDiscount > 0) {
          return math.min(voucher.maxDiscount, math.max(0, voucher.value * orderVal));
        } else {
          return math.max(0, voucher.value * orderVal);
        }
      }
    }
    return re;
  }

  void applyVoucher(Voucher voucher) {
    this.voucher = voucher;
    _recalculate();
  }
}
