// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance;
  }

  static S maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Available`
  String get Available {
    return Intl.message(
      'Available',
      name: 'Available',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code {
    return Intl.message(
      'Code',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number, then tap send OTP to verify it.`
  String get providePhoneNoAndTapSendOtpToVerify {
    return Intl.message(
      'Please enter phone number, then tap send OTP to verify it.',
      name: 'providePhoneNoAndTapSendOtpToVerify',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtp {
    return Intl.message(
      'Send OTP',
      name: 'sendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Request OTP`
  String get requestOtp {
    return Intl.message(
      'Request OTP',
      name: 'requestOtp',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing {
    return Intl.message(
      'Processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get created {
    return Intl.message(
      'Created',
      name: 'created',
      desc: '',
      args: [],
    );
  }

  /// `Approved`
  String get approved {
    return Intl.message(
      'Approved',
      name: 'approved',
      desc: '',
      args: [],
    );
  }

  /// `Denied`
  String get denied {
    return Intl.message(
      'Denied',
      name: 'denied',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message(
      'Canceled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get preparing {
    return Intl.message(
      'Preparing',
      name: 'preparing',
      desc: '',
      args: [],
    );
  }

  /// `Delivering`
  String get delivering {
    return Intl.message(
      'Delivering',
      name: 'delivering',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message(
      'Delivered',
      name: 'delivered',
      desc: '',
      args: [],
    );
  }

  /// `DeliverFailed`
  String get deliverFailed {
    return Intl.message(
      'DeliverFailed',
      name: 'deliverFailed',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message(
      'Confirmed',
      name: 'confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message(
      'Unknown',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `Phnom penh`
  String get phnompenh {
    return Intl.message(
      'Phnom penh',
      name: 'phnompenh',
      desc: '',
      args: [],
    );
  }

  /// `Forgotten password?`
  String get forgetPassword {
    return Intl.message(
      'Forgotten password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have a Dmart24 account yet?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have a Dmart24 account yet?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Or sign in with:`
  String get orSignInWith {
    return Intl.message(
      'Or sign in with:',
      name: 'orSignInWith',
      desc: '',
      args: [],
    );
  }

  /// `Social network`
  String get socialNetwork {
    return Intl.message(
      'Social network',
      name: 'socialNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Whatapp may not be installed yet.`
  String get errorOpenWhatapp {
    return Intl.message(
      'Whatapp may not be installed yet.',
      name: 'errorOpenWhatapp',
      desc: '',
      args: [],
    );
  }

  /// `Wechat may not be installed yet.`
  String get errorOpenWechat {
    return Intl.message(
      'Wechat may not be installed yet.',
      name: 'errorOpenWechat',
      desc: '',
      args: [],
    );
  }

  /// `Viber may not be installed yet.`
  String get errorOpenViber {
    return Intl.message(
      'Viber may not be installed yet.',
      name: 'errorOpenViber',
      desc: '',
      args: [],
    );
  }

  /// `Instagram may not be installed yet.`
  String get errorOpenInstagram {
    return Intl.message(
      'Instagram may not be installed yet.',
      name: 'errorOpenInstagram',
      desc: '',
      args: [],
    );
  }

  /// `Telegram may not be installed yet.`
  String get errorOpenTelegram {
    return Intl.message(
      'Telegram may not be installed yet.',
      name: 'errorOpenTelegram',
      desc: '',
      args: [],
    );
  }

  /// `Facebook may not be installed yet.`
  String get errorOpenFb {
    return Intl.message(
      'Facebook may not be installed yet.',
      name: 'errorOpenFb',
      desc: '',
      args: [],
    );
  }

  /// `Facebook Messenger may not be installed yet.`
  String get errorOpenFbMess {
    return Intl.message(
      'Facebook Messenger may not be installed yet.',
      name: 'errorOpenFbMess',
      desc: '',
      args: [],
    );
  }

  /// `Line may not be installed yet.`
  String get errorOpenLine {
    return Intl.message(
      'Line may not be installed yet.',
      name: 'errorOpenLine',
      desc: '',
      args: [],
    );
  }

  /// `Hotline`
  String get hotline {
    return Intl.message(
      'Hotline',
      name: 'hotline',
      desc: '',
      args: [],
    );
  }

  /// `Some errors occurred, sorry for your inconvenience.`
  String get generalErrorMessage {
    return Intl.message(
      'Some errors occurred, sorry for your inconvenience.',
      name: 'generalErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Product code`
  String get productCode {
    return Intl.message(
      'Product code',
      name: 'productCode',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Can't find this product in the stock`
  String get cantFindProduct {
    return Intl.message(
      'Can\'t find this product in the stock',
      name: 'cantFindProduct',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get detail {
    return Intl.message(
      'Detail',
      name: 'detail',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Featured`
  String get featured {
    return Intl.message(
      'Featured',
      name: 'featured',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get credit {
    return Intl.message(
      'Credit',
      name: 'credit',
      desc: '',
      args: [],
    );
  }

  /// `Promotion`
  String get promotion {
    return Intl.message(
      'Promotion',
      name: 'promotion',
      desc: '',
      args: [],
    );
  }

  /// `Best sale`
  String get bestSale {
    return Intl.message(
      'Best sale',
      name: 'bestSale',
      desc: '',
      args: [],
    );
  }

  /// `New arrival`
  String get newArrival {
    return Intl.message(
      'New arrival',
      name: 'newArrival',
      desc: '',
      args: [],
    );
  }

  /// `Promotions`
  String get promotions {
    return Intl.message(
      'Promotions',
      name: 'promotions',
      desc: '',
      args: [],
    );
  }

  /// `Search for products`
  String get searchForProducts {
    return Intl.message(
      'Search for products',
      name: 'searchForProducts',
      desc: '',
      args: [],
    );
  }

  /// `Related products`
  String get relatedProducts {
    return Intl.message(
      'Related products',
      name: 'relatedProducts',
      desc: '',
      args: [],
    );
  }

  /// `GROCERIES`
  String get groceries1 {
    return Intl.message(
      'GROCERIES',
      name: 'groceries1',
      desc: '',
      args: [],
    );
  }

  /// `Shop all groceries`
  String get shopAllGroceries {
    return Intl.message(
      'Shop all groceries',
      name: 'shopAllGroceries',
      desc: '',
      args: [],
    );
  }

  /// `My favourites`
  String get myFavorite {
    return Intl.message(
      'My favourites',
      name: 'myFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Special for you`
  String get specialForYou {
    return Intl.message(
      'Special for you',
      name: 'specialForYou',
      desc: '',
      args: [],
    );
  }

  /// `My order`
  String get myOrder {
    return Intl.message(
      'My order',
      name: 'myOrder',
      desc: '',
      args: [],
    );
  }

  /// `My Cart`
  String get myCart {
    return Intl.message(
      'My Cart',
      name: 'myCart',
      desc: '',
      args: [],
    );
  }

  /// `Process order`
  String get processOrder {
    return Intl.message(
      'Process order',
      name: 'processOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delivery info`
  String get deliveryInfo {
    return Intl.message(
      'Delivery info',
      name: 'deliveryInfo',
      desc: '',
      args: [],
    );
  }

  /// `Deliver to`
  String get deliverTo {
    return Intl.message(
      'Deliver to',
      name: 'deliverTo',
      desc: '',
      args: [],
    );
  }

  /// `Full`
  String get full {
    return Intl.message(
      'Full',
      name: 'full',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery time`
  String get selectDeliveryTime {
    return Intl.message(
      'Select delivery time',
      name: 'selectDeliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Order summary`
  String get orderSummary {
    return Intl.message(
      'Order summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Voucher`
  String get voucher {
    return Intl.message(
      'Voucher',
      name: 'voucher',
      desc: '',
      args: [],
    );
  }

  /// `Voucher code`
  String get voucherCode {
    return Intl.message(
      'Voucher code',
      name: 'voucherCode',
      desc: '',
      args: [],
    );
  }

  /// `Voucher applied.`
  String get voucherApplied {
    return Intl.message(
      'Voucher applied.',
      name: 'voucherApplied',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Total items`
  String get totalItems {
    return Intl.message(
      'Total items',
      name: 'totalItems',
      desc: '',
      args: [],
    );
  }

  /// `Order value`
  String get orderValue {
    return Intl.message(
      'Order value',
      name: 'orderValue',
      desc: '',
      args: [],
    );
  }

  /// `Service fee`
  String get serviceFee {
    return Intl.message(
      'Service fee',
      name: 'serviceFee',
      desc: '',
      args: [],
    );
  }

  /// `Delivery fee`
  String get deliveryFee {
    return Intl.message(
      'Delivery fee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Discount voucher`
  String get discountVoucher {
    return Intl.message(
      'Discount voucher',
      name: 'discountVoucher',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `VAT`
  String get VAT {
    return Intl.message(
      'VAT',
      name: 'VAT',
      desc: '',
      args: [],
    );
  }

  /// `Grand total`
  String get grandTotal {
    return Intl.message(
      'Grand total',
      name: 'grandTotal',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Items list`
  String get itemsList {
    return Intl.message(
      'Items list',
      name: 'itemsList',
      desc: '',
      args: [],
    );
  }

  /// `Cancel order`
  String get cancelOrder {
    return Intl.message(
      'Cancel order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been cancelled.`
  String get cancelOrderSuccess {
    return Intl.message(
      'Your order has been cancelled.',
      name: 'cancelOrderSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Fail to cancel your order, please contact our customer service.`
  String get cancelOrderFail {
    return Intl.message(
      'Fail to cancel your order, please contact our customer service.',
      name: 'cancelOrderFail',
      desc: '',
      args: [],
    );
  }

  /// `We are processing your order, can not cancel it now, please contact our customer service.`
  String get cantCancelProcessingOrder {
    return Intl.message(
      'We are processing your order, can not cancel it now, please contact our customer service.',
      name: 'cantCancelProcessingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Place order`
  String get placeOrder {
    return Intl.message(
      'Place order',
      name: 'placeOrder',
      desc: '',
      args: [],
    );
  }

  /// `Error while placing your order.`
  String get placeOrderError {
    return Intl.message(
      'Error while placing your order.',
      name: 'placeOrderError',
      desc: '',
      args: [],
    );
  }

  /// `Your order is invalid (items/delivery slot/...)`
  String get invalidOrder {
    return Intl.message(
      'Your order is invalid (items/delivery slot/...)',
      name: 'invalidOrder',
      desc: '',
      args: [],
    );
  }

  /// `Some items in order are out of stock.`
  String get orderItemOutOfStock {
    return Intl.message(
      'Some items in order are out of stock.',
      name: 'orderItemOutOfStock',
      desc: '',
      args: [],
    );
  }

  /// `Order number`
  String get orderNumber {
    return Intl.message(
      'Order number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Thank you`
  String get thankYou {
    return Intl.message(
      'Thank you',
      name: 'thankYou',
      desc: '',
      args: [],
    );
  }

  /// `Your order is being placed.`
  String get yourOrderIsBeingPlaced {
    return Intl.message(
      'Your order is being placed.',
      name: 'yourOrderIsBeingPlaced',
      desc: '',
      args: [],
    );
  }

  /// `Please check`
  String get pleaseCheck1 {
    return Intl.message(
      'Please check',
      name: 'pleaseCheck1',
      desc: '',
      args: [],
    );
  }

  /// `menu for any update.`
  String get pleaseCheck2 {
    return Intl.message(
      'menu for any update.',
      name: 'pleaseCheck2',
      desc: '',
      args: [],
    );
  }

  /// `Pending orders`
  String get pendingOrders {
    return Intl.message(
      'Pending orders',
      name: 'pendingOrders',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed orders`
  String get confirmedOrders {
    return Intl.message(
      'Confirmed orders',
      name: 'confirmedOrders',
      desc: '',
      args: [],
    );
  }

  /// `Order confirmation`
  String get orderConfirmation {
    return Intl.message(
      'Order confirmation',
      name: 'orderConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Order status`
  String get orderStatus {
    return Intl.message(
      'Order status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Bought products`
  String get boughtProducts {
    return Intl.message(
      'Bought products',
      name: 'boughtProducts',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Personal details`
  String get personalDetails {
    return Intl.message(
      'Personal details',
      name: 'personalDetails',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Please provide us your date of birth. We'll have special offer on your birthday.`
  String get dateOfBirthNote {
    return Intl.message(
      'Please provide us your date of birth. We\'ll have special offer on your birthday.',
      name: 'dateOfBirthNote',
      desc: '',
      args: [],
    );
  }

  /// `Address details`
  String get addressDetails {
    return Intl.message(
      'Address details',
      name: 'addressDetails',
      desc: '',
      args: [],
    );
  }

  /// `House No.`
  String get houseNo {
    return Intl.message(
      'House No.',
      name: 'houseNo',
      desc: '',
      args: [],
    );
  }

  /// `st. name`
  String get streetName {
    return Intl.message(
      'st. name',
      name: 'streetName',
      desc: '',
      args: [],
    );
  }

  /// `Commune`
  String get commune {
    return Intl.message(
      'Commune',
      name: 'commune',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get currentPassword {
    return Intl.message(
      'Current password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPassword {
    return Intl.message(
      'New password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmNewPass {
    return Intl.message(
      'Confirm new password',
      name: 'confirmNewPass',
      desc: '',
      args: [],
    );
  }

  /// `Password changed`
  String get passwordChanged {
    return Intl.message(
      'Password changed',
      name: 'passwordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Please note we may not be servicing all areas yet. If you can't find your address in the options below contact us for help: $phoneNumber or Chat.`
  String get limitedServiceCoverageNote {
    return Intl.message(
      'Please note we may not be servicing all areas yet. If you can\'t find your address in the options below contact us for help: \$phoneNumber or Chat.',
      name: 'limitedServiceCoverageNote',
      desc: '',
      args: [],
    );
  }

  /// `Dmart24.com`
  String get domainDmart {
    return Intl.message(
      'Dmart24.com',
      name: 'domainDmart',
      desc: '',
      args: [],
    );
  }

  /// `My account`
  String get myAccount {
    return Intl.message(
      'My account',
      name: 'myAccount',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactUs {
    return Intl.message(
      'Contact us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `ខ្មែរ`
  String get langKhmer {
    return Intl.message(
      'ខ្មែរ',
      name: 'langKhmer',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get langEnglish {
    return Intl.message(
      'English',
      name: 'langEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Most Popular`
  String get mostPopular {
    return Intl.message(
      'Most Popular',
      name: 'mostPopular',
      desc: '',
      args: [],
    );
  }

  /// `Recent Reviews`
  String get recentReviews {
    return Intl.message(
      'Recent Reviews',
      name: 'recentReviews',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Register failed`
  String get registerError {
    return Intl.message(
      'Register failed',
      name: 'registerError',
      desc: '',
      args: [],
    );
  }

  /// `Reset your password`
  String get resetYourPass {
    return Intl.message(
      'Reset your password',
      name: 'resetYourPass',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `We will send a new password to your mobile phone.`
  String get weWillSendNewPass {
    return Intl.message(
      'We will send a new password to your mobile phone.',
      name: 'weWillSendNewPass',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the mobile number used to register with Dmart24.com and we will contact you shortly.`
  String get resetPassEnterPhoneNumber {
    return Intl.message(
      'Please enter the mobile number used to register with Dmart24.com and we will contact you shortly.',
      name: 'resetPassEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter OTP sent to your phone number, and new passwords`
  String get resetPassOtpSent {
    return Intl.message(
      'Please enter OTP sent to your phone number, and new passwords',
      name: 'resetPassOtpSent',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect phone number/email or password. Please check and try again.\nOr press on 'forgotten password' to reset your password.`
  String get loginErrorIncorrectPhonePassFullMsg {
    return Intl.message(
      'Incorrect phone number/email or password. Please check and try again.\nOr press on \'forgotten password\' to reset your password.',
      name: 'loginErrorIncorrectPhonePassFullMsg',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect phone number/email or password. Please check and try again.`
  String get loginErrorIncorrectPhonePass {
    return Intl.message(
      'Incorrect phone number/email or password. Please check and try again.',
      name: 'loginErrorIncorrectPhonePass',
      desc: '',
      args: [],
    );
  }

  /// `Or press on `
  String get loginError1 {
    return Intl.message(
      'Or press on ',
      name: 'loginError1',
      desc: '',
      args: [],
    );
  }

  /// `to reset your password.`
  String get loginError2 {
    return Intl.message(
      'to reset your password.',
      name: 'loginError2',
      desc: '',
      args: [],
    );
  }

  /// `Fail to login to FB. Please check your Facebook account`
  String get loginFbError {
    return Intl.message(
      'Fail to login to FB. Please check your Facebook account',
      name: 'loginFbError',
      desc: '',
      args: [],
    );
  }

  /// `You can use this account on Dmart24.com website and mobile app.`
  String get youCanUseThisAccountOnDmart24Web {
    return Intl.message(
      'You can use this account on Dmart24.com website and mobile app.',
      name: 'youCanUseThisAccountOnDmart24Web',
      desc: '',
      args: [],
    );
  }

  /// `Back to login.`
  String get backToLogin {
    return Intl.message(
      'Back to login.',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Verify phone number`
  String get verifyPhoneNo {
    return Intl.message(
      'Verify phone number',
      name: 'verifyPhoneNo',
      desc: '',
      args: [],
    );
  }

  /// `Order Id`
  String get orderId {
    return Intl.message(
      'Order Id',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message(
      'Brands',
      name: 'brands',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message(
      'Sort by',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Price increasing`
  String get priceIncreasing {
    return Intl.message(
      'Price increasing',
      name: 'priceIncreasing',
      desc: '',
      args: [],
    );
  }

  /// `Latest date`
  String get latestDate {
    return Intl.message(
      'Latest date',
      name: 'latestDate',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Or Checkout With`
  String get orCheckOutWith {
    return Intl.message(
      'Or Checkout With',
      name: 'orCheckOutWith',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message(
      'Subtotal',
      name: 'subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirmPayment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Products`
  String get favoriteProducts {
    return Intl.message(
      'Favorite Products',
      name: 'favoriteProducts',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Option`
  String get option {
    return Intl.message(
      'Option',
      name: 'option',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Faq`
  String get faq {
    return Intl.message(
      'Faq',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Help & Supports`
  String get helpAndSupports {
    return Intl.message(
      'Help & Supports',
      name: 'helpAndSupports',
      desc: '',
      args: [],
    );
  }

  /// `There is no Faq now. We will update soon. Stay tuned.`
  String get faqEmpty {
    return Intl.message(
      'There is no Faq now. We will update soon. Stay tuned.',
      name: 'faqEmpty',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get appLanguage {
    return Intl.message(
      'App Language',
      name: 'appLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Maps Explorer`
  String get maps_explorer {
    return Intl.message(
      'Maps Explorer',
      name: 'maps_explorer',
      desc: '',
      args: [],
    );
  }

  /// `All Products`
  String get allProduct {
    return Intl.message(
      'All Products',
      name: 'allProduct',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been successfully submitted!`
  String get orderSuccessfullySubmitted {
    return Intl.message(
      'Your order has been successfully submitted!',
      name: 'orderSuccessfullySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `TAX`
  String get tax {
    return Intl.message(
      'TAX',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message(
      'My Orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Cash on delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Recent Orders`
  String get recentOrders {
    return Intl.message(
      'Recent Orders',
      name: 'recentOrders',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Profile Settings`
  String get profileSettings {
    return Intl.message(
      'Profile Settings',
      name: 'profileSettings',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message(
      'Full name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone {
    return Intl.message(
      'Phone number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Phone number or email`
  String get phoneOrEmail {
    return Intl.message(
      'Phone number or email',
      name: 'phoneOrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Should be a valid email`
  String get shouldBeValidEmail {
    return Intl.message(
      'Should be a valid email',
      name: 'shouldBeValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Your password must contain at least 4 characters`
  String get passwordNote {
    return Intl.message(
      'Your password must contain at least 4 characters',
      name: 'passwordNote',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Mobile phone number`
  String get mobilePhoneNumber {
    return Intl.message(
      'Mobile phone number',
      name: 'mobilePhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `has already been registered. Just sign into it.`
  String get hasBeenReg {
    return Intl.message(
      'has already been registered. Just sign into it.',
      name: 'hasBeenReg',
      desc: '',
      args: [],
    );
  }

  /// `If you have forgotten your password. We can reset your password securely via SMS sent to your registered mobile phone number.`
  String get forgotPassResetMsg {
    return Intl.message(
      'If you have forgotten your password. We can reset your password securely via SMS sent to your registered mobile phone number.',
      name: 'forgotPassResetMsg',
      desc: '',
      args: [],
    );
  }

  /// `Mobile phone number and password.`
  String get mobileNoAndPass {
    return Intl.message(
      'Mobile phone number and password.',
      name: 'mobileNoAndPass',
      desc: '',
      args: [],
    );
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Please input 6 digits code.`
  String get input6digitCode {
    return Intl.message(
      'Please input 6 digits code.',
      name: 'input6digitCode',
      desc: '',
      args: [],
    );
  }

  /// `You should receive OTP code within 1 minute. If you experience more longer please contact us for help: 01234567`
  String get verifyOtpNote {
    return Intl.message(
      'You should receive OTP code within 1 minute. If you experience more longer please contact us for help: 01234567',
      name: 'verifyOtpNote',
      desc: '',
      args: [],
    );
  }

  /// `Your OTP expired in`
  String get otpExpiredIn {
    return Intl.message(
      'Your OTP expired in',
      name: 'otpExpiredIn',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `OTP resent`
  String get resendOtpSuccess {
    return Intl.message(
      'OTP resent',
      name: 'resendOtpSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Please note we might not be servicing all areas yet. If you can't find your address in the options below, please contact us for help: 012345678`
  String get locationNote {
    return Intl.message(
      'Please note we might not be servicing all areas yet. If you can\'t find your address in the options below, please contact us for help: 012345678',
      name: 'locationNote',
      desc: '',
      args: [],
    );
  }

  /// `Street`
  String get street {
    return Intl.message(
      'Street',
      name: 'street',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get district {
    return Intl.message(
      'District',
      name: 'district',
      desc: '',
      args: [],
    );
  }

  /// `Province`
  String get province {
    return Intl.message(
      'Province',
      name: 'province',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Not to tell`
  String get notToTell {
    return Intl.message(
      'Not to tell',
      name: 'notToTell',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `We need your registration details to deliver the services you are requesting from us.`
  String get personalDetailNote {
    return Intl.message(
      'We need your registration details to deliver the services you are requesting from us.',
      name: 'personalDetailNote',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Yes, register me`
  String get yesRegMe {
    return Intl.message(
      'Yes, register me',
      name: 'yesRegMe',
      desc: '',
      args: [],
    );
  }

  /// `Your mobile phone number is successfully registered.`
  String get yourPhoneRegOK {
    return Intl.message(
      'Your mobile phone number is successfully registered.',
      name: 'yourPhoneRegOK',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to `
  String get welcomeTo {
    return Intl.message(
      'Welcome to ',
      name: 'welcomeTo',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy your shopping.`
  String get enjoyShopping {
    return Intl.message(
      'Enjoy your shopping.',
      name: 'enjoyShopping',
      desc: '',
      args: [],
    );
  }

  /// `Multi-Stores`
  String get multiStores {
    return Intl.message(
      'Multi-Stores',
      name: 'multiStores',
      desc: '',
      args: [],
    );
  }

  /// `Tracking Order`
  String get trackingOrder {
    return Intl.message(
      'Tracking Order',
      name: 'trackingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Reset Cart?`
  String get resetCart {
    return Intl.message(
      'Reset Cart?',
      name: 'resetCart',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logout {
    return Intl.message(
      'Log out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Don't have any item in your cart`
  String get yourCartEmpty {
    return Intl.message(
      'Don\'t have any item in your cart',
      name: 'yourCartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Your favorite list is empty.`
  String get yourFavoriteEmpty {
    return Intl.message(
      'Your favorite list is empty.',
      name: 'yourFavoriteEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Don't have any item in the notification list`
  String get yourNotificationEmpty {
    return Intl.message(
      'Don\'t have any item in the notification list',
      name: 'yourNotificationEmpty',
      desc: '',
      args: [],
    );
  }

  /// `You have not bought any product.`
  String get yourBoughtProductsEmpty {
    return Intl.message(
      'You have not bought any product.',
      name: 'yourBoughtProductsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `You have no pending order.`
  String get yourPendingOrdersEmpty {
    return Intl.message(
      'You have no pending order.',
      name: 'yourPendingOrdersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `You have no confirmed order.`
  String get yourConfirmedOrdersEmpty {
    return Intl.message(
      'You have no confirmed order.',
      name: 'yourConfirmedOrdersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `You have no order.`
  String get yourOrdersEmpty {
    return Intl.message(
      'You have no order.',
      name: 'yourOrdersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `There is no products.`
  String get productListEmpty {
    return Intl.message(
      'There is no products.',
      name: 'productListEmpty',
      desc: '',
      args: [],
    );
  }

  /// `There is no products qualified with your criteria.`
  String get filteredProductListEmpty {
    return Intl.message(
      'There is no products qualified with your criteria.',
      name: 'filteredProductListEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Search result is empty.`
  String get searchResultEmpty {
    return Intl.message(
      'Search result is empty.',
      name: 'searchResultEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid number.`
  String get invalidNumber {
    return Intl.message(
      'Not a valid number.',
      name: 'invalidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid date.`
  String get invalidDate {
    return Intl.message(
      'Not a valid date.',
      name: 'invalidDate',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid delivery date & time.`
  String get invalidDeliveryDateTime {
    return Intl.message(
      'Not a valid delivery date & time.',
      name: 'invalidDeliveryDateTime',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid email.`
  String get invalidEmail {
    return Intl.message(
      'Not a valid email.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid phone.`
  String get invalidPhone {
    return Intl.message(
      'Not a valid phone.',
      name: 'invalidPhone',
      desc: '',
      args: [],
    );
  }

  /// `Invalid phone or email.`
  String get invalidPhoneOrEmail {
    return Intl.message(
      'Invalid phone or email.',
      name: 'invalidPhoneOrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Not a valid address.`
  String get invalidAddress {
    return Intl.message(
      'Not a valid address.',
      name: 'invalidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Invalid province`
  String get invalidProvince {
    return Intl.message(
      'Invalid province',
      name: 'invalidProvince',
      desc: '',
      args: [],
    );
  }

  /// `Invalid district`
  String get invalidDistrict {
    return Intl.message(
      'Invalid district',
      name: 'invalidDistrict',
      desc: '',
      args: [],
    );
  }

  /// `Invalid ward`
  String get invalidWard {
    return Intl.message(
      'Invalid ward',
      name: 'invalidWard',
      desc: '',
      args: [],
    );
  }

  /// `Invalid gender`
  String get invalidGender {
    return Intl.message(
      'Invalid gender',
      name: 'invalidGender',
      desc: '',
      args: [],
    );
  }

  /// `Invalid voucher.`
  String get invalidVoucher {
    return Intl.message(
      'Invalid voucher.',
      name: 'invalidVoucher',
      desc: '',
      args: [],
    );
  }

  /// `Invalid name.`
  String get invalidName {
    return Intl.message(
      'Invalid name.',
      name: 'invalidName',
      desc: '',
      args: [],
    );
  }

  /// `Invalid full name.`
  String get invalidFullName {
    return Intl.message(
      'Invalid full name.',
      name: 'invalidFullName',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP`
  String get invalidOTP {
    return Intl.message(
      'Invalid OTP',
      name: 'invalidOTP',
      desc: '',
      args: [],
    );
  }

  /// `Your Address`
  String get yourAddress {
    return Intl.message(
      'Your Address',
      name: 'yourAddress',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Recent Searches`
  String get recentSearches {
    return Intl.message(
      'Recent Searches',
      name: 'recentSearches',
      desc: '',
      args: [],
    );
  }

  /// `Verify your internet connection.`
  String get verifyYourInternetConnection {
    return Intl.message(
      'Verify your internet connection.',
      name: 'verifyYourInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Carts refreshed successfully.`
  String get cartsRefreshedSuccessfully {
    return Intl.message(
      'Carts refreshed successfully.',
      name: 'cartsRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `The $productName was removed from your cart.`
  String get productRemovedFromCart {
    return Intl.message(
      'The \$productName was removed from your cart.',
      name: 'productRemovedFromCart',
      desc: '',
      args: [],
    );
  }

  /// `The $productName was removed from your favorite.`
  String get productRemovedFromFavorite {
    return Intl.message(
      'The \$productName was removed from your favorite.',
      name: 'productRemovedFromFavorite',
      desc: '',
      args: [],
    );
  }

  /// `Category refreshed successfully.`
  String get categoryRefreshedSuccessfully {
    return Intl.message(
      'Category refreshed successfully.',
      name: 'categoryRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Notifications refreshed successfully`
  String get notificationsRefreshedSuccessfully {
    return Intl.message(
      'Notifications refreshed successfully',
      name: 'notificationsRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Order refreshed successfully`
  String get orderRefreshedSuccessfully {
    return Intl.message(
      'Order refreshed successfully',
      name: 'orderRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Orders refreshed successfully`
  String get ordersRefreshedSuccessfully {
    return Intl.message(
      'Orders refreshed successfully',
      name: 'ordersRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Brand refreshed successfully`
  String get brandRefreshedSuccessfully {
    return Intl.message(
      'Brand refreshed successfully',
      name: 'brandRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Profile settings updated successfully`
  String get profileSettingsUpdatedSuccessfully {
    return Intl.message(
      'Profile settings updated successfully',
      name: 'profileSettingsUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your information updated.`
  String get accountInfoUpdated {
    return Intl.message(
      'Your information updated.',
      name: 'accountInfoUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email or password`
  String get wrongEmailOrPassword {
    return Intl.message(
      'Wrong email or password',
      name: 'wrongEmailOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Addresses refreshed successfully`
  String get addressesRefreshedSuccessfully {
    return Intl.message(
      'Addresses refreshed successfully',
      name: 'addressesRefreshedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Addresses`
  String get deliveryAddresses {
    return Intl.message(
      'Delivery Addresses',
      name: 'deliveryAddresses',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete delivery address?`
  String get plsConfirmDeleteAddress {
    return Intl.message(
      'Are you sure to delete delivery address?',
      name: 'plsConfirmDeleteAddress',
      desc: '',
      args: [],
    );
  }

  /// `Use this address`
  String get useThisAddr {
    return Intl.message(
      'Use this address',
      name: 'useThisAddr',
      desc: '',
      args: [],
    );
  }

  /// `Please select delivery address`
  String get selectDeliveryAddress {
    return Intl.message(
      'Please select delivery address',
      name: 'selectDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `New Address added successfully`
  String get newAddressAdded {
    return Intl.message(
      'New Address added successfully',
      name: 'newAddressAdded',
      desc: '',
      args: [],
    );
  }

  /// `The address updated successfully`
  String get addressUpdated {
    return Intl.message(
      'The address updated successfully',
      name: 'addressUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Add Delivery Address`
  String get addDeliveryAddress {
    return Intl.message(
      'Add Delivery Address',
      name: 'addDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any delivery address.`
  String get addressesEmpty {
    return Intl.message(
      'You don\'t have any delivery address.',
      name: 'addressesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Default delivery address`
  String get defaultDeliveryAddress {
    return Intl.message(
      'Default delivery address',
      name: 'defaultDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Home Address`
  String get homeAddress {
    return Intl.message(
      'Home Address',
      name: 'homeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Full Address`
  String get fullAddress {
    return Intl.message(
      'Full Address',
      name: 'fullAddress',
      desc: '',
      args: [],
    );
  }

  /// `Send link`
  String get sendLink {
    return Intl.message(
      'Send link',
      name: 'sendLink',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `You must sign-in to access to this section`
  String get youMustSignToSeeThisSection {
    return Intl.message(
      'You must sign-in to access to this section',
      name: 'youMustSignToSeeThisSection',
      desc: '',
      args: [],
    );
  }

  /// `Order status changed`
  String get orderStatusChanged {
    return Intl.message(
      'Order status changed',
      name: 'orderStatusChanged',
      desc: '',
      args: [],
    );
  }

  /// `Shopping`
  String get shopping {
    return Intl.message(
      'Shopping',
      name: 'shopping',
      desc: '',
      args: [],
    );
  }

  /// `Start shopping`
  String get startShopping {
    return Intl.message(
      'Start shopping',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `Delivery or Pickup`
  String get deliveryPickup {
    return Intl.message(
      'Delivery or Pickup',
      name: 'deliveryPickup',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Pickup`
  String get pickup {
    return Intl.message(
      'Pickup',
      name: 'pickup',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get closed {
    return Intl.message(
      'Closed',
      name: 'closed',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Km`
  String get km {
    return Intl.message(
      'Km',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Current location`
  String get currentLocation {
    return Intl.message(
      'Current location',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address removed successfully`
  String get deliveryAddressRemovedSuccessfully {
    return Intl.message(
      'Delivery Address removed successfully',
      name: 'deliveryAddressRemovedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Add new shipping address`
  String get addNewDeliveryAddress {
    return Intl.message(
      'Add new shipping address',
      name: 'addNewDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your shipping address`
  String get confirmYourDeliveryAddress {
    return Intl.message(
      'Confirm your shipping address',
      name: 'confirmYourDeliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Fields`
  String get fields {
    return Intl.message(
      'Fields',
      name: 'fields',
      desc: '',
      args: [],
    );
  }

  /// `This product was added to cart`
  String get productAdded2Cart {
    return Intl.message(
      'This product was added to cart',
      name: 'productAdded2Cart',
      desc: '',
      args: [],
    );
  }

  /// `Products result`
  String get productsResult {
    return Intl.message(
      'Products result',
      name: 'productsResult',
      desc: '',
      args: [],
    );
  }

  /// `Products Results`
  String get productsResults {
    return Intl.message(
      'Products Results',
      name: 'productsResults',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `This email account exists`
  String get emailAccountExists {
    return Intl.message(
      'This email account exists',
      name: 'emailAccountExists',
      desc: '',
      args: [],
    );
  }

  /// `This account not exist`
  String get accountNotExist {
    return Intl.message(
      'This account not exist',
      name: 'accountNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Account`
  String get verifyYourAccount {
    return Intl.message(
      'Verify Your Account',
      name: 'verifyYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Product Reviews`
  String get productReviews {
    return Intl.message(
      'Product Reviews',
      name: 'productReviews',
      desc: '',
      args: [],
    );
  }

  /// `Make it default`
  String get makeItDefault {
    return Intl.message(
      'Make it default',
      name: 'makeItDefault',
      desc: '',
      args: [],
    );
  }

  /// `Unpaid`
  String get unpaid {
    return Intl.message(
      'Unpaid',
      name: 'unpaid',
      desc: '',
      args: [],
    );
  }

  /// `Tap back again to quit`
  String get tapBackAgainToQuit {
    return Intl.message(
      'Tap back again to quit',
      name: 'tapBackAgainToQuit',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
