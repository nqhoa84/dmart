import 'package:dmart/DmState.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
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
  Widget build(BuildContext context) {
    return _con.faqs.isEmpty
        ? CircularLoadingWidget(height: 500)
        : DefaultTabController(
            length: _con.faqs.length,
            child: Scaffold(
              key: widget.scaffoldKey,
              drawer: DrawerWidget(),
              appBar: createAppBar(context, widget.scaffoldKey),
              bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
              body: RefreshIndicator(
                onRefresh: _con.refreshFaqs,
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
              ),
            ),
          );
  }
}
