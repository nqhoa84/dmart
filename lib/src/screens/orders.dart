import '../widgets/OrdersListWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/OrderItemWidget.dart';
import '../widgets/PermissionDenied.dart';
import '../widgets/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final int currentTab=0;
  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.currentTab ?? 0,
      length: 5,
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).my_orders,
            style: Theme.of(context).textTheme.title.merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
          ],
          bottom: TabBar(
              indicatorPadding: EdgeInsets.all(10),
              labelPadding: EdgeInsets.symmetric(horizontal: 5),
              unselectedLabelColor: Theme.of(context).accentColor,
              labelColor: Theme.of(context).primaryColor,
              isScrollable: true,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Theme.of(context).accentColor),
              tabs: [
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Theme.of(context).accentColor, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).all),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Theme.of(context).accentColor, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).unpaid),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Theme.of(context).accentColor, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).shipped),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Theme.of(context).accentColor, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).on_the_way),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Theme.of(context).accentColor, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(S.of(context).preparing),
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
            children:[
              OrdersListWidget(orders:_con.orders),
              OrdersListWidget(orders:_con.ordersUnpaid),
              OrdersListWidget(orders:_con.ordersDelivered),
              OrdersListWidget(orders:_con.ordersOnTheWay),
              OrdersListWidget(orders:_con.ordersPreparing),
            ]
        ),
      ),
    );
  }
}
