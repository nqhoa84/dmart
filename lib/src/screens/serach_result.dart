import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/controllers/search_controller.dart';
import 'package:dmart/src/models/filter.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/FilterWidget.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/SearchBar.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../src/models/route_argument.dart';

class SearchResultScreen extends StatefulWidget {
  RouteArgument routeArgument;
  List<Product> iniProducts;
  String iniSearch;
//  Category _category;

  SearchResultScreen(this.iniProducts, this.iniSearch, {Key key, RouteArgument argument}) {
    this.routeArgument = argument;
//    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState(this.iniProducts, this.iniSearch);
}

class _SearchResultScreenState extends StateMVC<SearchResultScreen> with SingleTickerProviderStateMixin {
  String search, lastSearch;
  SearchController _searchCon;

  Animation animationOpacity;
  AnimationController animationController;

  final ScrollController _scrollCon = ScrollController();
  bool isLoading = false, canLoadMore = true;
  static const double _endReachedThreshold = 100;
  _SearchResultScreenState(List<Product> iniProducts, this.search) : super(new SearchController()) {
    _searchCon = controller;
    _searchCon.products.clear();
    _searchCon.products.addAll(iniProducts??[]);
    lastSearch = this.search;
    _searchCon.scaffoldKey = GlobalKey<ScaffoldState>();
  }


  @override
  void initState() {
    _scrollCon.addListener(_onScroll);

    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();

    super.initState();
  }
  void dispose() {
    animationController.dispose();
    _scrollCon.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCon.hasClients || isLoading || !canLoadMore) return;
    final thresholdReached = _scrollCon.position.extentAfter < _endReachedThreshold;
    if (thresholdReached) {
      isLoading = true;
      loadMore();
      isLoading = false;
    }
  }

  Future<void> _refresh() async {
    isLoading = true;
    onRefresh();
    isLoading = false;
    canLoadMore = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _searchCon.scaffoldKey,
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
//TODO apply filter here
//      endDrawer: FilterWidget(onFilter: (Filter f) {
//        print('selected filter: $f');
//      }),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollCon,
            slivers: <Widget>[
              createSliverTopBar(context),
              buildSearchWidget(context),
              createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).search),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                    child: buildContent(context),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> onRefresh() async {
    _searchCon.search(lastSearch, onDone: () {
      setState(() { });
    });
    canLoadMore = true;
  }

  @override
  Widget buildContent(BuildContext context) {
    if (_searchCon.products.isNotEmpty) {
      return FadeTransition(
        opacity: this.animationOpacity,
        child: ProductGridView(products: _searchCon.products, heroTag: 's'),
      );
    }
  }

  @override
  void loadMore() {
    int pre = _searchCon.products != null ? _searchCon.products.length : 0;
    _searchCon.search(lastSearch, nextPage: true, onDone:() {
      setState(() { });
    });
//    proCon.listenForBestSaleProducts(nextPage: true);
    canLoadMore = _searchCon.products != null && _searchCon.products.length > pre;
  }

  SliverAppBar buildSearchWidget(BuildContext context) {
    return SliverAppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SearchWid(onTapOnSearchIcon: _onTapOnSearchIcon, onSubmitted: _onSubmitted,onTextChanged: _onTextChanged,
              isEditable: true, isAutoFocus: false, hintText: '$lastSearch'),
        ),
        centerTitle: true,
        pinned: true,
        floating: true);
  }

  _onTapOnSearchIcon() {
    print('------_onTapOnSearchIcon-------');
    _searchCon.search(search, onDone: (){
      if(DmUtils.isNullOrEmptyList(_searchCon.products)) {
        _searchCon.showMsg(S.of(context).searchResultEmpty);
      } else {
        lastSearch = search;
        setState(() { });
      }
    });
  }

  _onTextChanged(String p1) {
    search = p1;
  }

  _onSubmitted(String p1) {
    search = p1;
    _onTapOnSearchIcon();
  }
}
