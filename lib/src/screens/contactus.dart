import 'package:dmart/DmState.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:flutter/material.dart';

import '../../buidUI.dart';
import '../../src/models/category.dart';
import '../../src/models/route_argument.dart';
import '../../src/widgets/DrawerWidget.dart';

class ContactUsScreen extends StatefulWidget {
  RouteArgument routeArgument;
  Category _category;

  ContactUsScreen() ;

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double padingH = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, _scaffoldKey),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padingH, vertical: 10),
            child: Column(
            children: [
//            createSilverAppBar(context, haveBackIcon: true, title: S.of(context).contactUs),
            createTitleRowWithBack(context, title: S.of(context).contactUs),
              SizedBox(height: 10),
//              createTitleRow(context, title: S.of(context).hotline),
              TitleDivider(title: S.of(context).hotline, titleTextColor: Theme.of(context).accentColor,
                  dividerColor: Colors.grey.shade400, dividerThickness: 2),
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
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/img/C_Smart_Mobile.png', fit: BoxFit.scaleDown)),
                      ),
                    ),
                    Divider(thickness: 1.5, color: Colors.white, height: 2),
                    ListTile(
                      title: Text('xxxxxxxxx'),
                      leading: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset('assets/img/C_Phone_sign.png', fit: BoxFit.scaleDown),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/img/C_Cellcard_Mobile.png', fit: BoxFit.scaleDown)),
                      ),
                    ),
                    Divider(thickness: 1.5, color: Colors.white, height: 2),
                    ListTile(
                      title: Text('xxxxxxxxx'),
                      leading: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset('assets/img/C_Phone_sign.png', fit: BoxFit.scaleDown),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/img/C_Metfone_Mobile.png', fit: BoxFit.scaleDown)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
//              createTitleRow(context, title: S.of(context).socialNetwork),
              TitleDivider(title: S.of(context).socialNetwork, titleTextColor: Theme.of(context).accentColor,
                  dividerColor: Colors.grey.shade400, dividerThickness: 2),
              _createSocial(context)
            ],
        ),
          ),
        ),
    );
  }



  Widget _createSocial(BuildContext context) {
    double w = MediaQuery.of(context).size.width - 2*padingH;
    double h = w*720.0/1024;
    double btnSize = w * 100 / 1024;
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/C_Contact_Dmart2.png'),
          fit: BoxFit.cover
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: h *(44.0 + 20)/720),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 135.0/1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Whatup.png', width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Wechat.png', width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.0/1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Viber.png', width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Instagram.png', width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.0/1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_telegram.png', width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Facebook.png', width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 135.0/1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Messenger.png', width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Image.asset('assets/img/C_Line.png', width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


