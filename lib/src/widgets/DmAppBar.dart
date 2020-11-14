import 'package:auto_size_text/auto_size_text.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:dmart/src/models/ProductType.dart';
import 'package:dmart/src/models/brand.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'dart:math' as math;

import '../../constant.dart';
import '../../route_generator.dart';
import 'SearchBar.dart';
import 'ShoppingCartButton.dart';

class DmAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> types = const ['type1', 'type2', 'type3', 'type4'];
  final List<String> cates = ['cate 1', 'cate 2', 'cate 3', 'cate 4'];
  final List<String> brands = ['brand 1', 'brand 2', 'brand 3', 'brand 4'];
  final List<String> sorts = ['sort 1', 'sort 2', 'sort 3', 'sort 4'];
  final bool canBack = true;
  final String title = 'title';

  DmAppBar({Key key, double height=125.0}) : preferredSize = Size.fromHeight(height), super(key: key);

  @override
  final Size preferredSize;

//  Card3({this.canBack = true, this.title='', this.types = const ['type1', 'type2', 'type3', 'type4'],
//    this.cates = const [], this.brands = const [], this.sorts = const []});

  @override
  _DmAppBarState createState() => _DmAppBarState();
}

class _DmAppBarState extends State<DmAppBar> {
  ExpandableController _controller;

  @override
  void initState() {
    _controller = ExpandableController(initialExpanded: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildItem(String label) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(label),
      );
    }

    buildList() {
      return Column(
        children: <Widget>[
          for (var t in widget.types)
//            return buildItem("Item ${i}");
            Padding(
              padding: const EdgeInsets.all(10.0),
//              child: Text(t.name),
            )
        ],
      );
    }

    _exRow() {
      return Row(
        children: [
          Expanded(
            child: ExpandableNotifier(
                controller: _controller,
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(10),
                  child: ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: true,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                              tapBodyToExpand: true,
                              tapBodyToCollapse: true,
                              hasIcon: false,
                            ),
                            //                    header: buildHeader(context),
                            expanded: buildList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      );
    }

    User user = currentUser.value;

    Widget _createUserInfoRowOnTopBar(BuildContext context, User user) {
      if (user.isLogin) {
        return Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: DmConst.masterHorizontalPad),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(currentUser.value.avatarUrl),
//          child: Image.network(currentUser.value.image.thumb),
//          child: Image.network(
//            '${user.image.thumb}',
//            loadingBuilder: (ctx, wid, event) {
//              return Center(child: CircularProgressIndicator());
//            },
//            errorBuilder: (ctx, obj, trace) {
//              return Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown);
//            },
//          ),
//        child: Image.asset('assets/img/H_User_Icon.png', width: 40, height: 40, fit: BoxFit.scaleDown),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: DmConst.masterHorizontalPad),
              child: Column(
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



    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: widget.preferredSize,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                child: SearchBar( ),
              ),
//                GridView.count(
//                  scrollDirection: Axis.horizontal,
//                  crossAxisCount: 1,
////                children: buildMenu(context),
//                  children: [
//                    Text('adfdasf'),
//                    Text('adfdasf'),
//                    Text('adfdasf'),
//                    Text('adfdasf'),
//                  ],
//
//                )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildMenu(BuildContext context) {
//    TextStyle ts = Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white);
    TextStyle ts = TextStyle(color: Colors.white);
    bool haveReset =
        widget.types.isNotEmpty || widget.cates.isNotEmpty || widget.brands.isNotEmpty || widget.sorts.isNotEmpty;
    List<Widget> re = [];
    if (widget.canBack) {
      re.add(Expanded(child: Align(alignment: Alignment.topLeft, child: buildBackButton(context))));
    }

    if (haveReset) {
      re.add(Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        padding: EdgeInsets.only(left: 5),
        child: InkWell(
          child: Center(child: AutoSizeText(S.of(context).reset, style: ts)),
        ),
      ));
    }

    if (widget.types != null && widget.types.isNotEmpty) {
      re.add(Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        padding: EdgeInsets.only(left: 5),
        child: InkWell(
          child: Row(
            children: [
              AutoSizeText(S.of(context).type, style: ts),
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

    if (widget.cates != null && widget.cates.isNotEmpty) {
      re.add(Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        padding: EdgeInsets.only(left: 5),
        child: InkWell(
          child: Row(
            children: [
              AutoSizeText(S.of(context).category, style: ts),
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

    if (widget.brands != null && widget.brands.isNotEmpty) {
      re.add(Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        padding: EdgeInsets.only(left: 5),
        child: InkWell(
          child: Row(
            children: [
              AutoSizeText(S.of(context).brand, style: ts),
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

    if (widget.sorts != null && widget.sorts.isNotEmpty) {
      re.add(Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
        ),
        padding: EdgeInsets.only(left: 5),
        child: InkWell(
          child: Row(
            children: [
              AutoSizeText(S.of(context).sortBy, style: ts),
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
    if (widget.title != null && widget.title.isNotEmpty) {
      re.add(Container(
          height: DmConst.appBarHeight,
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
          ),
          padding: EdgeInsets.only(right: DmConst.masterHorizontalPad, left: 5),
          child: Center(child: AutoSizeText(widget.title, style: ts))));
    }
    return re;
  }

  StatelessWidget buildBackButton(BuildContext context) {
    return widget.canBack
        ? IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(UiIcons.return_icon, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          )
        : Text('');
  }

  Container buildHeader(BuildContext context) {
    return Container(
      color: Colors.indigoAccent,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ExpandableIcon(
              theme: const ExpandableThemeData(
                expandIcon: Icons.arrow_right,
                collapseIcon: Icons.arrow_drop_down,
                iconColor: Colors.white,
                iconSize: 28.0,
                iconRotationAngle: math.pi / 2,
                iconPadding: EdgeInsets.only(right: 5),
                hasIcon: false,
              ),
            ),
            Text(
              "Items",
              style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
