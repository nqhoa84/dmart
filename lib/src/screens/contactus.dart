//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';

import '../../buidUI.dart';
import '../../src/repository/user_repository.dart';

import '../helpers/ui_icons.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/CategoryHomeTabWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/ProductsByCategory.dart';
import '../../src/widgets/ReviewsListWidget.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUsScreen extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  ContactUsScreen() ;

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, _scaffoldKey),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
          child: Column(
          children: [
//            createSilverAppBar(context, haveBackIcon: true, title: S.of(context).contactUs),
          Container(
            width: double.infinity, height: DmConst.appBarHeight * 0.7,
            color: DmConst.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: new Icon(UiIcons.return_icon, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Center(child: Text(S.of(context).contactUs,
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
                )
              ],
            ),
          ),
            createTitleRow(context, title: S.of(context).hotline),
            Card(
              elevation: 10,
              color: Colors.grey.shade100.withOpacity(0.5),
              child: Column(
                children: [
                  ListTile(
                    title: Text('xxxxxxxxx'),
                    leading: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/img/C_Phone_sign.png', fit: BoxFit.scaleDown),
                    ),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image.asset('assets/img/C_Smart_Mobile.png', fit: BoxFit.scaleDown)),
                  ),
                  Divider(thickness: 1.5, color: Colors.white, height: 2),
                  ListTile(
                    title: Text('xxxxxxxxx'),
                    leading: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/img/C_Phone_sign.png', fit: BoxFit.scaleDown),
                    ),
                    trailing: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image.asset('assets/img/C_Cellcard_Mobile.png', fit: BoxFit.scaleDown)),
                  ),
                  Divider(thickness: 1.5, color: Colors.white, height: 2),
                  ListTile(
                    title: Text('xxxxxxxxx'),
                    leading: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset('assets/img/C_Phone_sign.png', fit: BoxFit.scaleDown),
                    ),
                    trailing: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Image.asset('assets/img/C_Metfone_Mobile.png', fit: BoxFit.scaleDown)),
                  )
                ],
              ),
            ),
            createTitleRow(context, title: S.of(context).socialNetwork),

          ],
        ),
        ),
    );
  }

  Row createTitleRow(BuildContext context, {String title}) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Divider(thickness: 2, color: Colors.grey.shade400),
              )),
              Text(title, style: Theme.of(context).textTheme.headline6.copyWith(
                color: DmConst.primaryColor
              )),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Divider(thickness: 2, color: Colors.grey.shade400),
              )),
            ],
          );
  }
}
