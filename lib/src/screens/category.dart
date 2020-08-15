//import 'package:cached_network_image/cached_network_image.dart';
import '../../buidUI.dart';
import '../../src/repository/user_repository.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/CategoryHomeTabWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByCategoryWidget.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryWidget extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  CategoryWidget({Key key, this.routeArgument}) {
    _category = this.routeArgument.param[0] as Category;
  }

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(),
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          snap: true,
          floating: true,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon,
                color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).hintColor),
            Container(
              width: 30,
              height: 30,
              //margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
              margin: EdgeInsetsDirectional.only(top: 12.5, bottom: 12.5, end: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(300),
                onTap: () {
                  currentUser.value.apiToken != null
                      ? Navigator.of(context).pushNamed('/Pages', arguments: 1)
                      : Navigator.of(context).pushNamed('/Login');
                },
                child: currentUser.value.apiToken != null
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(currentUser.value.image.thumb),
                      )
                    : Icon(
                        Icons.person,
                        size: 26,
                        color: Theme.of(context).accentColor.withOpacity(1),
                      ),
              ),
            ),
          ],
          backgroundColor: Theme.of(context).accentColor,
          expandedHeight: 250,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                        Theme.of(context).accentColor,
                        Theme.of(context).primaryColor.withOpacity(0.5),
                      ])),
                  child: Center(
                    child: Hero(
                      tag: widget._category.id,
                      child: widget._category.image.url
                              .toLowerCase()
                              .endsWith('.svg')
                          ? Container(
                              height: 80,
                              width: 80,
                              child: SvgPicture.network(
                                widget._category.image.url,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
//                              child: CachedNetworkImage(
//                                height: 80,
//                                width: 80,
//                                fit: BoxFit.cover,
//                                imageUrl: widget._category.image.thumb,
//                                placeholder: (context, url) => Image.asset(
//                                  'assets/img/loading.gif',
//                                  fit: BoxFit.cover,
//                                  height: 80,
//                                  width: 80,
//                                ),
//                                errorWidget: (context, url, error) =>
//                                    Icon(Icons.error),
//                              ),

                              child: createNetworkImage(url:widget._category.image.thumb,
                              width: 80, height: 80)
                            ),
                    ),
                  ),
                ),
                Positioned(
                  right: -60,
                  bottom: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(300),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  top: -80,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor:
                Theme.of(context).primaryColor.withOpacity(0.8),
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Products'),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Offstage(
              offstage: 0 != _tabIndex,
              child: Column(
                children: <Widget>[
                  CategoryHomeTabWidget(category: widget._category),
                ],
              ),
            ),
            Offstage(
              offstage: 1 != _tabIndex,
              child: Column(
                children: <Widget>[
                  ProductsByCategoryWidget(category: widget._category)
                ],
              ),
            ),
          ]),
        )
      ]),
    );
  }
}
