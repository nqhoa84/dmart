import 'package:dmart/DmState.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/faq_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/DrawerWidget.dart';
import '../widgets/FaqItem.dart';

class HelpScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends StateMVC<HelpScreen> {
  FaqController _con;

  _HelpScreenState() : super(FaqController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForFaqs();
    super.initState();
  }

  @override
  Widget _build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).helpAndSupports),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                    child: buildContent(context)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if(_con.faqs == null) {
      body = Center(child: CircularProgressIndicator());
    } else if(_con.faqs.isEmpty){
      body = EmptyDataLoginWid(message: S.of(context).faqEmpty);
    } else {
      body = DefaultTabController(
        length: _con.faqs.length,
        child: TabBarView(
          children: List.generate(_con.faqs.length, (index) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
//                          ListTile(
//                            contentPadding: EdgeInsets.symmetric(vertical: 0),
//                            leading: Icon(Icons.help, color: Theme.of(context).hintColor),
//                            title: Text(S.of(context).help_supports,
//                                maxLines: 1,
//                                overflow: TextOverflow.ellipsis,
//                                style: Theme.of(context).textTheme.headline5),
//                          ),
                  createTitleRowWithBack(context, title:S.of(context).helpAndSupports),
                  TabBar(
                    tabs: List.generate(_con.faqs.length, (index) {
                      return Tab(text: _con.faqs.elementAt(index).name ?? '');
                    }),
                    labelColor: DmConst.accentColor,
                  ),
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.faqs.elementAt(index).faqs.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 15);
                    },
                    itemBuilder: (context, indexFaq) {
                      return FaqItem(faq: _con.faqs.elementAt(index).faqs.elementAt(indexFaq));
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      );
    }

    return Scaffold(
      key: widget.scaffoldKey,
      appBar: createAppBar(context, widget.scaffoldKey),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      body: body,
    );

  }

  Widget buildContent(BuildContext context) {
    if(_con.faqs == null) {
      return Center(child: CircularProgressIndicator());
    }
    if(_con.faqs.isEmpty) {
      return EmptyDataLoginWid(message: S.of(context).faqEmpty);
    }
    return DefaultTabController(
      length: _con.faqs.length,
      child: TabBarView(
        children: List.generate(_con.faqs.length, (index) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
//                          ListTile(
//                            contentPadding: EdgeInsets.symmetric(vertical: 0),
//                            leading: Icon(Icons.help, color: Theme.of(context).hintColor),
//                            title: Text(S.of(context).help_supports,
//                                maxLines: 1,
//                                overflow: TextOverflow.ellipsis,
//                                style: Theme.of(context).textTheme.headline5),
//                          ),
                createTitleRowWithBack(context, title:S.of(context).helpAndSupports),
                TabBar(
                  tabs: List.generate(_con.faqs.length, (index) {
                    return Tab(text: _con.faqs.elementAt(index).name ?? '');
                  }),
                  labelColor: Theme.of(context).primaryColor,
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.faqs.elementAt(index).faqs.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15);
                  },
                  itemBuilder: (context, indexFaq) {
                    return FaqItem(faq: _con.faqs.elementAt(index).faqs.elementAt(indexFaq));
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
