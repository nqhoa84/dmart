import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dmart/DmState.dart';
import 'package:dmart/buidUI.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/helpers/helper.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:dmart/src/models/media.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:photo_view/photo_view.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/models/route_argument.dart';
import '../../src/repository/user_repository.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/OptionItemWidget.dart';
import '../../src/widgets/ProductDetailsTabWidget.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButton.dart';

class ProductDetailScreen extends StatefulWidget {
  RouteArgument routeArgument;
  String _heroTag;

  ProductDetailScreen({Key key, this.routeArgument}) {
    _heroTag = this.routeArgument.param[1] as String;
  }

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(productId: routeArgument.id);
}

class _ProductDetailScreenState extends StateMVC<ProductDetailScreen> with SingleTickerProviderStateMixin {
  ProductController _con;
  int _tabIndex = 0;
  TabController _tabController;
  bool isFav;
  int amountInCart;
  final int productId;

  _ProductDetailScreenState({@required this.productId}) : super(ProductController()) {
    _con = controller;
    isFav = DmState.isFavorite(productId: productId);
    this.amountInCart = DmState.countQuantityInCarts(productId);
  }

  @override
  void initState() {
    _controller = ExpandableController(initialExpanded: true);
    _controller.expanded = true;
    _con.listenForProduct(productId: productId);
    _con.listenForRelatedProducts(productId: productId);
    _tabController = TabController(length: 3, initialIndex: _tabIndex, vsync: this);
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
    if (_con.product == null) return Container();
    if (_con.product.isPromotion) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${_con.product.getDisplayPromotionPrice}', style: TextStyle(color: DmConst.textColorPromotionPrice)),
          Text(
            '${_con.product.getDisplayOriginalPrice}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2.0,
                decorationColor: DmConst.textColorPromotionPrice),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('${_con.product.getDisplayOriginalPrice}')],
      );
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
          color: DmConst.bgrColorBottomBarProductDetail.withOpacity(0.9),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: DmConst.productShadowColor.withOpacity(0.7), blurRadius: 5, offset: Offset(0, -2)),
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
                      '${_con.product?.name}',
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
                    backgroundColor: DmConst.accentColor,
                    onPressed: _onPressOnFav,
                  ),
                  Expanded(child: SizedBox(width: 10)),
                  Expanded(
                    child: amountInCart > 0
                        ? Row( 
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  onPressed: _onPressIconDecrement,
                                  iconSize: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                  icon: Icon(Icons.remove_circle_outline)),
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 20
                                  ),
                                  child: Text('${amountInCart}',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.subtitle1)),
                              IconButton(
                                  onPressed: _onPressIconIncrement,
                                  iconSize: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                  icon: Icon(Icons.add_circle_outline))
                            ],
                          )
                        : FlatButton(
                            onPressed: _onPressAdd2Cart,
                            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            color: DmConst.accentColor,
                            shape: StadiumBorder(),
                            child: Text(S.of(context).addToCart, textAlign: TextAlign.center),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: _buildContent(context)),
    );
  }

  Widget _createImageSpace(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      leading: new IconButton(
        color: DmConst.accentColor.withOpacity(0.6),
        icon: Container(
            padding: EdgeInsets.all(8),
            decoration: new BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(UiIcons.return_icon, color: Colors.white)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
              0, DmConst.masterHorizontalPad / 2, DmConst.masterHorizontalPad, DmConst.masterHorizontalPad / 2),
          child: ShoppingCartButton(),
        ),
      ],
//                backgroundColor: Theme.of(context).primaryColor,
//        collapsedHeight: kToolbarHeight + 10,
      expandedHeight: MediaQuery.of(context).size.width,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _buildCarouselImages(context),
      ),
//      bottom: TabBar(
//          controller: _tabController,
//          indicatorSize: TabBarIndicatorSize.label,
//          labelPadding: EdgeInsets.symmetric(horizontal: 10),
//          unselectedLabelColor: DmConst.colorFavorite,
//          unselectedLabelStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.colorFavorite),
////          labelColor: Colors.white,
//          labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
//          indicator:
//              BoxDecoration(borderRadius: BorderRadius.circular(20), color: DmConst.accentColor.withOpacity(0.6)),
//          tabs: [
//            Tab(
//              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 5),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    border: Border.all(color: DmConst.accentColor.withOpacity(0.5), width: 1)),
//                child: Align(
//                  alignment: Alignment.center,
//                  child: Text(S.of(context).product),
//                ),
//              ),
//            ),
//            Tab(
//              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 5),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    border: Border.all(color: DmConst.accentColor.withOpacity(0.5), width: 1)),
//                child: Align(
//                  alignment: Alignment.center,
//                  child: Text(S.of(context).detail),
//                ),
//              ),
//            ),
//            Tab(
//              child: Container(
//                padding: EdgeInsets.symmetric(horizontal: 5),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(20),
//                    border: Border.all(color: DmConst.accentColor.withOpacity(0.5), width: 1)),
//                child: Align(
//                  alignment: Alignment.center,
//                  child: Text(S.of(context).review),
//                ),
//              ),
//            ),
//          ]),
    );
  }

  ExpandableController _controller;

  Widget _createInfoWidget(BuildContext context) {

    var them =  ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapBodyToExpand: true,
        tapBodyToCollapse: false,
        tapHeaderToExpand: true,
        hasIcon: true,
        iconColor: DmConst.accentColor,
        useInkWell: true
    );
    TextStyle ts = Theme.of(context).textTheme.bodyText2;

    return ExpandableNotifier(
        child: ScrollOnExpand(
          scrollOnExpand: false,
          scrollOnCollapse: false,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                //Product information panel
                ExpandablePanel(
                  controller: _controller,
                  theme: them,
                  header: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(vertical: BorderSide(color: DmConst.accentColor))
                    ),
                      child: _createNameRow(context)),
                  expanded: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Table(
//                      defaultVerticalAlignment: TableCellVerticalAlignment.fill,
                        columnWidths: {0: FlexColumnWidth(1),
                          1: FlexColumnWidth(3),
                        },
                      children: [
                      TableRow( children: [
                        Text(S.of(context).category, style: ts),
                        Text(_con.product.name, style: ts),
                      ]),
                        TableRow( children: [
                          Text(S.of(context).brand, style: ts),
                          Text('${_con.product.brand?.name}', style: ts),
                        ]),
                        TableRow( children: [
                          Text(S.of(context).available, style: ts),
                          Text('${_con.product.itemsAvailable??''}', style: ts),
                        ]),
                        TableRow( children: [
                          Text(S.of(context).unit, style: ts),
                          Text('${_con.product.unit??''}', style: ts),
                        ]),
                        TableRow( children: [
                          Text(S.of(context).description, style: ts),
                          Helper.applyHtml(context, _con.product.description??''),
//                          Text('${_con.product.description??''}', style: ts),
                        ])
                    ],),
                  ),
                ),
                SizedBox(height: 10),
                //related product panel
                ExpandablePanel(
                  theme: them,
                  header: TitleDivider(title: S.of(context).relatedProducts),
                  expanded: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: _con.relatedProducts != null
                      ? ProductGridView(
                        products: _con.relatedProducts, heroTag: 'related_',)
                    : Container(),
                  ),
                ),
              ],
            ),
          ),
        ));
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
                padding: const EdgeInsets.all(2),
                child: _createNameRow(context),
              ),
              Divider(color: DmConst.accentColor, indent: 10, endIndent: 10, height: 2),
              //Options label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                    'select_options_to_add_them_on_the_product',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
              //Options and price from DB.
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
//                                        onChanged: _con.calculateTotal,
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
                              return SizedBox(height: 10);
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

  Row _createNameRow(BuildContext context) {
    return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _con.product.getTagAssetImage() != null
                  ? IconButton(padding: EdgeInsets.all(5),
                      onPressed: null,
                      icon: Image.asset(_con.product.getTagAssetImage()))
                  : Container(width: 10),
                  Expanded(
                    child: Align( alignment: Alignment.centerLeft,
                      child: Text(
                        _con.product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  Chip(
                    padding: EdgeInsets.all(0),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(_con.product.rate,
                            style: Theme.of(context).textTheme.bodyText1.copyWith(color: DmConst.accentColor)),
                        Icon(
                          Icons.star_border,
                          color: DmConst.accentColor,
                          size: 16,
                        ),
                      ],
                    ),
                    shape: StadiumBorder(),
                  ),
                ],
              );
  }

  void _onTapOnPhoto(Media media) {
    print('-------tap on image ${media?.id}');
    if (media == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProductPhotoGalleryScreen(
        heroTag: 'img_media_${media.id}',
        image: media.url,
      );
    }));
  }

//  double _expandedHeight =
  Widget _buildCarouselImages(BuildContext context) {
    if (_con.product.medias == null || _con.product.medias.isEmpty) return Container();
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        aspectRatio: 1 / 1,
        viewportFraction: 1.0,
      ),
      items: _con.product.medias.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                child: Stack(
              children: <Widget>[
                //display slider.image
                InkWell(
                  onTap: () => _onTapOnPhoto(item),
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(item.url), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 9)
                      ],
                    ),
                  ),
                ),
              ],
            ));
          },
        );
      }).toList(),
    );
  }

  Widget _buildContent(BuildContext context) {
    return _con.product == null
        ? CircularLoadingWidget(height: 500)
        : CustomScrollView(
            slivers: <Widget>[
              _createImageSpace(context),
//              _createInfoSpace(context),
              SliverList(
                  delegate: SliverChildListDelegate([
                    _createInfoWidget(context),
                      ])),
            ]
          );
  }

  void _onPressOnFav() {
    if (currentUser.value.isLogin == false) {
      RouteGenerator.gotoLogin(context);
    } else {
      setState(() {
        this.isFav = !this.isFav;
      });
      if(isFav) {
        _con.addToFavorite(_con.product);
      } else {
        Favorite mark;
        DmState.favorites.forEach((element) {
          if(element.product.id == productId) {
            mark = element;
            _con.removeFromFavorite(element);
          }
        });

        if(mark != null) DmState.favorites.remove(mark);
      }
    }
  }

  void _onPressAdd2Cart() {
    addCart(1);
  }

  void _onPressIconDecrement () {
    addCart(-1);
  }
  void _onPressIconIncrement () {
    addCart(1);
  }

  void addCart(int quantity) {
    if (currentUser.value.isLogin) {
      _con.addCartGeneral(productId, quantity);
      setState(() {
        amountInCart = math.max<int>(0, amountInCart + quantity);
      });
    } else {
      RouteGenerator.gotoLogin(context, replaceOld: true);
    }
  }
}

class ProductPhotoGalleryScreen extends StatefulWidget {
//  final List<Media> medias;
  final String image;
  final String heroTag;

  const ProductPhotoGalleryScreen({Key key, @required this.image, @required this.heroTag}) : super(key: key);

  @override
  _ProductPhotoGalleryScreenState createState() => _ProductPhotoGalleryScreenState();
}

class _ProductPhotoGalleryScreenState extends State<ProductPhotoGalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: DmConst.accentColor.withOpacity(0.3),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(UiIcons.return_icon)),
          title: Image.asset(DmConst.assetImgLogo, width: DmConst.appBarHeight * 0.7, fit: BoxFit.contain),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  colorFilter: ColorFilter.mode(Theme.of(context).scaffoldBackgroundColor, BlendMode.hue),
                  image: AssetImage(DmConst.assetImgLogo),
                )),
              ),
            ),
            PhotoView(
                enableRotation: true,
                imageProvider: NetworkImage(widget.image),
                heroAttributes: PhotoViewHeroAttributes(tag: '${widget.heroTag}'))
//            _buildGallery(context),
//            _buildContent(context),
          ],
        ));
  }
}

class GalleryItem {
  GalleryItem({this.id, this.resource, this.isSvg = false});

  final String id;
  final String resource;
  final bool isSvg;
}
