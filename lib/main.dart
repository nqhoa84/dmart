import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';

import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(Dmart());
  });
}

class Dmart extends StatefulWidget {
  @override
  _DmartState createState() => _DmartState();
}

class _DmartState extends State<Dmart> {
//  AppLocalizationDelegate _localeOverrideDelegate =
//  AppLocalizationDelegate(Locale('fr', 'US'));

  @override
  void initState() {
    settingRepo.initLanguageSettings().whenComplete(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Setting _setting = settingRepo.setting.value;

    return MaterialApp(
      navigatorKey: settingRepo.navigatorKey,
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
          buttonTheme: ButtonThemeData(minWidth: 60, height: 25,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//            shape: StadiumBorder(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
               side: BorderSide(color: DmConst.accentColor)
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
//        textTheme: TextTheme(
//          headline1: TextStyle(
//              fontSize: 26.0,
//              fontWeight: FontWeight.w300,
//              color: config.Colors().secondColor(1)),
//          headline2: TextStyle(
//              fontSize: 24.0,
//              fontWeight: FontWeight.w700,
//              color: config.Colors().mainColor(1)),
//          headline3: TextStyle(
//              fontSize: 22.0,
//              fontWeight: FontWeight.w700,
//              color: config.Colors().secondColor(1)),
//          headline5: TextStyle(
//              fontSize: 20.0,
//              fontWeight: FontWeight.w700,
//              color: config.Colors().secondColor(1)),
//          headline6: TextStyle(
//              fontSize: 17.0,
//              fontWeight: FontWeight.w700,
//              color: config.Colors().mainColor(1)),
//          subtitle1: TextStyle(
//              fontSize: 18.0,
//              fontWeight: FontWeight.w500,
//              color: config.Colors().secondColor(1)),
//          bodyText2: TextStyle(
//              fontSize: 14.0,
//              fontWeight: FontWeight.w400,
//              color: config.Colors().secondColor(1)),
//          bodyText1: TextStyle(
//              fontSize: 15.0,
//              fontWeight: FontWeight.w400,
//              color: config.Colors().secondColor(1)),
//          caption: TextStyle(
//              fontSize: 14.0,
//              fontWeight: FontWeight.w300,
//              color: config.Colors().accentColor(1)),
//          button: TextStyle(
//              fontSize: 14.0,
//              fontWeight: FontWeight.w300,
//              color: Colors.amber),
//        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          print(_setting.toMap());
          return DynamicTheme(
              defaultBrightness: Brightness.light,
              data: (brightness) {
                if (brightness == Brightness.light) {
                  return ThemeData(
//                    fontFamily: 'Poppins',
                    primaryColor: Colors.white,
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                        elevation: 0, foregroundColor: Colors.white),
                    brightness: brightness,
                    accentColor: config.Colors().mainColor(1),
                    dividerColor: config.Colors().accentColor(0.05),
                    focusColor: config.Colors().accentColor(1),
                    hintColor: config.Colors().secondColor(1),
                    textTheme: TextTheme(
                      headline1: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors().secondColor(1)),
                      headline2: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().mainColor(1)),
                      headline3: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().secondColor(1)),
                      headline5: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().secondColor(1)),
                      headline6: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().mainColor(1)),
                      subtitle1: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: config.Colors().secondColor(1)),
                      bodyText2: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: config.Colors().secondColor(1)),
                      bodyText1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: config.Colors().secondColor(1)),
                      caption: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors().accentColor(1)),
                    ),
                  );
                } else {
                  return ThemeData(
                    fontFamily: 'ProductSans',
                    primaryColor: Color(0xFF252525),
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: Color(0xFF2C2C2C),
                    accentColor: config.Colors().mainDarkColor(1),
                    hintColor: config.Colors().secondDarkColor(1),
                    focusColor: config.Colors().accentDarkColor(1),
                    textTheme: TextTheme(
                      headline5: TextStyle(
                          fontSize: 22.0,
                          color: config.Colors().secondDarkColor(1)),
                      headline4: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().secondDarkColor(1)),
                      headline3: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().secondDarkColor(1)),
                      headline2: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().mainDarkColor(1)),
                      headline1: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors().secondDarkColor(1)),
                      subtitle1: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: config.Colors().secondDarkColor(1)),
                      headline6: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors().mainDarkColor(1)),
                      bodyText2: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: config.Colors().secondDarkColor(1)),
                      bodyText1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: config.Colors().secondDarkColor(1)),
                      caption: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors().secondDarkColor(0.6)),
                    ),
                  );
                }
              },
              themedWidgetBuilder: (context, theme) {
                return MaterialApp(
                  navigatorKey: settingRepo.navigatorKey,
                  title: _setting.appName,
                  initialRoute: '/Splash',
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  locale: DmState.mobileLanguage.value,
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  //localeListResolutionCallback: S.delegate.listResolution(fallback: const Locale('en', '')),
                  theme: theme,
                );
              });
        });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//     initFirebaseMsg();
  }

//  final FirebaseMessaging _fbm = FirebaseMessaging();
//  void initFirebaseMsg() {
//    _fbm.getToken().then((token) {
//      print('--------$token');
//    });
//    _fbm.configure(
//      onResume: (Map<String, dynamic> msg) async {
//        print('onResume $msg');
//      },
//
//      onMessage: (Map<String, dynamic> msg) async {
//        onFirebaseMessage(msg);
//      },
//      //{notification: {title: title, body: text: i am fine. click-action},
//      // data: {click_action: FLUTTER_NOTIFICATION_CLICK}}
//      onLaunch: (Map<String, dynamic> msg) async {
//        print('onLaunch $msg');
//      },
//    );
//  }

//  void onFirebaseMessage(Map<String, dynamic> msg) async {
//    print('onMessage msg $msg');
//    var noti = msg['notification'];
//    if (noti != null) {
//      String title = noti['title'];
//      String body = noti['body'];
//      var data = noti['data'];
//      print(data);
//      DateTime now = DateTime.now();
//
//      print('insert Noti to DB ok, $msg');
//    }
//  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
