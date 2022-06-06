import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/repository/user_repository.dart' as userRepo;
import 'package:dmart/src/repository/settings_repository.dart' as settingRepo;
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
//  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SplashScreenController _con = SplashScreenController();

  bool _userLoaded = false, _settingLoaded = false;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller as SplashScreenController;
  }

  @override
  void initState() {
    super.initState();
    _con.context = this.context;
//    loadData();
    Future.delayed(Duration(seconds: 1), () async {
      _con.init();
      // _initLocalNotification();

      userRepo.getCurrentUser().whenComplete(() {
        _userLoaded = true;
        if (_userLoaded && _settingLoaded) {
          RouteGenerator.gotoHome(context);
        }
      });

      settingRepo.initSettings().whenComplete(() {
        _settingLoaded = true;
        if (_userLoaded && _settingLoaded) {
          RouteGenerator.gotoHome(context);
        }
      });
    });
  }

  // final AndroidInitializationSettings initializationSettingsAndroid =
  // AndroidInitializationSettings('app_icon');
  // final IOSInitializationSettings initializationSettingsIOS =
  // IOSInitializationSettings(
  //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final MacOSInitializationSettings initializationSettingsMacOS =
  // MacOSInitializationSettings();
  // // final InitializationSettings initializationSettings = InitializationSettings(
  // //     android: initializationSettingsAndroid,
  // //     iOS: initializationSettingsIOS,
  // //     macOS: initializationSettingsMacOS);
  // InitializationSettings initializationSettings;
  //
  //
  // Future<void> _initLocalNotification() async {
  //   initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: initializationSettingsIOS,
  //       macOS: initializationSettingsMacOS);
  //
  //   await DmState.flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: selectNotification);
  // }

  // Future<dynamic> selectNotification(String payload) async {
  //   if(payload != null) {
  //     Map data = jsonDecode(payload);
  //     if(data.containsKey('order')) {
  //       int orderId = data['order'];
  //       //navigate to Order detail page.
  //       RouteGenerator.gotoOrderDetailPage(context, orderId: orderId);
  //     }
  //   }
  //   return true;
  //   if (payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }
  //   // await Navigator.push(
  //   //   this.context,
  //   //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  //   // );
  // }

  // static Future onDidReceiveLocalNotification(
  //     int id, String title, String body, String payload) {
  //   print(
  //       'onDidReceiveLocalNotification: id $id, title $title, body $body, payload $payload');
  // }

  void onError(FlutterErrorDetails errDetail) {
    print(errDetail);
    _con.showErr(S.current.verifyYourInternetConnection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                DmConst.assetImgLogo,
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
