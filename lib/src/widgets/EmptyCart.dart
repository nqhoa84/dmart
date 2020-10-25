import 'dart:async';

import 'package:dmart/src/widgets/EmptyDataLoginWid.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/ui_icons.dart';

class EmptyCartGrid extends StatefulWidget {
  EmptyCartGrid({
    Key key
  }) : super(key: key);

  @override
  _EmptyCartGridState createState() => _EmptyCartGridState();
}

class _EmptyCartGridState extends State<EmptyCartGrid> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                )
              )
            : EmptyDataLoginWid(
          message: S.of(context).yourCartEmpty,
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
            )
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: Text(
                  S.of(context).yourCartEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              !loading
                  ? FlatButton(
                onPressed: () {
                  RouteGenerator.gotoHome(context);
                },
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                color: Theme.of(context).accentColor.withOpacity(1),
                shape: StadiumBorder(),
                child: Text(
                  S.of(context).home,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
