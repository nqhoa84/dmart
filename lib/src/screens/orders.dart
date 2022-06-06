import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/models/order.dart';
import 'package:dmart/src/models/order_status.dart';
import 'package:dmart/src/screens/order_detail.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:dmart/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends StateMVC<OrdersScreen> {
  OrderController _con = OrderController();

//  ProductController _pCon = ProductController();
  _OrdersScreenState() : super(OrderController()) {
    _con = controller as OrderController;
    _con.scaffoldKey = GlobalKey<ScaffoldState>();

    _pendingExpCtrl = ExpandableController(initialExpanded: false);
    this._pendingExpCtrl!.expanded = false;

    _confirmExpCtrl = ExpandableController(initialExpanded: false);
    this._confirmExpCtrl!.expanded = false;

    _historyExpCtrl = ExpandableController(initialExpanded: false);
    this._historyExpCtrl!.expanded = false;
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
        bottomNavigationBar:
            DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
        drawer: DrawerWidget(),
        body: WillPopScope(
          onWillPop: () async => false,
          child: SafeArea(
            child: RefreshIndicator(
                onRefresh: _con.refreshOrders,
                child: CustomScrollView(
                  slivers: [
                    createSliverTopBar(context),
                    createSliverSearch(context),
                    createSilverTopMenu(context,
                        haveBackIcon: true, title: S.current.myOrders),
                    SliverPadding(
                      padding: EdgeInsets.all(DmConst.masterHorizontalPad),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
//                         ExpansionPanelList(
//                           expansionCallback: (int idx, bool expanded) {
//                             setState(() {
//                               if (idx == 0)
//                                 expPending = !expPending;
//                               else if (idx == 1)
//                                 expConfirm = !expConfirm;
//                               else if (idx == 2) expHistory = !expHistory;
//                             });
//                           },
// //                      expandedHeaderPadding: EdgeInsets.all(0),
//                           animationDuration: Duration(seconds: 1),
//                           children: [
// //                          _buildPendingOrders(),
//                             _buildOrders(_con.pendingOrders, S.current.pendingOrders,
//                                 S.current.yourPendingOrdersEmpty, expPending),
// //                          _buildConfirmOrders(),
//                             _buildOrders(_con.confirmedOrders, S.current.confirmedOrders,
//                                 S.current.yourConfirmedOrdersEmpty, expConfirm),
// //                          _buildHistory(),
//                             _buildOrders(_con.historyOrders, S.current.history,
//                                 S.current.yourOrdersEmpty, expHistory),
//                           ],
//                         ),
                          SizedBox(height: DmConst.masterHorizontalPad),
                          TitleDivider(title: S.current.pendingOrders),
                          _buildOrders2(
                              _con.pendingOrders!,
                              S.current.pendingOrders,
                              S.current.yourPendingOrdersEmpty,
                              _pendingExpCtrl!),

                          SizedBox(height: DmConst.masterHorizontalPad),
                          TitleDivider(title: S.current.confirmedOrders),
                          _buildOrders2(
                              _con.confirmedOrders!,
                              S.current.confirmedOrders,
                              S.current.yourConfirmedOrdersEmpty,
                              _confirmExpCtrl!),

                          SizedBox(height: DmConst.masterHorizontalPad),
                          TitleDivider(title: S.current.history),
                          _buildOrders2(_con.historyOrders!, S.current.history,
                              S.current.yourOrdersEmpty, _historyExpCtrl!),

                          SizedBox(height: DmConst.masterHorizontalPad),
                          TitleDivider(title: S.current.boughtProducts),
                          SizedBox(height: DmConst.masterHorizontalPad),
                          _buildBoughtProducts(),
                        ]),
                      ),
                    )
                  ],
                )),
          ),
        ));
  }

  Widget _buildBoughtProducts() {
    if (_con.boughtProducts == null)
      return Center(child: CircularProgressIndicator());
    if (_con.boughtProducts!.isEmpty)
      return EmptyDataLoginWid(message: S.current.yourBoughtProductsEmpty);
    else
      return ProductGridView(
          products: _con.boughtProducts!, heroTag: 'boughPro');
  }

  bool expPending = false;

  ExpansionPanel _buildPendingOrders(List<Order> ods, String emptyText) {
    if (_con.pendingOrders == null || _con.pendingOrders!.isEmpty) {
      return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return TitleDivider(title: S.current.pendingOrders);
          },
          body: Padding(
            padding: const EdgeInsets.only(
                left: DmConst.masterHorizontalPad,
                right: DmConst.masterHorizontalPad),
            child: ListTile(
              leading: Icon(Icons.info, color: DmConst.accentColor),
              title: Text(S.current.yourPendingOrdersEmpty),
            ),
          ),
          isExpanded: expPending,
          canTapOnHeader: true);
    }
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: S.current.pendingOrders);
        },
        body: Padding(
//          padding: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(
              left: DmConst.masterHorizontalPad,
              right: DmConst.masterHorizontalPad),
          child: Column(
            children: List.generate(_con.pendingOrders!.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: buildOrderItem(order: _con.pendingOrders![index]),
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

  ExpansionPanel _buildOrders(
      List<Order> ods, String headerText, String emptyText, bool isExpanded) {
    if (ods.isEmpty) {
      return ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return TitleDivider(title: headerText);
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DmConst.masterHorizontalPad),
            child: ListTile(
              leading: Icon(Icons.info, color: DmConst.accentColor),
              title: Text(emptyText),
            ),
          ),
          isExpanded: isExpanded,
          canTapOnHeader: false);
    }
    return ExpansionPanel(
        headerBuilder: (context, isExpanded) {
          return TitleDivider(title: headerText);
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: DmConst.masterHorizontalPad),
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

  ExpandableController? _pendingExpCtrl, _confirmExpCtrl, _historyExpCtrl;
  var expTheme = ExpandableThemeData(
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapBodyToExpand: false,
      tapBodyToCollapse: false,
      tapHeaderToExpand: false,
      hasIcon: false,
      useInkWell: true);

  Widget _buildOrders2(List<Order> ods, String headerText, String emptyText,
      ExpandableController ctrl) {
    if (ods.isEmpty) {
      return SizedBox(height: DmConst.masterHorizontalPad);
    }
    // if(ods.length == 1) {
    //   return buildOrderItem(order: ods[0]);
    // }

    return Column(
      children: [
        ExpandableNotifier(
          child: ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: true,
            child: ExpandablePanel(
              controller: ctrl,
              // hasIcon: true,
              theme: expTheme,
              header: Padding(
                padding:
                    const EdgeInsets.only(top: DmConst.masterHorizontalPad),
                child: buildOrderItem(order: ods[0]),
              ),
              expanded: Column(
                children: List.generate(ods.length - 1, (index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: DmConst.masterHorizontalPad),
                    child: buildOrderItem(
                        order:
                            ods[index + 1]), //get the 2nd item to end of list.
                  );
                }),
              ),
              collapsed: Text('collapsed'),
            ),
          ),
        ),
        Row(
          //this pading is the button to control expand/collapse action
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: DmConst.masterHorizontalPad / 3),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      ctrl.expanded = !ctrl.expanded;
                    });
                  },
                  child: Icon(
                    ctrl.expanded == true
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  String _formatDate(DateTime date) {
    DateFormat dateFmt = DateFormat('E\ndd\nMMM');
    return date != null ? dateFmt.format(date).toUpperCase() : '';
  }

  Container buildOrderItem({Order? order}) {
    return Container(
      padding: EdgeInsets.all(0),
      decoration: createRoundedBorderBoxDecoration(radius: 5, borderWidth: 1),
      child: ListTile(
        onTap: () => _onTapOnOrderItem(order!),
        leading: Container(
            decoration:
                createRoundedBorderBoxDecoration(radius: 5, borderWidth: 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(_formatDate(order!.createdDate!),
                  textAlign: TextAlign.center),
            )),
        trailing: Icon(Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.secondary),
        isThreeLine: false,
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.current.orderStatus}')),
                Text(': '),
                Expanded(child: Text('${getStatusName(order.orderStatus!)}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.current.orderNumber}')),
                Text(': '),
                Expanded(child: Text('${order.id}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.current.orderValue}')),
                Text(': '),
                Expanded(child: Text('${getDisplayMoney(order.orderVal)}')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text('${S.current.totalItems}')),
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

  bool expHistory = false;

  String getStatusName(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.created:
        return S.current.created;
      case OrderStatus.canceled:
        return S.current.canceled;
      case OrderStatus.denied:
        return S.current.denied;
      case OrderStatus.approved:
        return S.current.approved;
      case OrderStatus.deliverFailed:
        return S.current.deliverFailed;
      case OrderStatus.delivering:
        return S.current.delivering;
      case OrderStatus.preparing:
        return S.current.preparing;
      case OrderStatus.delivered:
        return S.current.delivered;
      case OrderStatus.confirmed:
        return S.current.confirmed;
      case OrderStatus.rejected:
        return S.current.rejected;
      case OrderStatus.unknown:
        return S.current.unknown;
      default:
        return '';
    }
  }

  Future<void> _onTapOnOrderItem(Order order) async {
    var re = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)));
    print('OrdersScreen._onTapOnOrderItem -----------re = $re');
    if (re != null && re is Map && re['isCancel'] == true) {
      //this order has been cancel by customer.
      _con.showMsg(S.current.cancelOrderSuccess);
      setState(() {
        order.orderStatus = OrderStatus.canceled;
      });
    }
  }
}
