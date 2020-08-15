import 'package:dmart/constant.dart';

import '../../src/widgets/BrandsIconsCarouselLoadingWidget.dart';

//import '../../src/widgets/ProductsGridLoadingWidget.dart';
import '../../src/widgets/CategoriesIconsCarouselLoadingWidget.dart';
import '../widgets/BrandedProductsWidget.dart';
import '../widgets/DeliveryAddressBottomSheetWidget.dart';
import '../../generated/l10n.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/widgets/BrandsIconsCarouselWidget.dart';
import '../../src/widgets/CategoriesIconsCarouselWidget.dart';
//import '../../src/widgets/DmCategorizedProductsWidget.dart';
import '../../src/widgets/FlashSalesCarouselWidget.dart';
import '../../src/widgets/FlashSalesWidget.dart';
import '../../src/widgets/HomeSliderWidget.dart';
import '../../src/widgets/SearchBarWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class DmTopBar extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const DmTopBar({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _DmTopBarState createState() => _DmTopBarState();
}

class _DmTopBarState extends State<DmTopBar>{

  _DmTopBarState();

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(110),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,

//          centerTitle: true,
//          title: Column(
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//
//                Expanded(
//                  child: Row(
//                    children: <Widget>[
//                      CircleAvatar(
//                        backgroundColor: Colors.transparent,
//                        backgroundImage: AssetImage('assets/img/H_User_Icon.png'),
////                child: Image.asset('assets/img/H_User_Icon.png',
////                    width: 80,
////                    fit: BoxFit.scaleDown),
//                      ),
//                      Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                        Text('Username'),
//                        Text('Credit'),
//                      ],),
//                    ],
//                  ),
//                ),
//                Container(
//                  child: Image.asset(
//                    'assets/img/H_Logo_Dmart.png',
//                    width: 44, height: 44,
//                    fit: BoxFit.scaleDown,
//                  ),
//                ),
//                  Expanded(
//                    child: Align(
//                      alignment: Alignment.centerRight,
//                      child: Container(
//                        padding: EdgeInsets.only(right: 30),
//                        height: 40,
//                        child: Image.asset('assets/img/H_Cart.png',
//                            fit: BoxFit.scaleDown),
//                      ),
//                    ),
//                  ),
//              ],),
////              Divider(thickness: 2, color: DmConst.primaryColor)
//            ],
//          ),
//          bottom: PreferredSize(
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: SearchBarWidget( onClickFilter: (event) {
//                  widget.parentScaffoldKey.currentState.openEndDrawer();
//                }),
//              ),
//              preferredSize: Size.fromHeight(40)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
//                            backgroundImage: AssetImage('assets/img/H_User_Icon.png'),
                          child: Image.asset('assets/img/H_User_Icon.png',
                              width: 40, height: 40, fit: BoxFit.scaleDown),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Username',),
                            Text('${S.of(context).topBar_credit}: ${currentUser.value.credit}',
                                style: TextStyle(color: DmConst.textColorForTopBarCredit)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      'assets/img/H_Logo_Dmart.png',
                      width: 46,
                      height: 46,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        height: 40,
                        child: Image.asset('assets/img/H_Cart.png',
                            fit: BoxFit.scaleDown),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 4, thickness: 2, color: DmConst.primaryColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                child: SearchBarWidget(onClickFilter: (event) {
                  widget.parentScaffoldKey.currentState.openEndDrawer();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
