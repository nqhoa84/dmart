//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:photo_view/photo_view.dart';
import '../../constant.dart';
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

class ProductDetailScreen extends StatefulWidget {
  RouteArgument routeArgument;
  String _heroTag;
  int amountInCart;

  ProductDetailScreen({Key key, this.routeArgument, this.amountInCart = 0}) {
    _heroTag = this.routeArgument.param[1] as String;
  }

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends StateMVC<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  ProductController _con;
  int _tabIndex = 0;
  TabController _tabController;

  _ProductDetailScreenState() : super(ProductController()) {
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

  Widget _createPriceForBottomBar(BuildContext context) {
    if(_con.product == null) return Container();
    if(_con.product.promotionPrice != null) {
      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${_con.product.getDisplayPromotionPrice}',
          style: TextStyle(color: DmConst.textColorPromotionPrice)),
          Text('${_con.product.getDisplayOriginalPrice}',
          style: TextStyle(decoration: TextDecoration.lineThrough,
              decorationThickness: 2.0,
              decorationColor: DmConst.textColorPromotionPrice),)
        ],
      );
    } else {
      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${_con.product.getDisplayOriginalPrice}')
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFav = _con.favorite?.id != null;
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: DmConst.bgrColorBottomBarProductDetail.withOpacity(0.9),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: DmConst.productShadowColor.withOpacity(0.7),
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
                    child: Text('${_con.product?.name}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  _createPriceForBottomBar(context),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: createFavoriteIcon(context, isFav),
                    backgroundColor: DmConst.primaryColor,
                    onPressed: () {
                      if (currentUser.value.isLogin == false) {
                        Navigator.of(context).pushNamed("/Login");
                      } else {
                        if (isFav) {
                          _con.removeFromFavorite(_con.favorite);
                        } else {
                          _con.addToFavorite(_con.product);
                        }
                      }
                    },
                  ),
                  Expanded(child: SizedBox(width: 10)),
                  Expanded(
                    child: widget.amountInCart > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    _con.decrementQuantity();
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  icon: Icon(Icons.remove_circle_outline)),
                              Text(_con.quantity.toString(),
                                  style: Theme.of(context).textTheme.subtitle1),
                              IconButton(
                                  onPressed: () {
                                    _con.incrementQuantity();
                                  },
                                  iconSize: 30,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  icon: Icon(Icons.add_circle_outline))
                            ],
                          )
                        : FlatButton(
                            onPressed: () {
                              if (currentUser.value.apiToken == null) {
                                Navigator.of(context).pushNamed("/Login");
                              } else {
                                _con.addToCart(_con.product);
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            color: DmConst.primaryColor,
                            shape: StadiumBorder(),
                            child: Text(S.of(context).addToCart,
                                textAlign: TextAlign.center),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _con.product == null
          ? CircularLoadingWidget(height: 500)
          : CustomScrollView(
            slivers: <Widget>[
              _createImageSpace(context),
              _createInfoSpace(context)
            ]),
    );
  }

  Widget _createImageSpace(BuildContext context) {
    return SliverAppBar(
      floating: true,
      automaticallyImplyLeading: false,
      leading: new IconButton(
        icon: new Icon(UiIcons.return_icon, color: DmConst.colorFavorite),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        _con.loadCart
            ? Container(
          margin:
          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: RefreshProgressIndicator(),
        )
            : ShoppingCartButtonWidget(
          iconColor: Theme.of(context).hintColor,
          labelColor: Theme.of(context).accentColor,
          product: _con.product,
        ),
      ],
//                backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 350,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(
                  heroTag: widget._heroTag,
                  image: _con.product.image.thumb);
            }));
          },
          child: Hero(
            tag: widget._heroTag,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5, vertical: 20),
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius:
                      BorderRadius.all(Radius.circular(5)),
                      child: createNetworkImage(
                          url: _con.product.image.thumb)),
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
          unselectedLabelColor: DmConst.colorFavorite,
          labelColor: DmConst.colorFavorite,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: DmConst.primaryColor.withOpacity(0.6)),
          tabs: [
            Tab(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: DmConst.primaryColor.withOpacity(0.5),
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: DmConst.primaryColor.withOpacity(0.5),
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: DmConst.primaryColor.withOpacity(0.5),
                        width: 1)),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(S.of(context).review),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _createInfoSpace(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        //Product name and options.
        Offstage(
          offstage: 0 != _tabIndex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                child: Wrap(runSpacing: 6,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(_con.product.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2, style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Chip(
                          padding: EdgeInsets.all(0),
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(_con.product.rate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1.copyWith(color: DmConst.primaryColor)),
                              Icon(Icons.star_border,
                                color: DmConst.primaryColor,
                                size: 16,
                              ),
                            ],
                          ),
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //Options label
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 6),
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.add_circle,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).options,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  subtitle: Text(
                    S.of(context)
                        .select_options_to_add_them_on_the_product,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              //Options and price from DB.
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _con.product.optionGroups == null
                        ? CircularLoadingWidget(height: 100)
                        : ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, optionGroupIndex) {
                        var optionGroup = _con
                            .product.optionGroups
                            .elementAt(optionGroupIndex);
                        return Wrap(
                          children: <Widget>[
                            ListTile(
                              dense: true,
                              contentPadding:
                              EdgeInsets.symmetric(
                                  vertical: 0),
                              leading: Icon(
                                Icons.add_circle_outline,
                                color:
                                Theme.of(context).hintColor,
                              ),
                              title: Text(
                                optionGroup.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1,
                              ),
                            ),
                            ListView.separated(
                              padding: EdgeInsets.all(0),
                              itemBuilder:
                                  (context, optionIndex) {
                                return OptionItemWidget(
                                  option: _con.product.options
                                      .where((option) =>
                                  option
                                      .optionGroupId ==
                                      optionGroup.id)
                                      .elementAt(optionIndex),
                                  onChanged:
                                  _con.calculateTotal,
                                );
                              },
                              separatorBuilder:
                                  (context, index) {
                                return SizedBox(height: 20);
                              },
                              itemCount: _con.product.options
                                  .where((option) =>
                              option.optionGroupId ==
                                  optionGroup.id)
                                  .length,
                              primary: false,
                              shrinkWrap: true,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemCount:
                      _con.product.optionGroups.length,
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
        //Product details
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
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String image;
  final String heroTag;

  const DetailScreen({Key key, this.image, this.heroTag}) : super(key: key);

  @override
  _DetailScreenWidgetState createState() => _DetailScreenWidgetState();
}

class _DetailScreenWidgetState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        child: Hero(
            tag: widget.heroTag,
            child: PhotoView(
//                  imageProvider: CachedNetworkImageProvider(widget.image),
                imageProvider: NetworkImage(widget.image))),
      ),
    ));
  }
}
