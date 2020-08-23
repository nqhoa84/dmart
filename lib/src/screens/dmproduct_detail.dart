//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:photo_view/photo_view.dart';
import '../../generated/l10n.dart';
import '../../src/helpers/helper.dart';
import '../../src/widgets/OptionItemWidget.dart';
import '../../src/controllers/product_controller.dart';
import '../../src/repository/user_repository.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductDetailsTabWidget.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;


class DmProductDetail extends StatefulWidget {
  RouteArgument routeArgument;
  String _heroTag;

  DmProductDetail({Key key, this.routeArgument}) {
    _heroTag = this.routeArgument.param[1] as String;
  }

  @override
  _DmProductDetailState createState() => _DmProductDetailState();
}

class _DmProductDetailState extends StateMVC<DmProductDetail> with SingleTickerProviderStateMixin {
  ProductController _con;
  int _tabIndex = 0;
  TabController _tabController;

  _DmProductDetailState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.routeArgument.id);
    _con.listenForFavorite(productId: widget.routeArgument.id);
    _con.listenForCart();
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex, vsync: this);
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
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.9),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, -2)),
          ],
        ),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      S.of(context).quantity,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _con.decrementQuantity();
                        },
                        iconSize: 30,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        icon: Icon(Icons.remove_circle_outline),
                        color: Theme.of(context).hintColor,
                      ),
                      Text(_con.quantity.toString(),
                          style: Theme.of(context).textTheme.subtitle1),
                      IconButton(
                        onPressed: () {
                          _con.incrementQuantity();
                        },
                        iconSize: 30,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        icon: Icon(Icons.add_circle_outline),
                        color: Theme.of(context).hintColor,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _con.favorite?.id != null
                        ? OutlineButton(
                            onPressed: () {
                              _con.removeFromFavorite(_con.favorite);
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).primaryColor,
                            shape: StadiumBorder(),
                            borderSide: BorderSide(
                                color: Theme.of(context).accentColor),
                            child: Icon(
                              Icons.favorite,
                              color: Theme.of(context).accentColor,
                            ))
                        : FlatButton(
                            onPressed: () {
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed("/Login");
                              } else {
                                _con.addToFavorite(_con.product);
                              }
                            },
                            padding: EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                            child: Icon(
                              Icons.favorite,
                              color: Theme.of(context).primaryColor,
                            )),
                  ),
                  SizedBox(width: 10),
                  Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 110,
                        child: FlatButton(
                          onPressed: () {
                            if (currentUser.value.apiToken == null) {
                              Navigator.of(context).pushNamed("/Login");
                            } else {
                              _con.addToCart(_con.product);
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text( S.of(context).addToCart,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Helper.getPrice(
                          _con.total,
                          context,
                          style: Theme.of(context).textTheme.headline4.merge(
                              TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: _con.product == null
          ? CircularLoadingWidget(height: 500)
          : CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(UiIcons.return_icon,
                      color: Theme.of(context).hintColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: <Widget>[
                  _con.loadCart ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    child: RefreshProgressIndicator(),
                  ):ShoppingCartButtonWidget(
                      iconColor: Theme.of(context).hintColor,
                      labelColor: Theme.of(context).accentColor,
                      product: _con.product,

                  ),
                ],
                backgroundColor: Theme.of(context).primaryColor,
                expandedHeight: 350,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {return DetailScreen(heroTag: widget._heroTag,image:_con.product.image.thumb);}));
                    },
                    child: Hero(
                      tag: widget._heroTag,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
//                                    child: CachedNetworkImage(
//                                      fit: BoxFit.cover,
//                                      imageUrl: _con.product.image.thumb,
//                                      placeholder: (context, url) => Image.asset(
//                                        'assets/img/loading.gif',
//                                        fit: BoxFit.cover,
//                                      ),
//                                      errorWidget: (context, url, error) =>
//                                          Icon(Icons.error),
//                                    ),
                                      child: createNetworkImage(url: _con.product.image.thumb)
                                  ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Theme.of(context).primaryColor,
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(0),
                                  Theme.of(context).scaffoldBackgroundColor
                                ],
                                    stops: [
                                  0,
                                  0.4,
                                  0.6,
                                  1
                                ])),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                    unselectedLabelColor: Theme.of(context).accentColor,
                    labelColor: Theme.of(context).primaryColor,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).accentColor),
                    tabs: [
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                  width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(S.of(context).product),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                  width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(S.of(context).detail),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                  width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(S.of(context).review),
                          ),
                        ),
                      ),
                    ]),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Offstage(
                    offstage: 0 != _tabIndex,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Wrap(
                            runSpacing: 6,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _con.product.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context).textTheme.headline3,
                                        ),

                                      ],
                                    ),
                                  ),
                                  Chip(
                                      padding: EdgeInsets.all(0),
                                      label: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(_con.product.rate,
                                              style:
                                              Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
                                          Icon(
                                            Icons.star_border,
                                            color: Theme.of(context).primaryColor,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                                      shape: StadiumBorder(),
                                    ),

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Helper.getPrice(
                                          _con.product.price,
                                          context,
                                          style: Theme.of(context).textTheme.headline2,
                                        ),
                                        _con.product.discountPrice > 0
                                            ? Helper.getPrice(_con.product.discountPrice, context,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .merge(TextStyle(decoration: TextDecoration.lineThrough)))
                                            : SizedBox(height: 0),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: _con.product.deliverable ? Colors.green : Colors.orange,
                                        borderRadius: BorderRadius.circular(24)),
                                    child: _con.product.deliverable
                                        ? Text('deliverable',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    )
                                        : Text('not_deliverable',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    ),
                                  ),
                                  /*Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).focusColor,
                                          borderRadius: BorderRadius.circular(24)),
                                      child: Text(
                                        _con.product.capacity + " " + _con.product.unit,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                      )),
                                  SizedBox(width: 5),
                                  Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).focusColor,
                                          borderRadius: BorderRadius.circular(24)),
                                      child:Text(
                                            _con.product.packageItemsCount + " " + S.of(context).items,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                            )
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            leading: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).options,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            subtitle: Text(
                              S.of(context).select_options_to_add_them_on_the_product,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _con.product.optionGroups == null
                                  ? CircularLoadingWidget(height: 100)
                                  : ListView.separated(
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context, optionGroupIndex) {
                                  var optionGroup = _con.product.optionGroups.elementAt(optionGroupIndex);
                                  return Wrap(
                                    children: <Widget>[
                                      ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                                        leading: Icon(
                                          Icons.add_circle_outline,
                                          color: Theme.of(context).hintColor,
                                        ),
                                        title: Text(
                                          optionGroup.name,
                                          style: Theme.of(context).textTheme.subtitle1,
                                        ),
                                      ),
                                      ListView.separated(
                                        padding: EdgeInsets.all(0),
                                        itemBuilder: (context, optionIndex) {
                                          return OptionItemWidget(
                                            option: _con.product.options
                                                .where((option) => option.optionGroupId == optionGroup.id)
                                                .elementAt(optionIndex),
                                            onChanged: _con.calculateTotal,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(height: 20);
                                        },
                                        itemCount: _con.product.options
                                            .where((option) => option.optionGroupId == optionGroup.id)
                                            .length,
                                        primary: false,
                                        shrinkWrap: true,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: 20);
                                },
                                itemCount: _con.product.optionGroups.length,
                                primary: false,
                                shrinkWrap: true,
                              ),
                              SizedBox(height: 10),
                              //SelectColorWidget()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: 1 != _tabIndex,
                    child: Column(
                      children: <Widget>[
                        ProductDetailsTabWidget(
                          product: _con.product,
                        )
                      ],
                    ),
                  ),
                  Offstage(
                    offstage: 2 != _tabIndex,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              UiIcons.chat_1,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).productReviews,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                        ReviewsListWidget(
                          product: _con.product,
                        )
                      ],
                    ),
                  )
                ]),
              )
            ]),
    );
  }
}


class DetailScreen extends StatefulWidget {
  final String image;
  final String heroTag;

  const DetailScreen ({Key key, this.image, this.heroTag}) : super(key: key);

  @override
  _DetailScreenWidgetState createState() => _DetailScreenWidgetState();
  
  }
  class _DetailScreenWidgetState extends State<DetailScreen>{
    @override
    Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: GestureDetector(
            child: Hero(
                tag: widget.heroTag,
                child: PhotoView(
//                  imageProvider: CachedNetworkImageProvider(widget.image),
                  imageProvider: NetworkImage(widget.image)
                )),
          ),
        )
    );
  }
}
