import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'generated/l10n.dart';
import 'src/models/user.dart';
import 'src/repository/user_repository.dart';
import 'src/widgets/SearchBar.dart';

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

PreferredSize createAppBar(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
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
                        child: Image.asset('assets/img/H_Cart.png', fit: BoxFit.scaleDown)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 4, thickness: 2, color: DmConst.primaryColor),
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
          child: Image.network(
            user.image?.thumb,
            loadingBuilder: (ctx, wid, event) {
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (ctx, obj, trace) {
              return Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown);
            },
          ),
//            Image.asset('assets/img/H_User_Icon.png',
//                width: 40, height: 40, fit: BoxFit.scaleDown),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(user.name ?? S.of(context).unknown),
            Text('${S.of(context).credit}: ${currentUser.value.credit}',
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
            Text(S.of(context).guest),
            Text('${S.of(context).credit}:'),
          ],
        ),
      ],
    );
  }
}
