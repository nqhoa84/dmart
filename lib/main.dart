import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
// import 'package:just_audio/just_audio.dart';

import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await GlobalConfiguration().loadFromAsset("configurations");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(Dmart());
  });
}

//click on message while app is idle.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message $message');
}


class Dmart extends StatefulWidget {
  @override
  _DmartState createState() => _DmartState();
}

class _DmartState extends State<Dmart> with WidgetsBindingObserver{
//  AppLocalizationDelegate _localeOverrideDelegate =
//  AppLocalizationDelegate(Locale('fr', 'US'));

  @override
  void initState() {

    settingRepo.initLocalSettings().whenComplete(() {
      setState(() {}); // this call is to refresh the whole page.
      if(DmState.isRadioOn) {
        Future.delayed(Duration (seconds: 2), () {
          DmState.loadRadioFromServerAndPlay();
        }) ;
      }
    });
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initFireBase();

  }

  void _initFireBase() {
    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true);

    // _configureFirebase(firebaseMessaging);
    FirebaseMessaging.instance.getToken().then((String _deviceToken) {
      DmConst.deviceToken = _deviceToken;
      print(' DmConst.deviceToken--${DmConst.deviceToken}');
    }).catchError((e) {
      print('Notification not configured $e');
    });

    FirebaseMessaging.instance.getInitialMessage()
        .then((RemoteMessage message) {
      print('FirebaseMessaging.instance.getInitialMessage $message');

    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('FirebaseMessaging.onMessage.listen! $message');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('FirebaseMessaging.onMessageOpenedApp! $message');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState currentstate $state");
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      DmState.stopRadio();
    }else if (state == AppLifecycleState.resumed) {
      DmState.resumeRadio();
    } else{
      print(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Setting _setting = settingRepo.setting.value;

    return MaterialApp(
      // navigatorKey: settingRepo.navigatorKey,
      navigatorKey: DmState.navState,
      title: _setting.appName,

      initialRoute: '/Splash',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      locale: DmState.mobileLanguage.value,
//      locale: Locale('en', ''),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      //localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
      theme: ThemeData(
          brightness: Brightness.light,// then the primary color = white
          accentColor: DmConst.accentColor,
//        primaryColor: DmConst.,
//        backgroundColor: clrPri,
//        dividerColor: clrPri,
          iconTheme: IconThemeData(size: 25, color: DmConst.accentColor),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
            primary: Colors.white,
              backgroundColor: DmConst.accentColor,
          )),
          buttonTheme: ButtonThemeData(minWidth: 60, height: 25,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//            shape: StadiumBorder(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
               // side: BorderSide(color: DmConst.accentColor)
              ),


              buttonColor: DmConst.accentColor,
              textTheme: ButtonTextTheme.primary
          ),
          textTheme: TextTheme(
            button: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: DmConst.homePromotionColor),
          )
      ),
    );
  }


}
