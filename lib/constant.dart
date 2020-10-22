import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DmConst {
  ///dateFormat = 'yyyy-MM-dd';
  static const String dateFormat = 'yyyy-MM-dd';

  ///'yyyy-MM-dd HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static final DateFormat datetimeFormatter = DateFormat(dateTimeFormat);
  static final DateFormat dateFormatter = DateFormat(dateFormat);


  static const Color accentColor = Color(0xff1DA5BE);
  static Color textColorForTopBar = Color(0xff1DA5BE);
  static Color textColorForTopBarCredit = Color(0xff8000FF);
  static Color colorFavorite = Color(0xff8000FF);
  static Color textColorPromotionPrice = Color(0xff8000FF);
  static Color textColorForTopBarCartItem = Color(0xff333333);
  static Color textColorSearchBar = Color(0xff808080);
  static Color bgrColorSearchBar = Color(0xffE6E6E6);
  static const appBarHeight = kToolbarHeight;

  static Color homePromotionColor = Color(0xff8000FF);

  static Color productShadowColor = Color(0x808000FF);
  static Color bgrColorBottomBarProductDetail = Color(0xffE6E6E6);

  static const double masterHorizontalPad = 10;

  ///'assets/img/H_Logo_Dmart.png'
  static const String assetImgLogo = 'assets/img/H_Logo_Dmart.png';

  ///'assets/img/H_Cart.png'
  static const String assetImgCart = 'assets/img/H_Cart.png';

  ///'assets/img/H_User_Icon.png'
  static const String assetImgUserIcon = 'assets/img/H_User_Icon.png';

  ///'assets/img/H_User_Icon.png'
  static const String assetImgUserThumbUp = 'assets/img/ThumUp.png';

}
