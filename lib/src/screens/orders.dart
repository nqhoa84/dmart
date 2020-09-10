import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/models/order_status.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/screens/contactus.dart';
import 'package:dmart/src/widgets/CircularLoadingWidget.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:dmart/src/widgets/ProductsByCategory.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';
import '../widgets/OrdersListWidget.dart';
import '../widgets/ShoppingCartButton.dart';

class OrderScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final int currentTab = 0;

  OrderScreen({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends StateMVC<OrderScreen> {
  OrderController _con;

//  ProductController _pCon = ProductController();
  _OrderScreenState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrders();
//    _pCon.listenForBoughtProducts(onDone: () {
//      setState(() {
//        print('boughtProducts ${_pCon.boughtProducts.length}');
//      });
//    });
    _con.listenForBoughtProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: createAppBar(context, _con.scaffoldKey),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        drawer: DrawerWidget(),
        body: RefreshIndicator(
            onRefresh: _con.refreshOrders,
            child: CustomScrollView(
              slivers: [
                createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).myOrders),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ExpansionPanelList(
                      expansionCallback: (int idx, bool expanded) {
                        setState(() {
                         if(idx == 0) expPending = !expPending;
                         else if (idx == 1) expConfirm = !expConfirm;
                         else if (idx == 2) expHistory = !expHistory;
                        });
                      },
//                      expandedHeaderPadding: EdgeInsets.all(0),
                      animationDuration: Duration(seconds: 1),
                      children: [
                        _buildPendingOrders(),
                        _buildConfirmOrders(),
                        _buildHistory(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TitleDivider(title: S.of(context).boughtProducts),
                    ),
                    _con.boughtProducts.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : createGridViewOfProducts(context, _con.boughtProducts)
                    //todo change to bought products from api
                    // ProductsByCategory(category: Category(id: '1', name: 'Bought', description: 'Many kinds of fruits'))
                  ]),
                )
//            ExpansionPanelList(
//              expansionCallback: (int index, bool isExpanded) {
//                setState(() {
//                  items[index].isExpanded = !items[index].isExpanded;
//                });
//              },
//              children: items.map((NewItem item) {
//                return ExpansionPanel(
//                  headerBuilder: (BuildContext context, bool isExpanded) {
//                    return  ListTile(
//                        leading: item.iconpic,
//                        title:  Text(
//                          item.header,
//                          textAlign: TextAlign.left,
//                          style:  TextStyle(
//                            fontSize: 20.0,
//                            fontWeight: FontWeight.w400,
//                          ),
//                        )
//                    );
//                  },
//                  isExpanded: item.isExpanded,
//                  body: item.body,
//                );
//              }).toList(),
//            ),
              ],
            )));
  }

  bool expPending = false;
  ExpansionPanel _buildPendingOrders() {
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: S.of(context).pendingOrders);
        },
        body: Padding(
          padding: const EdgeInsets.only(
              left: DmConst.masterHorizontalPad,
              right: DmConst.masterHorizontalPad),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Pending'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Pending'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Pending'))),
              ),
            ],
          ),
        ),
        isExpanded: expPending,
        canTapOnHeader: true);
  }

  Container buildOrderItem({Order order}) {
    return Container(
          padding: EdgeInsets.all(8),
          decoration: createRoundedBorderBoxDecoration(radius: 5, borderWidth: 1),
          child: ListTile(
//              contentPadding: EdgeInsets.all(8),
            leading: Container(
              decoration: createRoundedBorderBoxDecoration(radius: 5, borderWidth: 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('SAT\n29\nAUG', textAlign: TextAlign.center),
                )),
          trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).accentColor),
            isThreeLine: false,
            subtitle: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text('${S.of(context).orderStatus}')),
                    Text(': '),
                    Expanded(child: Text('${S.of(context).delivering}')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text('${S.of(context).orderNumber}')),
                    Text(': '),
                    Expanded(child: Text('xxxxxxxxxx')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text('${S.of(context).orderValue}')),
                    Text(': '),
                    Expanded(child: Text('\$xx.xx')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Text('${S.of(context).totalItems}')),
                    Text(': '),
                    Expanded(child: Text('xx')),
                  ],
                ),
              ],
            ),
          ),
        );
  }

  bool expConfirm = false;
  ExpansionPanel _buildConfirmOrders() {
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: S.of(context).confirmedOrders);
        },
        body: Padding(
          padding: const EdgeInsets.only(
              left: DmConst.masterHorizontalPad,
              right: DmConst.masterHorizontalPad,
              bottom: DmConst.masterHorizontalPad),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Confirmed'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Confirmed'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Confirmed'))),
              ),
            ],
          ),
        ),
        isExpanded: expConfirm,
        canTapOnHeader: true);
  }

  bool expHistory = false;
  ExpansionPanel _buildHistory() {
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: S.of(context).history);
        },
        body: Padding(
          padding: const EdgeInsets.only(
              left: DmConst.masterHorizontalPad,
              right: DmConst.masterHorizontalPad,
              bottom: DmConst.masterHorizontalPad),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Pending'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Confirmed'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Rejected'))),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order(orderStatus: OrderStatus(status: 'Canceled'))),
              ),
            ],
          ),
        ),
        isExpanded: expHistory,
        canTapOnHeader: true);
  }


}
