import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/product_controller.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/models/order_status.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/screens/contactus.dart';
import 'package:dmart/src/screens/order_detail.dart';
import 'package:dmart/src/widgets/CircularLoadingWidget.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/ProductItemWide.dart';
import 'package:dmart/src/widgets/ProductsByCategory.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';
import '../widgets/OrdersListWidget.dart';
import '../widgets/ShoppingCartButton.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends StateMVC<OrdersScreen> {
  OrderController _con;

//  ProductController _pCon = ProductController();
  _OrdersScreenState() : super(OrderController()) {
    _con = controller;
    _con.scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    _con.listenForOrders();

    _con.listenForBoughtProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
//        appBar: createAppBar(context, _con.scaffoldKey),
        bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        drawer: DrawerWidget(),
        body: SafeArea(
          child: RefreshIndicator(
              onRefresh: _con.refreshOrders,
              child: CustomScrollView(
                slivers: [
                  createSliverTopBar(context),
                  createSliverSearch(context),
                  createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).myOrders),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ExpansionPanelList(
                        expansionCallback: (int idx, bool expanded) {
                          setState(() {
                            if (idx == 0)
                              expPending = !expPending;
                            else if (idx == 1)
                              expConfirm = !expConfirm;
                            else if (idx == 2) expHistory = !expHistory;
                          });
                        },
//                      expandedHeaderPadding: EdgeInsets.all(0),
                        animationDuration: Duration(seconds: 1),
                        children: [
//                          _buildPendingOrders(),
                          _buildOrders(_con.pendingOrders, S.of(context).pendingOrders,
                              S.of(context).yourPendingOrdersEmpty, expPending),
//                          _buildConfirmOrders(),
                          _buildOrders(_con.confirmedOrders, S.of(context).confirmedOrders,
                              S.of(context).yourConfirmedOrdersEmpty, expConfirm),
//                          _buildHistory(),
                          _buildOrders(_con.historyOrders, S.of(context).history,
                              S.of(context).yourOrdersEmpty, expHistory),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                        child: TitleDivider(title: S.of(context).boughtProducts),
                      ),
                      buildBoughPro(),
                    ]),
                  )
                ],
              )),
        ));
  }

  Widget buildBoughPro() {
    if (_con.boughtProducts == null) return Center(child: CircularProgressIndicator());
    if (_con.boughtProducts.isEmpty)
      return EmptyDataLoginWid(message: S.of(context).yourBoughtProductsEmpty);
    else
      return ProductGridView(products: _con.boughtProducts, heroTag: 'boughPro');
  }

  bool expPending = false;

  ExpansionPanel _buildPendingOrders(List<Order> ods, String emptyText) {
    if (_con.pendingOrders == null || _con.pendingOrders.isEmpty) {
      return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return TitleDivider(title: S.of(context).pendingOrders);
          },
          body: Padding(
            padding: const EdgeInsets.only(left: DmConst.masterHorizontalPad, right: DmConst.masterHorizontalPad),
            child: ListTile(
              leading: Icon(Icons.info, color: DmConst.accentColor),
              title: Text(S.of(context).yourPendingOrdersEmpty),
            ),
          ),
          isExpanded: expPending,
          canTapOnHeader: true);
    }
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: S.of(context).pendingOrders);
        },
        body: Padding(
//          padding: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(left: DmConst.masterHorizontalPad, right: DmConst.masterHorizontalPad),
          child: Column(
            children: List.generate(_con.pendingOrders.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: _con.pendingOrders[index]),
              );
            }),
//            children: [
//              Padding(
//                padding: const EdgeInsets.only(bottom: 8.0),
//                child: buildOrderItem(order: Order()..orderStatus=OrderStatus.Created),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 8.0),
//                child: buildOrderItem(order: Order()..orderStatus=OrderStatus.Created),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(bottom: 8.0),
//                child: buildOrderItem(order: Order()..orderStatus=OrderStatus.Created),
//              ),
//            ],
          ),
        ),
        isExpanded: expPending,
        canTapOnHeader: true);
  }

  ExpansionPanel _buildOrders(List<Order> ods, String headerText, String emptyText, bool isExpanded) {
    if (ods == null || ods.isEmpty) {
      return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return TitleDivider(title: headerText);
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
            child: ListTile(
              leading: Icon(Icons.info, color: DmConst.accentColor),
              title: Text(emptyText),
            ),
          ),
          isExpanded: isExpanded,
          canTapOnHeader: true);
    }
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: headerText);
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
          child: Column(
            children: List.generate(ods.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: ods[index]),
              );
            }),
          ),
        ),
        isExpanded: isExpanded,
        canTapOnHeader: true);
  }

  String _formatDate(DateTime date) {
    DateFormat dateFmt = DateFormat('E\ndd\nMMM');
    return date != null ? dateFmt.format(date).toUpperCase() : '';
  }


  Container buildOrderItem({Order order}) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: createRoundedBorderBoxDecoration(radius: 5, borderWidth: 1),
      child: ListTile(
        onTap:() => _onTapOnOrderItem(order),
        leading: Container(
            decoration: createRoundedBorderBoxDecoration(radius: 5, borderWidth: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(_formatDate(order.createdDate), textAlign: TextAlign.center),
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
                Expanded(child: Text('${getStatusName(order.orderStatus)}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.of(context).orderNumber}')),
                Text(': '),
                Expanded(child: Text('${order.id}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.of(context).orderValue}')),
                Text(': '),
                Expanded(child: Text('${getDisplayMoney(order.orderVal)}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.of(context).totalItems}')),
                Text(': '),
                Expanded(child: Text('${order.totalItems}')),
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
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.approved),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.approved),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.approved),
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
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.created),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.approved),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.rejected),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: Order()..orderStatus = OrderStatus.canceled),
              ),
            ],
          ),
        ),
        isExpanded: expHistory,
        canTapOnHeader: true);
  }

  Widget _build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
//        appBar: createAppBar(context, _con.scaffoldKey),
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
                          if (idx == 0)
                            expPending = !expPending;
                          else if (idx == 1)
                            expConfirm = !expConfirm;
                          else if (idx == 2) expHistory = !expHistory;
                        });
                      },
//                      expandedHeaderPadding: EdgeInsets.all(0),
                      animationDuration: Duration(seconds: 1),
                      children: [
//                        _buildPendingOrders(),
//                        _buildConfirmOrders(),
//                        _buildHistory(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TitleDivider(title: S.of(context).boughtProducts),
                    ),
                    _con.boughtProducts.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ProductGridView(products: _con.boughtProducts, heroTag: 'boughPro')
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

  String getStatusName(OrderStatus orderStatus) {
    switch(orderStatus) {
      case OrderStatus.created:
        return S.of(context).created;
      case OrderStatus.canceled:
        return S.of(context).canceled;
      case OrderStatus.denied:
        return S.of(context).denied;
      case OrderStatus.approved:
        return S.of(context).approved;
      case OrderStatus.deliverFailed:
        return S.of(context).deliverFailed;
      case OrderStatus.delivering:
        return S.of(context).delivering;
      case OrderStatus.preparing:
        return S.of(context).preparing;
      case OrderStatus.delivered:
        return S.of(context).delivered;
      case OrderStatus.confirmed:
        return S.of(context).confirmed;
      case OrderStatus.rejected:
        return S.of(context).rejected;
      case OrderStatus.unknown:
        return S.of(context).unknown;
      default: return '';
    }
  }

  void _onTapOnOrderItem(Order order) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailScreen(order)));
  }
}
