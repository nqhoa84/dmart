import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/screens/contactus.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/ProductsByCategory.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class OrderSuccessScreen extends StatefulWidget {
  final RouteArgument routeArgument;

  final String orderNo; 
  
  OrderSuccessScreen({Key key, this.routeArgument, this.orderNo = '123456789'}) : super(key: key);

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends StateMVC<OrderSuccessScreen> {
  CheckoutController _con;

  _OrderSuccessScreenState() : super(CheckoutController()) {
    _con = controller;
  }

  @override
  void initState() {
    // route param contains the payment method
//    _con.payment = new Payment(widget.routeArgument.param);
//    _con.listenForCarts(withAddOrder: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: createAppBar(context, _con.scaffoldKey),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: 4),
        body: SingleChildScrollView(
          child: Column(
            children: [
              createTitleRowWithBack(context, title: S.of(context).orderConfirmation, showBack: false),
              Padding(
                padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                child: TitleDivider(title: S.of(context).orderId + "xxxxxxx"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
                child: Container(
                  decoration: createRoundedBorderBoxDecoration(),
                  child: ListTile(
                    leading: Image.asset('assets/img/Thanks.png', fit: BoxFit.scaleDown),
                    title: Text(S.of(context).thankYou.toUpperCase() + "\n" + S.of(context).yourOrderIsBeingPlaced),
                    subtitle: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                      Text(S.of(context).pleaseCheck1),
                      FlatButton.icon(icon: Icon(UiIcons.edit, color: Theme.of(context).accentColor),
                          label: Text(S.of(context).myOrders, style: TextStyle(color: Theme.of(context).accentColor),),
                        onPressed: () => RouteGenerator.gotoMyOrders(context, replaceOld: true)
                      ),
                        Text(S.of(context).pleaseCheck2),
                    ],),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                child: TitleDivider(title: S.of(context).specialForYou),
              ),
              Padding(
                padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                child: ProductsByCategory(category: Category(id: 1, name: 'name', description: 'desc')),
              ),
            ],
          ),
        ));
  }

  Widget _create(BuildContext context){
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                          Colors.green.withOpacity(1),
                          Colors.green.withOpacity(0.2),
                        ])),
                    child: _con.loading
                        ? Padding(
                      padding: EdgeInsets.all(55),
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).scaffoldBackgroundColor),
                      ),
                    )
                        : Icon(
                      Icons.check,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 90,
                    ),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.4,
                child: Text(
                  S.of(context).orderSuccessfullySubmitted,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: 265,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).subtotal,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.subTotal, context, style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  SizedBox(height: 3),
                  _con.payment.method == 'Pay on Pickup'
                      ? SizedBox(height: 0)
                      : Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).deliveryFee,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.carts[0].product.store.deliveryFee, context, style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${S.of(context).tax} (${_con.carts[0].product.store.defaultTax}%)",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subtitle1)
                    ],
                  ),
                  Divider(height: 30),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          S.of(context).total,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.headline6)
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 3);
                      },
                      padding: EdgeInsets.symmetric(vertical: 14),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                      child: Text(
                        S.of(context).myOrders,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
