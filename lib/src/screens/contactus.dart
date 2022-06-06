import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/src/models/order_setting.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:flutter/material.dart';

import '../../buidUI.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../utils.dart';

class ContactUsScreen extends StatefulWidget {
  ContactUsScreen();

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double padingH = 10;
  OrderSetting s = DmState.orderSetting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(context, _scaffoldKey),
      bottomNavigationBar:
          DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padingH, vertical: 10),
          child: Column(
            children: [
//            createSilverAppBar(context, haveBackIcon: true, title: S.current.contactUs),
              createTitleRowWithBack(context, title: S.current.contactUs),
              SizedBox(height: 10),
//              createTitleRow(context, title: S.current.hotline),
              TitleDivider(
                  title: S.current.hotline,
                  titleTextColor: Theme.of(context).colorScheme.secondary,
                  dividerColor: Colors.grey.shade400,
                  dividerThickness: 2),
              Card(
                elevation: 10,
                color: Colors.grey.shade100.withOpacity(0.5),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => _makeCall(s.phoneSmart),
                      title: Text(s.phoneSmart),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8),
                        child: Image.asset('assets/img/C_Phone_sign.png',
                            fit: BoxFit.scaleDown),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset('assets/img/C_Smart_Mobile.png',
                                fit: BoxFit.scaleDown)),
                      ),
                    ),
                    Divider(thickness: 1.5, color: Colors.white, height: 2),
                    ListTile(
                      onTap: () => _makeCall(s.phoneCellcard),
                      title: Text(s.phoneCellcard),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8),
                        child: Image.asset('assets/img/C_Phone_sign.png',
                            fit: BoxFit.scaleDown),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                                'assets/img/C_Cellcard_Mobile.png',
                                fit: BoxFit.scaleDown)),
                      ),
                    ),
                    Divider(thickness: 1.5, color: Colors.white, height: 2),
                    ListTile(
                      onTap: () => _makeCall(s.phoneMetfone),
                      title: Text(s.phoneMetfone),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8),
                        child: Image.asset('assets/img/C_Phone_sign.png',
                            fit: BoxFit.scaleDown),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                                'assets/img/C_Metfone_Mobile.png',
                                fit: BoxFit.scaleDown)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: DmConst.masterHorizontalPad),
//              createTitleRow(context, title: S.current.socialNetwork),
              TitleDivider(
                  title: S.current.socialNetwork,
                  titleTextColor: Theme.of(context).colorScheme.secondary,
                  dividerColor: Colors.grey.shade400,
                  dividerThickness: 2),
              _createSocial(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _createSocial(BuildContext context) {
    double w = MediaQuery.of(context).size.width - 2 * padingH;
    double h = w * 720.0 / 1024;
    double btnSize = w * 100 / 1024;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/img/C_Contact_Dmart2.png'),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: h * (44.0 + 20) / 720),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 135.0 / 1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _onTapWhatapp,
                    child: Image.asset('assets/img/C_Whatup.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: _onTapWechat,
                    child: Image.asset('assets/img/C_Wechat.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.0 / 1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _onTapViber,
                    child: Image.asset('assets/img/C_Viber.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: _onTapInstagram,
                    child: Image.asset('assets/img/C_Instagram.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.0 / 1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _onTapTelegram,
                    child: Image.asset('assets/img/C_telegram.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: _onTapFb,
                    child: Image.asset('assets/img/C_Facebook.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 135.0 / 1024 * w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _onTapFbMess,
                    child: Image.asset('assets/img/C_Messenger.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  ),
                  InkWell(
                    onTap: _onTapLine,
                    child: Image.asset('assets/img/C_Line.png',
                        width: btnSize, fit: BoxFit.scaleDown),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _makeCall(String phoneNo) {
    //'tel:$_cc'
    String deepAn = 'tel:$phoneNo';
    String deepIos = deepAn;
    String web = deepIos;
    print(deepIos);
    _launchFull(webUrl: web, deepLinkAn: deepAn, deepLinkIos: deepIos);
  }

  void _onTapWhatapp() {
    String deepAn = 'whatsapp://send?phone=${s.socialWhatapp}';
    String deepIos = deepAn;
    String web = deepIos;
    print(deepIos);
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenWhatapp);
  }

  void _onTapWechat() {
    String deepAn = 'weixin://dl/chat?${s.socialWechat}';
    String deepIos = deepAn;
    String web = deepIos;
    print(deepIos);
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenWechat);
  }

  void _onTapViber() {
    //    await launcher.launch('viber://chat?number=+85512622000');
    String deepAn = 'viber://contact?number=${s.socialViber}';
    String deepIos = 'viber://chat?number=${s.socialViber}';
    String web = deepIos;
    print(deepIos);
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenViber);
  }

  void _onTapInstagram() {
    String deepAn = 'https://www.instagram.com/${s.socialInstagram}';
    String deepIos = deepAn;
    String web = deepAn;
    print(deepIos);
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenInstagram);
  }

  void _onTapTelegram() {
    String deepAn = 'telegram://t.me/${s.socialTelegram}';
    String deepIos = deepAn;
    String web = 'https://t.me/${s.socialTelegram}';
    deepIos = web;
    deepAn = web;
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenTelegram);
  }

  void _onTapFb() {
    String deepAn = 'fb://page/${s.socialFb}';
    String deepIos = 'fb://profile/${s.socialFb}';
    String web = 'https://www.facebook.com/${s.socialFb}';
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenFb);
  }

  void _onTapFbMess() {
    String deepIos = 'fb-messenger-public://user-thread/${s.socialFbMess}';
    String deepAn = 'https://fb.com/msg/${s.socialFbMess}';
    String web = 'https://fb.com/msg/${s.socialFbMess}';
//    print(web);
//    await launcher.launch(web);
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenFbMess);
  }

  void _onTapLine() {
    String deepIos = 'line://ti/p/~${s.socialLine}';
    String deepAn = deepIos;
    String web = 'http://line.me/ti/p/~${s.socialLine}';
    print(deepIos);
    _launchFull(
        webUrl: web,
        deepLinkAn: deepAn,
        deepLinkIos: deepIos,
        errMsg: S.current.errorOpenLine);
  }

  void _launchFull(
      {required String webUrl,
      String? deepLinkAn,
      String? deepLinkIos,
      String? errMsg}) async {
    if (await DmUtils.launchUrl(
        webUrl: webUrl, deepLinkAn: deepLinkAn, deepLinkIos: deepLinkIos)) {
      print('Launch OK');
    } else {
      if (DmUtils.isNotNullEmptyStr(errMsg!)) {
        _scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text(errMsg)));
      }
//      UIUtils.showErrorSnack(errorMsg: errMsg, key: this._scaffoldKey);
    }
  }
}
