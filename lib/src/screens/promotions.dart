import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/promotion_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/widgets/CategoriesGrid.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/PromotionGroups.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../generated/l10n.dart';
import '../../src/widgets/DrawerWidget.dart';

class PromotionsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool canBack;

  PromotionsScreen({Key key, this.canBack = false}) : super(key: key);

  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends StateMVC<PromotionsScreen>
    with SingleTickerProviderStateMixin
{
  PromotionController _con;

  _PromotionsScreenState() : super(PromotionController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForPromotions();
    super.initState();
  }

  Widget buildContent(BuildContext context) {
    if (_con.promotions.isEmpty) {
      return NameImageItemGridViewLoading();
    } else {
      return PromotionsGridView(promotions: _con.promotions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: 2),
      drawer: DrawerWidget(),
      drawerEnableOpenDragGesture: true,
      body: DoubleBackToCloseApp(
        child: SafeArea(
          child: CustomScrollView(slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(
              context,
              haveBackIcon: widget.canBack,
              title: S.of(context).promotions,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    padding: EdgeInsets.all(DmConst.masterHorizontalPad),
                    child: buildContent(context)),
              ]),
            )
          ]),
        ),
        snackBar: SnackBar(
          content: Text(S.of(context).tapBackAgainToQuit),
        ),
      ),
    );
  }
}
