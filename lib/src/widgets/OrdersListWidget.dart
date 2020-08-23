import '../models/order.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'CircularLoadingWidget.dart';
import 'OrderItemWidget.dart';

class OrdersListWidget extends StatefulWidget {
  final List<Order> orders;

  const OrdersListWidget({Key key, this.orders}) : super(key: key);
  @override
  _OrderListWidgetState createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrdersListWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return widget.orders.isEmpty ? CircularLoadingWidget(height: 500) : ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        return Theme(
          data: theme,
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Row(
              children: <Widget>[
                Expanded(
                    child:
                    Text('${S.of(context).orderId}: #${widget.orders.elementAt(index).id}')),
                Text(
                  '${widget.orders.elementAt(index).orderStatus.status}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            children:
            List.generate(widget.orders.elementAt(index).productOrders.length, (indexProduct) {
              return OrderItemWidget(
                  heroTag: 'my_orders',
                  order: widget.orders.elementAt(index),
                  productOrder: widget.orders.elementAt(index).productOrders.elementAt(indexProduct));
            }),
          ),
        );
      },
    );
  }
}
