import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DmState.dart';
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
//  return CachedNetworkImage(
//    height: 80,
//    width: 80,
//    fit: BoxFit.cover,
//    imageUrl: url,
//    placeholder: (context, url) => Image.asset(
//      'assets/img/loading.gif',
//      fit: BoxFit.cover,
//      height: 80,
//      width: 80,
//    ),
//    errorWidget: (context, url, error) =>
//        Icon(Icons.error),
//  );
  return Image.network(
    url,
    width: width,
    height: height,
    fit: BoxFit.cover,
//    loadingBuilder: (ctx, wid, event) {
//      return Image.asset(
//        'assets/img/loading.gif',
//        fit: BoxFit.cover,
//        height: height,
//        width: width,
//      );
//    },
    errorBuilder: (ctx, obj, trace) {
      return Icon(Icons.error);
    },
  );
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

Widget _shoppingCartBadge() {
  return ValueListenableBuilder(
      valueListenable: DmState.amountInCart,
      builder: (context, value, child) {
        if(value > 0) {
          return Badge(
              position: BadgePosition.topRight(top: 0, right: 3),
              animationDuration: Duration(milliseconds: 300),
              animationType: BadgeAnimationType.slide,
              badgeContent: Text('$value', style: TextStyle(color: Colors.white)),
              child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
          );
        } else {
          return Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown);
        }
      }
  );
//  if (amountBadge > 0) {
//    return Badge(
//      position: BadgePosition.topRight(top: 0, right: 3),
//      animationDuration: Duration(milliseconds: 300),
//      animationType: BadgeAnimationType.slide,
//      badgeContent: Text(
//          amountBadge.toString(),
//          style: TextStyle(color: Colors.white)
//      ),
//      child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown),
//    );
//  } else {
//    return Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown);
//  }
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
                Expanded(
                    child: _createUserInfoRowOnTopBar(context, user)
                ),
                InkWell(
                  onTap: () => RouteGenerator.gotoHome(context),
                  child: Container(
                      child: Image.asset('assets/img/H_Logo_Dmart.png', width: 46, height: 46, fit: BoxFit.scaleDown)),
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
              child: SearchBar(onClickFilter: (event) {
                scaffoldKey.currentState.openEndDrawer();
              }),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _createUserInfoRowOnTopBar(BuildContext context, User user) {
  if (user.isLogin) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.transparent,
//todo need to get the avatar
//          child: Image.network(
//            '${user.image?.thumb}',
//            loadingBuilder: (ctx, wid, event) {
//              return Center(child: CircularProgressIndicator());
//            },
//            errorBuilder: (ctx, obj, trace) {
//              return Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown);
//            },
//          ),
        child: Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown),
//            Image.asset('assets/img/H_User_Icon.png',
//                width: 40, height: 40, fit: BoxFit.scaleDown),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(user.name ?? S
                .of(context)
                .unknown),
            Text('${S
                .of(context)
                .credit}: ${currentUser.value.credit}',
                style: TextStyle(color: DmConst.textColorForTopBarCredit)),
          ],
        ),
      ],
    );
  } else {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S
                .of(context)
                .guest),
            Text('${S
                .of(context)
                .credit}:'),
          ],
        ),
      ],
    );
  }
}

Widget createSilverAppBar(BuildContext context, {bool haveBackIcon = true, String title = ''}) {
  return SliverAppBar(
    toolbarHeight: DmConst.appBarHeight * 0.7,
    snap: true,
    floating: true,
    automaticallyImplyLeading: false,
    leading: haveBackIcon ?
    new IconButton(
      icon: new Icon(UiIcons.return_icon),
      onPressed: () => Navigator.of(context).pop(),
    )
        : Container(),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Center(child: Text('$title')),
      )
    ],
    backgroundColor: DmConst.accentColor,
  );
}

Widget createTitleRowWithBack(BuildContext context, {String title='', bool showBack = true}) {
  return Container(
    width: double.infinity, height: DmConst.appBarHeight * 0.7,
    color: DmConst.accentColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBack ? IconButton(
          icon: Icon(UiIcons.return_icon, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ) : Text(''),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Center(child: Text(title,
              style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
        )
      ],
    ),
  );
}

BoxDecoration createRoundedBorderBoxDecoration({double radius = 15, double borderWidth = 2, Color borderColor = Colors.black12}) {
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


Widget createGridViewOfProducts(BuildContext context, List<Product> products,
{String heroTag = 'dm'}) {
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
