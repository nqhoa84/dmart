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

  DateTime expectedDeliverDate;
  ///from 1-6, 8:00 to 20:00 of day.
  int expectedDeliverSlotTime;
  DateTime updatedAt;
  Address deliveryAddress;

//  DateTime dateTime; //??
  User user;

  DateTime createdDate;

  String get voucherCode => voucher != null ? (voucher.code ?? '') : '';

  Voucher voucher;

  double _totalItems = 0;
  double _orderVal = 0, _serviceFee = 0, _deliveryFee = 0, _voucherDiscount = 0;
  double _totalBeforeTax = 0;
  double _tax = 0;
  double _grandTotal;

  String note;

//  Payment payment;

  String get getFullName {
    return deliveryAddress != null ? deliveryAddress.fullName ?? '' : '';
  }

  String get getPhone {
    return deliveryAddress != null ? deliveryAddress.phone ?? '' : '';
  }

  String get getAddress {
    return deliveryAddress != null ? deliveryAddress.getFullAddress : '';
  }

  Order({int id, this.orderStatus}) : super(id: id);

  /*
   "id": 3,
                "user_id": 1,
                "order_status_id": 3,
                "tax": 10,
                "delivery_fee": 5,
                "hint": "",
                "active": true,
                "driver_id": null,
                "delivery_address_id": 18,
                "expected_delivery_date": "2020-09-10 00:00:00",
                "expected_delivery_slot": 3,
                "note": "note",
                "service_fee": 1,
                "voucher_code": "",
                "voucher_fee": 0,
   */
  Order.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = toInt(jsonMap['id']);
      int statusId = toInt(jsonMap['order_status_id'], errorValue: -1);
      if(statusId > 0 && statusId <= OrderStatus.values.length) {
          this.orderStatus = OrderStatus.values[statusId-1];
      } else this.orderStatus = OrderStatus.Unknown;

      _tax = toDouble(jsonMap['tax'], errorValue: 0);
      _deliveryFee = toDouble(jsonMap['delivery_fee'], errorValue: 0);
      _serviceFee = toDouble(jsonMap['service_fee'], errorValue: 0);
      _voucherDiscount = toDouble(jsonMap['voucher_fee'], errorValue: 0);
      this.voucher = Voucher();
      this.voucher.code = toStringVal(jsonMap['voucher_code'], errorValue: '');
      _orderVal = toDouble(jsonMap['order_value'], errorValue: 0);
      _grandTotal = toDouble(jsonMap['total'], errorValue: 0);
      _totalBeforeTax = _grandTotal - _tax;

      note = jsonMap['hint'] ?? '';
      expectedDeliverDate = toDateTime(jsonMap['expected_delivery_date'], errorValue: null);
      expectedDeliverSlotTime = toInt(jsonMap['expected_delivery_slot']);
      updatedAt = toDateTime(jsonMap['updated_at'], errorValue: null);
      createdDate = toDateTime(jsonMap['created_at'], errorValue: null);
//      voucherCode = toStringVal(jsonMap['tax']);
      deliveryAddress =
          jsonMap['delivery_address'] != null ? Address.fromJSON(jsonMap['delivery_address']) : new Address();
      productOrders = jsonMap['product_orders'] != null
          ? List.from(jsonMap['product_orders']).map((element) => ProductOrder.fromJSON(element)).toList()
          : [];

      _totalItems = 0;
//      _orderVal = 0;
      productOrders.forEach((element) {
        _totalItems += element.quantity;
//        _orderVal += element.quantity * element.paidPrice;
      });
    } catch (e, trace) {
      id = -1;
      note = '';
      deliveryAddress = new Address();
      productOrders = [];
      print('Error parsing data in Order.fromJSON $e \n $trace');
    }
  }

  String get getDeliverDateSlot {
    String slot = '';
    switch (this.expectedDeliverSlotTime) {
      case 1:
        slot = '08:00-10:00';
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

  double get orderVal => _orderVal??0;

  double get tax => _tax??0;

  double  get serviceFee => _serviceFee??0;

  double get deliveryFee => _deliveryFee??0;

  double get grandTotal => _grandTotal??0;

  double get voucherDiscount => _voucherDiscount??0;

  double get totalBeforeTax => _totalBeforeTax??0;

  /*
  products: {[{id:1, quantity: 1}, {id:2, quantity: 1}, {id:3, quantity: 5, }]}
tax: 10
voucher_code: ABCXYZ123
service_fee: 100
delivery_fee: 10
expected_delivery_date: yyyy-mm-dd
expected_delivery_slot
total: 1000
   */
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["products"] = productOrders.map((element) => element.toMap()).toList();
    map["tax"] = tax.toStringAsFixed(2);
    map["voucher_code"] = voucherCode ?? '';
    map["voucher_fee"] = (voucherDiscount ?? 0).toStringAsFixed(5);
    map["service_fee"] = serviceFee.toStringAsFixed(5);
    map["delivery_fee"] = deliveryFee.toStringAsFixed(5);
    map["expected_delivery_date"] = toDateStr(expectedDeliverDate);
    map["expected_delivery_slot"] = expectedDeliverSlotTime;
    map["total"] = grandTotal.toStringAsFixed(5);
    map["delivery_address_id"] = deliveryAddress.id;
    map["note"] = note ?? '';
    return map;
  }

  void clearProducts() {
    if (productOrders != null)
      productOrders.clear();
    else
      productOrders = [];
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

  void _recalculate() {
    _totalItems = 0;
    _orderVal = 0;
    this.productOrders.forEach((element) {
      _totalItems += element.quantity;
      _orderVal += element.quantity * element.product.paidPrice;
    });
    _orderVal = _orderVal;
    _serviceFee = math.max(DmState.orderSetting.serviceFeeMin,
        math.min(_orderVal * DmState.orderSetting.serviceFeePercent, DmState.orderSetting.serviceFeeMax));
    _voucherDiscount = math.min(_orderVal, _calculateVoucherDiscount());
    _totalBeforeTax = _orderVal + serviceFee + deliveryFee - voucherDiscount;
    _tax = DmState.orderSetting.vatTaxPercent * _totalBeforeTax;
    _grandTotal = _totalBeforeTax + tax;
  }

  double _round(double value) {
    return value;
//    return (value * 100000.0).roundToDouble() / 100000.0;
  }

  double _calculateVoucherDiscount() {
    if (voucher == null) return 0;
    double re = 0;
    if (voucher.minOrderValue != null && voucher.minOrderValue > orderVal) {
      return 0;
    }

    if (voucher != null && voucher.isValid) {
      if (voucher.isFixedDiscount) {
        return math.max(0, voucher.value);
      } else {
        if (voucher.maxDiscount != null && voucher.maxDiscount > 0) {
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

  void applyDeliveryFee(double fee) {
    _deliveryFee = fee;
    _recalculate();
  }
}
