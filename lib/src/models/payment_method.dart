import '../../generated/l10n.dart';

class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  bool isDefault;

  PaymentMethod(this.id, this.name, this.description, this.route, this.logo, {this.isDefault = false});
}

class PaymentMethodList {
  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _cashList;
  List<PaymentMethod> _pickupList;

  PaymentMethodList() {
    this._paymentsList = [
//      new PaymentMethod("visacard", S.current.visa_card, S.current.click_to_pay_with_your_visa_card, "/Checkout", "assets/img/visacard.png", isDefault: true),
//      new PaymentMethod("mastercard", S.current.mastercard, S.current.click_to_pay_with_your_mastercard, "/Checkout", "assets/img/mastercard.png"),
//      new PaymentMethod("razorpay", S.current.razorpay, S.current.clickToPayWithRazorpayMethod, "/RazorPay", "assets/img/razorpay.png"),
//
//      new PaymentMethod("paypal", S.current.paypal, S.current.click_to_pay_with_your_paypal_account, "/PayPal", "assets/img/paypal.png"),
    ];
    this._cashList = [
//      new PaymentMethod("cod", S.current.cash_on_delivery, S.current.click_to_pay_cash_on_delivery, "/CashOnDelivery", "assets/img/cash.png"),
    ];
    this._pickupList = [
//      new PaymentMethod("pop", S.current.pay_on_pickup, S.current.click_to_pay_on_pickup, "/PayOnPickup", "assets/img/pay_pickup.png"),
    ];
  }

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
  List<PaymentMethod> get pickupList => _pickupList;
}
