import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/order_setting.dart';
import 'package:dmart/src/repository/user_repository.dart' as userRepo;
import 'package:dmart/src/repository/settings_repository.dart' as settingRepo;
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../DmState.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
//  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SplashScreenController _con;

  bool _userLoaded = false, _settingLoaded = false;

  SplashScreenState() : super(SplashScreenController(scaffoldKey: GlobalKey<ScaffoldState>())) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
//    loadData();
    Future.delayed(Duration(seconds: 1), () async {
      userRepo.getCurrentUser().whenComplete(() {
        _userLoaded = true;
        if (_userLoaded && _settingLoaded) {
          RouteGenerator.gotoHome(context);
        }
      });

      settingRepo.initSettings().whenComplete(() {
        _settingLoaded = true;
        if(_userLoaded && _settingLoaded) {
          RouteGenerator.gotoHome(context);
        }
      });

    });
  }

  void onError(FlutterErrorDetails errDetail) {
    print(errDetail);
    _con.showErr(S.of(context).verifyYourInternetConnection);
  }

  void _loadData() {
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
        print('progress $progress');
      });
      if (progress >= 100) {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0);
      }
    });
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
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
