import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/OrderItemWidget.dart';
import '../widgets/PermissionDeniedWidget.dart';
import '../widgets/ProfileAvatarWidget.dart';
import '../widgets/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';
import '../helpers/ui_icons.dart';


class AccountWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  AccountWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _AccountWidgetState createState() => _AccountWidgetState();
}

class _AccountWidgetState extends StateMVC<AccountWidget> {
  ProfileController _con;

  _AccountWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: currentUser.value.apiToken == null?Theme.of(context).hintColor:Theme.of(context).primaryColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),

        backgroundColor: currentUser.value.apiToken == null?Colors.transparent:Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: currentUser.value.apiToken == null
          ?Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3))
          :Theme.of(context)
              .textTheme
              .title
              .merge(TextStyle(letterSpacing: 1.3, color:Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: currentUser.value.apiToken == null?Theme.of(context).hintColor:Theme.of(context).primaryColor,
              labelColor: currentUser.value.apiToken == null?Theme.of(context).accentColor:Theme.of(context).hintColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          children: <Widget>[
            ProfileAvatarWidget(user: currentUser.value),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                UiIcons.user_1,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).about,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                currentUser.value?.bio ?? "",
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                UiIcons.inbox,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).recent_orders,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            _con.recentOrders.isEmpty
                ? CircularLoadingWidget(height: 200)
                : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: _con.recentOrders.length,
              itemBuilder: (context, index) {
                return Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                                '${S.of(context).order_id}: #${_con.recentOrders.elementAt(index).id}')),
                        Text(
                          '${_con.recentOrders.elementAt(index).orderStatus.status}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    children: List.generate(_con.recentOrders.elementAt(index).productOrders.length,
                            (indexProduct) {
                          return OrderItemWidget(
                              heroTag: 'recent_orders',
                              order: _con.recentOrders.elementAt(index),
                              productOrder:
                              _con.recentOrders.elementAt(index).productOrders.elementAt(indexProduct));
                        }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
