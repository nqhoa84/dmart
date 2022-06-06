import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dmart/DmState.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/helpers/helper.dart';
import 'package:dmart/src/models/favorite.dart';
import 'package:dmart/src/models/media.dart';
import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:dmart/src/widgets/ProductsGridView.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:photo_view/photo_view.dart';

import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../src/controllers/product_controller.dart';
import '../../src/helpers/ui_icons.dart';
import '../../src/repository/user_repository.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import '../../src/widgets/ShoppingCartButton.dart';

// ignore: must_be_immutable
class ProductDetailScreen extends StatefulWidget {
  // RouteArgument routeArgument;
  String? heroTag;
  int? productId;

  ProductDetailScreen({Key? key, this.productId, this.heroTag});

  @override
  _ProductDetailScreenState createState() =>
      _ProductDetailScreenState(productId: productId);
}

class _ProductDetailScreenState extends StateMVC<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  ProductController _con = ProductController();
  int? _tabIndex = 0;
  TabController? _tabController;
  bool? isFav;
  int? amountInCart;
  final int? productId;

  _ProductDetailScreenState({this.productId}) : super(ProductController()) {
    _con = controller as ProductController;
    isFav = DmState.isFavorite(productId: productId!);
    this.amountInCart = DmState.countQuantityInCarts(productId!);
  }

  @override
  void initState() {
    _controller = ExpandableController(initialExpanded: true);
    _controller!.expanded = true;
    _con.listenForProduct(productId: productId!);
    _con.listenForRelatedProducts(productId: productId!);
    _tabController =
        TabController(length: 3, initialIndex: _tabIndex!, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    super.initState();
  }

  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController!.index;
      });
    }
  }

  Widget _createPriceForBottomBar(BuildContext context) {
    if (_con.product == null) return Container();
    if (_con.product!.isPromotion) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${_con.product!.getDisplayOriginalPrice}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationThickness: 2.0,
                decorationColor: DmConst.textColorPromotionPrice),
          ),
          SizedBox(width: 20),
          Text('${_con.product!.getDisplayPromotionPrice}',
              style: TextStyle(color: DmConst.textColorPromotionPrice)),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('${_con.product!.getDisplayOriginalPrice}')],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: SafeArea(child: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_con.product == null) {
      return CircularLoadingWidget(height: 500);
    } else if (_con.product!.id <= 0) {
      //invalid product.
      print('-----invalid product');
      return EmptyDataLoginWid(message: S.current.cantFindProduct);
    } else {
      return CustomScrollView(slivers: <Widget>[
        _createImageSpace(context),
        SliverList(
            delegate: SliverChildListDelegate([
          _createInfoWidget(context),
        ])),
      ]);
    }
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
              color:
                  Theme.of(context).colorScheme.secondary, //.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(UiIcons.return_icon, color: Colors.white)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, DmConst.masterHorizontalPad / 2,
              DmConst.masterHorizontalPad, DmConst.masterHorizontalPad / 2),
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
//                  child: Text(S.current.product),
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
//                  child: Text(S.current.detail),
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
//                  child: Text(S.current.review),
//                ),
//              ),
//            ),
//          ]),
    );
  }

  ExpandableController? _controller;

  Widget _createInfoWidget(BuildContext context) {
    var them = ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapBodyToExpand: true,
        tapBodyToCollapse: false,
        tapHeaderToExpand: true,
        hasIcon: true,
        iconColor: DmConst.accentColor,
        useInkWell: true);
    TextStyle ts = Theme.of(context).textTheme.bodyText2!;
    TableRow _createRowInfo(String left, String right) {
      return TableRow(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(left ?? '', style: ts),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(right ?? '', style: ts),
        ),
      ]);
    }

    return ExpandableNotifier(
        child: ScrollOnExpand(
      scrollOnExpand: false,
      scrollOnCollapse: false,
      child: Column(
        children: <Widget>[
          //Product information panel
          Row(
            children: [
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.symmetric(
                            vertical: BorderSide(color: DmConst.accentColor))),
                    child: _createPriceForBottomBar(context)),
              ),
            ],
          ),
          ExpandablePanel(
            collapsed: Text('collapsed'),
            controller: _controller,
            theme: them,
            header: Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      vertical: BorderSide(color: DmConst.accentColor))),
              child: _createNameAddCartRow(context),
            ),
            expanded: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Table(
//                      defaultVerticalAlignment: TableCellVerticalAlignment.fill,
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                },
                children: [
                  _createRowInfo(S.current.code, _con.product!.code!),
                  _createRowInfo(S.current.category, _con.product!.cateName),
                  _createRowInfo(S.current.brand, _con.product!.brandName),
                  _createRowInfo(S.current.unit, _con.product!.unitName),
                  _createRowInfo(S.current.country, _con.product!.country!),
                  _createRowInfo(
                      S.current.available, '${_con.product!.itemsAvailable}'),
                  TableRow(children: [
                    Text(S.current.description, style: ts),
                    Helper.applyHtml(context, _con.product!.description ?? ''),
//                          Text('${_con.product.description??''}', style: ts),
                  ])
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          //related product panel
          TitleDivider(title: S.current.relatedProducts),
          Padding(
            padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
            child:
                _con.relatedProducts != null //? Container(color: Colors.green)
                    ? ProductGridView(
                        products: _con.relatedProducts!, heroTag: 'related_')
                    : Container(color: Colors.red),
          ),
//                ExpandablePanel(
//                  theme: them,
//                  header: TitleDivider(title: S.current.relatedProducts),
//                  expanded: Padding(
//                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                    child: _con.relatedProducts != null
//                      ? ProductGridView(
//                        products: _con.relatedProducts, heroTag: 'related_',)
//                    : Container(),
//                  ),
//                ),
        ],
      ),
    ));
  }

  Row _createNameRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _con.product!.getTagAssetImage() != null
            ? IconButton(
                padding: EdgeInsets.all(5),
                onPressed: null,
                icon: Image.asset(_con.product!.getTagAssetImage()!))
            : Container(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _con.product!.name,
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
              Text(_con.product!.rate!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: DmConst.accentColor)),
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

  Widget _createNameAddCartRow(BuildContext context) {
    Widget addToCart2() {
      if (amountInCart! > 0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: _onPressIconDecrement,
              child: Container(
                  decoration: new BoxDecoration(
                    border: Border.all(color: DmConst.accentColor, width: 2),
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(child: Icon(Icons.remove))),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('$amountInCart'),
            ),
            InkWell(
              onTap: _onPressIconIncrement,
              child: Container(
                  decoration: new BoxDecoration(
                    border: Border.all(color: DmConst.accentColor, width: 2),
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(child: Icon(Icons.add))),
            )
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 80, minHeight: 25),
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(S.current.add),
                color: DmConst.accentColor,
                onPressed: _onPressAdd2Cart,
              ),
            ),
          ],
        );
      }
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _con.product!.getTagAssetImage() != null
                ? IconButton(
                    padding: EdgeInsets.all(5),
                    onPressed: null,
                    icon: Image.asset(_con.product!.getTagAssetImage()!))
                : Container(width: 10),
            Expanded(
              child: Text(
                _con.product!.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
        addToCart2(),
        SizedBox(height: 8),
      ],
    );
  }

  void _onTapOnPhoto(Media media) {
    print('-------tap on image ${media.id} ${media.url}');
    if (media == null) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return ProductPhotoGalleryScreen(
        heroTag: 'img_media_${media.id}',
        image: media.url!,
      );
    }));
  }

//  double _expandedHeight =
  Widget _buildCarouselImages(BuildContext context) {
    if (_con.product!.medias == null || _con.product!.medias!.isEmpty)
      return Container();
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay:
            _con.product!.medias != null && _con.product!.medias!.length > 1,
        autoPlayInterval: Duration(seconds: 4),
        aspectRatio: 1 / 1,
        viewportFraction: 1.0,
      ),
      items: _con.product!.medias!.map((item) {
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
                      image: DecorationImage(
                          image: NetworkImage(item.url!), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 4),
                            blurRadius: 9)
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

  void _onPressOnFav() {
    if (currentUser.value.isLogin == false) {
      RouteGenerator.gotoLogin(context);
    } else {
      setState(() {
        this.isFav = !this.isFav!;
      });
      if (isFav!) {
        _con.addToFavorite(_con.product!);
      } else {
        Favorite? mark;
        DmState.favorites.forEach((element) {
          if (element.product!.id == productId) {
            mark = element;
            _con.removeFromFavorite(element);
          }
        });

        DmState.favorites.remove(mark);
      }
    }
  }

  void _onPressAdd2Cart() {
    addCart(1);
  }

  void _onPressIconDecrement() {
    addCart(-1);
  }

  void _onPressIconIncrement() {
    addCart(1);
  }

  bool isDoing = false;
  void addCart(int quantity) {
    print(
        "=isDoing $isDoing, isLogin = ${currentUser.value.isLogin} avai ${_con.product!.itemsAvailable}");
    if (isDoing == true) return;
    isDoing = true;
    if (currentUser.value.isLogin) {
      if (_con.product!.itemsAvailable! >= amountInCart! + quantity) {
        _con.addCartGeneral(productId!, quantity);
        setState(() {
          amountInCart = math.max<int>(0, amountInCart! + quantity);
        });
      }
    } else {
      isDoing = false;
      RouteGenerator.gotoLogin(context, replaceOld: true);
    }
    isDoing = false;
  }
}

class ProductPhotoGalleryScreen extends StatefulWidget {
//  final List<Media> medias;
  final String image;
  final String heroTag;

  const ProductPhotoGalleryScreen(
      {Key? key, required this.image, required this.heroTag})
      : super(key: key);

  @override
  _ProductPhotoGalleryScreenState createState() =>
      _ProductPhotoGalleryScreenState();
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
          title: Image.asset(DmConst.assetImgLogo,
              width: DmConst.appBarHeight * 0.7, fit: BoxFit.contain),
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
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).scaffoldBackgroundColor, BlendMode.hue),
                  image: AssetImage(DmConst.assetImgLogo),
                )),
              ),
            ),
            PhotoView(
                enableRotation: true,
                imageProvider: NetworkImage(widget.image),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: '${widget.heroTag}'))
//            _buildGallery(context),
//            _buildContent(context),
          ],
        ));
  }
}

class GalleryItem {
  GalleryItem({required this.id, required this.resource, this.isSvg = false});

  final String id;
  final String resource;
  final bool isSvg;
}
