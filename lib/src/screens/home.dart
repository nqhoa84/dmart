import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/models/user.dart';

import '../../route_generator.dart';
import '../../src/widgets/ProductsGridLoadingWidget.dart';
import '../widgets/BrandedProductsWidget.dart';
import '../widgets/DeliveryAddressBottomSheetWidget.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import '../../src/controllers/home_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/widgets/HomeProductsByCategory.dart';
import '../../src/widgets/HomePromotionsSlider.dart';
import '../../src/widgets/SearchBar.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> with SingleTickerProviderStateMixin {
  Animation animationOpacity;
  AnimationController animationController;
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForTrendingProducts();
    _con.listenForCategories();
    _con.listenForBrands();
    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: createAppBar(),
      body: RefreshIndicator(
        onRefresh: _con.refreshHome,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _createHeader(title: S.of(context).promotions, backgroundColor: DmConst.homePromotionColor,
              onTap: () {
                RouteGenerator.gotoPromotions(context, replaceOld: true);
              }),
              HomePromotionsSlider(),
//              FlashSalesHeaderWidget(),
//              _createHeader(S.of(context).trending_this_week),
//              _con.categorySelected == null
//                  ? ProductsGridLoadingWidget()
//                  : CategorizedProductsWidget(
//                  animationOpacity: animationOpacity,
//                  category: _con.categorySelected),
//              // Heading (Recommended for you)
              _createHeader(title: S.of(context).bestSale),
              _con.categorySelected == null
                  ? ProductsGridLoadingWidget()
                  : HomeProductsByCategory(animationOpacity: animationOpacity, category: _con.categorySelected),
              // Heading (Brands)
              _createHeader(title: S.of(context).newArrival),
              _con.brandSelected == null
                  ? ProductsGridLoadingWidget()
                  : BrandedProductsWidget(animationOpacity: animationOpacity, brand: _con.brandSelected),
              _createHeader(title: S.of(context).specialForYou),
              _con.brandSelected == null
                  ? ProductsGridLoadingWidget()
                  : BrandedProductsWidget(animationOpacity: animationOpacity, brand: _con.brandSelected,
              heroTag: 'spe4u',),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createHeader({String title, Color backgroundColor = DmConst.accentColor,
    Function() onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity, height: DmConst.appBarHeight * 0.7,
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Center(child: Text(title,
                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white)
          ],
        ),
      ),
    );
  }

  PreferredSize createAppBar() {
    User user = currentUser.value;
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
                    child: this._createUserInfoRowOnTopBar(user),
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
                        child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 4, thickness: 2, color: DmConst.accentColor),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                child: SearchBar(onClickFilter: (event) {
                  widget.parentScaffoldKey.currentState.openEndDrawer();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createUserInfoRowOnTopBar(User user) {
    if (user.isLogin) {
      return Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.network(
              user.image?.thumb,
              loadingBuilder: (ctx, wid, event) {
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (ctx, obj, trace) {
                return Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown);
              },
            ),
//            Image.asset('assets/img/H_User_Icon.png',
//                width: 40, height: 40, fit: BoxFit.scaleDown),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(user.name ?? S.of(context).unknown),
              Text('${S.of(context).credit}: ${currentUser.value.credit}',
                  style: TextStyle(color: DmConst.textColorForTopBarCredit)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).guest),
              Text('${S.of(context).credit}:'),
            ],
          ),
        ],
      );
    }
  }

  _createLocationButton() {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsetsDirectional.only(start: 0, end: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(300),
        onTap: () {
          if (currentUser.value.apiToken == null) {
            _con.requestForCurrentLocation(context);
          } else {
            var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
              (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: widget.parentScaffoldKey),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
            );
            bottomSheetController.closed.then((value) {
              _con.refreshHome();
            });
          }
        },
        child: Icon(
          UiIcons.map,
          color: Theme.of(context).hintColor,
          size: 28,
        ),
      ),
    );
  }
}
