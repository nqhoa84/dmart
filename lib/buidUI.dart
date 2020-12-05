import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/src/models/ProductType.dart';
import 'package:dmart/src/models/brand.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/i_name.dart';
import 'package:dmart/src/widgets/DmDropDown.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constant.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/ui_icons.dart';
import 'src/models/product.dart';
import 'src/models/user.dart';
import 'src/repository/user_repository.dart';
import 'src/widgets/ProductItemWide.dart';
import 'src/widgets/SearchBar.dart';
import 'src/widgets/ShoppingCartButton.dart';

Widget createNetworkImage({String url, double width, double height, BoxFit fit = BoxFit.cover}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: fit,
    imageUrl: url,
    placeholder: (context, url) => Image.asset(
      'assets/img/loading.gif',
      fit: BoxFit.cover,
    ),
    errorWidget: (context, url, error) =>
        Icon(Icons.error_outline),
  );
//  return Image.network(
//    url,
//    width: width,
//    height: height,
//    fit: BoxFit.cover,
////    loadingBuilder: (ctx, wid, event) {
////      return Image.asset(
////        'assets/img/loading.gif',
////        fit: BoxFit.cover,
////        height: height,
////        width: width,
////      );
////    },
//    errorBuilder: (ctx, obj, trace) {
//      return Icon(Icons.error);
//    },
//  );
}

Widget createFavoriteIcon(BuildContext context, bool isFav) {
//  return Image.asset(
//      isFav ? 'assets/img/Favourite_01.png'
//          : 'assets/img/Favourite.png',
//      fit: BoxFit.scaleDown);
  return isFav
      ? Icon(Icons.favorite, color: DmConst.colorFavorite)
      : Icon(Icons.favorite_border, color: DmConst.colorFavorite);
}

Widget _createUserInfoRowOnTopBar(BuildContext context, User user) {
  // print('_createUserInfoRowOnTopBar-----------');
  // print('fb ${user.fbAvatar}');
  // print('avatarUrl ${user.avatarUrl}');
  if (user.isLogin) {
    return InkWell(
      onTap: () => RouteGenerator.gotoProfileInfo(context),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: DmConst.masterHorizontalPad),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(user.avatarUrl),
              // backgroundImage: createNetworkImage(url: user.avatarUrl),
//              child: createNetworkImage(url: currentUser.value.image.thumb),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: DmConst.masterHorizontalPad),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.nameShort ?? S.of(context).unknown),
                Text('${S.of(context).credit}: ${currentUser.value.credit}',
                    style: TextStyle(color: DmConst.textColorForTopBarCredit)),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    return InkWell(
      onTap: () => RouteGenerator.gotoLogin(context),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).guest),
              Text('${S.of(context).credit}:'),
            ],
          ),
        ],
      ),
    );
  }
}

PreferredSize createAppBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, {int amountBadge = 0}) {
  User user = currentUser.value;
  return PreferredSize(
    preferredSize: Size.fromHeight(110),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: _createUserInfoRowOnTopBar(context, user)),
                InkWell(
                  onTap: () => RouteGenerator.gotoHome(context),
                  child: Container(
                      child: Image.asset(DmConst.assetImgLogo, width: 46, height: 46, fit: BoxFit.scaleDown)),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => RouteGenerator.gotoCart(context),
                      child: Container(
                        padding: EdgeInsets.only(right: 30),
                        height: 40,
                        //                          child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown)
                        //                          child: _shoppingCartBadge(),
                        child: ShoppingCartButton(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 4, thickness: 2, color: DmConst.accentColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
              child: SearchBar(),
            ),
          ],
        ),
      ),
    ),
  );
}

///Create appbar with logo and back button if need.
AppBar createAppBarLogo(BuildContext context, {bool haveBackIcon = true}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: haveBackIcon == false
        ? null
        : InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) Navigator.pop(context);
            },
            child: Icon(UiIcons.return_icon, color: DmConst.accentColor)),
    title: InkWell(
        onTap: () => RouteGenerator.gotoHome(context),
        child: Image.asset(DmConst.assetImgLogo, width: 46, height: 46, fit: BoxFit.scaleDown)),
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(4),
      child: Divider(height: 4, thickness: 2, color: DmConst.accentColor),
    ),
  );
}

SliverAppBar createSliverTopBar(BuildContext context) {
  User user = currentUser.value;
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    elevation: 10,
//    title: Container(color: Colors.red),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _createUserInfoRowOnTopBar(context, user)),
              InkWell(
                onTap: () => RouteGenerator.gotoHome(context),
                child: Container(
                    child: Image.asset(DmConst.assetImgLogo, width: 46, height: 46, fit: BoxFit.scaleDown)),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => RouteGenerator.gotoCart(context),
                    child: Container(
                      padding: EdgeInsets.only(right: 30),
                      height: 40,
                      //                          child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown)
                      //                          child: _shoppingCartBadge(),
                      child: ShoppingCartButton(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 4, thickness: 2, color: DmConst.accentColor),
        ],
      ),
    ),
  );
}

SliverAppBar createSliverSearch(BuildContext context) {
  IconThemeData it = IconThemeData(
    color: DmConst.accentColor
  );
  return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SearchBar(),
      ),
      centerTitle: true,
      pinned: true,
      floating: true,
    iconTheme: it,
  );
}

Widget createSilverTopMenu(BuildContext context,
    {bool haveBackIcon = true,
    List<IdNameObj> types = const [],
    List<Category> cates = const [],
    List<Brand> brands = const [],
    List<SortBy> sorts = const [],
    String title = ''}) {
  TextStyle ts = Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white);


  List<Widget> _buildMenu() {
//    TextStyle ts = Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white);

    bool haveReset = types.isNotEmpty || cates.isNotEmpty || brands.isNotEmpty || sorts.isNotEmpty;
    List<Widget> re = [];

    if (haveReset) {
      re.add(Container(
        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
//        decoration: BoxDecoration(
//          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
//        ),
        child: InkWell(
          child: Center(child: Text(S.of(context).reset, style: ts)),
        ),
      ));
    }

    if (types != null && types.length > 0) {
      re.add(Container(
        padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        child: DmDropDown(items: types),
//        child: InkWell(
//          onTap: onTapOnType,
//          child: Row(
//            children: [
//              Text(S.of(context).type, style: ts),
//              Icon(
//                Icons.keyboard_arrow_down,
//                color: Colors.white,
//                size: 25,
//              )
//            ],
//          ),
//        ),
      ));
    }

    if (cates != null && cates.isNotEmpty) {
      re.add(Container(
        padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        child: InkWell(
          child: Row(
            children: [
              Text(S.of(context).category, style: ts),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 25,
              )
            ],
          ),
        ),
      ));
    }

    if (brands != null && brands.isNotEmpty) {
      re.add(Container(
        padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        child: InkWell(
          child: Row(
            children: [
              Text(S.of(context).brand, style: ts),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 25,
              )
            ],
          ),
        ),
      ));
    }

    if (sorts != null && sorts.isNotEmpty) {
      re.add(Container(
        padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        child: InkWell(
          child: Row(
            children: [
              Text(S.of(context).sortBy, style: ts),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 25,
              )
            ],
          ),
        ),
      ));
    }
    if (title != null && title.isNotEmpty) {
//      re.add(VerticalDivider(color: Colors.white, thickness: 2, width: 10,));
      re.add(Container(
          padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
          ),
          child: Center(child: Text(title ?? '', style: ts))));
    }
    return re;
  }

  return SliverAppBar(
    toolbarHeight: DmConst.appBarHeight * 0.6,
    floating: false,
    pinned: true,
    automaticallyImplyLeading: false,

    leading: haveBackIcon
        ? new IconButton(
            icon: new Icon(UiIcons.return_icon),
            onPressed: () => Navigator.of(context).pop(),
          )
        : null,
//    centerTitle: true,
    title: Align(
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildMenu(),
        ),
      ),
    ),
    actions: <Widget>[Container()],
    backgroundColor: DmConst.accentColor,
  );
}

Widget createTitleRowWithBack(BuildContext context, {String title = '', bool showBack = true}) {
  return Container(
    width: double.infinity,
    height: DmConst.appBarHeight * 0.7,
    color: DmConst.accentColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBack
            ? IconButton(
                icon: Icon(UiIcons.return_icon, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : Text(''),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(child: Text(title, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
        )
      ],
    ),
  );
}

BoxDecoration createRoundedBorderBoxDecoration(
    {double radius = 15, double borderWidth = 2, Color borderColor = Colors.black12}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(width: borderWidth, color: borderColor),
//                      color: Theme.of(context).primaryColor,
//                      boxShadow: [
//                        BoxShadow(
//                            color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 10), blurRadius: 20)
//                      ],
  );
}

Widget createGridViewOfProducts(BuildContext context, List<Product> products, {String heroTag = 'dm'}) {
  return GridView.count(
    primary: false,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    crossAxisCount: 1,
    crossAxisSpacing: 1.5,
    childAspectRatio: 337.0 / 120,
    // 120 / 337,
    children: List.generate(
      products.length,
      (index) {
        Product product = products.elementAt(index);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductItemWide(product: product, heroTag: '${heroTag}_${index}_'),
        );
      },
    ),
  );
}

BoxDecoration buildBoxDecorationForTextField(BuildContext context) {
  return BoxDecoration(
      color: DmConst.bgrColorSearchBar,
      border: Border.all(
        color: Theme.of(context).focusColor.withOpacity(0.2),
      ),
      borderRadius: BorderRadius.circular(7));
}

InputDecoration buildInputDecoration(BuildContext context, String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: DmConst.accentColor),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
  );
}

Container createEmptyContainer({String imageUrl}) {
  return Container(decoration: BoxDecoration(
      image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover
      )
  ));
}