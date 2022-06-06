import 'package:dmart/DmState.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:math' as math;

import '../../generated/l10n.dart';
import '../controllers/search_controller.dart';
//import '../widgets/CardWidget.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/ProductItemSearchResult.dart';
import 'toolbars/SearchBar.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key? key, required this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  SearchController _con = SearchController();

  _SearchResultWidgetState() : super(SearchController()) {
    _con = controller as SearchController;
  }

  @override
  void initState() {
    _con.getRecentSearchStr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.current.search,
                style: Theme.of(context).textTheme.headline4,
              ),
              /*subtitle: Text(
                S.current.ordered_by_nearby_first,
                style: Theme.of(context).textTheme.caption,
              ),*/
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: SearchWid(
              onTapOnSearchIcon: _onTapOnSearchIcon,
              onSubmitted: _onSubmitted,
              onTextChanged: _onSearchStrChanged, hintText: '',
              // isEditable: true
            ),
          ),
          buildRecentSearches(context),
          _con.products.isEmpty
              ? CircularLoadingWidget(height: 288)
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.current.productsResults,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                      ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.products.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return ProductItemSearchResult(
                            heroTag: 'search_list',
                            product: _con.products.elementAt(index),
                          );
                        },
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.current.stores_results,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: _con.stores.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Details',
                                  arguments: RouteArgument(
                                    id: _con.stores.elementAt(index).id,
                                    heroTag: widget.heroTag,
                                  ));
                            },
                            child: CardWidget(market: _con.stores.elementAt(index), heroTag: widget.heroTag),
                          );
                        },
                      ),*/
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _onTapOnSearchIcon() {
    print('_onTapOnSeachIcon');
    _con.search('-----');
  }

  _onSubmitted(String value) {
    print('_onSubmitted');
    if (value.trim().isNotEmpty) {
      _con.search(value.trim());
    }
  }

  _onSearchStrChanged(String value) {
    print('_onSearchStrChanged');
    if (value.trim().isNotEmpty) {}
  }

  Widget buildRecentSearches(BuildContext context) {
    if (DmState.recentSearches == null) {
      return SizedBox(height: 10);
    }
    return Column(
      children:
          List.generate(math.min(5, DmState.recentSearches!.length), (index) {
        return Container(
            padding: EdgeInsets.all(8),
            child: Text('${DmState.recentSearches![index]}'));
      }),
    );
  }
}
