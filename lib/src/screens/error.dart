//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/route_generator.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  ErrorScreen();

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<ErrorScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                S.of(context).generalErrorMessage,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  RouteGenerator.gotoHome(context);
                },
                child: Text(S.of(context).home),
                shape: StadiumBorder(),
                color: DmConst.accentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () {
                    RouteGenerator.gotoSplash(context);
                  },
                  shape: StadiumBorder(),
                  color: DmConst.accentColor,
                  child: Text(S.of(context).reset)),
            ),
          ],
        ),
      ),
    );
  }
}
