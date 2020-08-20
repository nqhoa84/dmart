import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/ui_icons.dart';

class EmptyCart extends StatefulWidget {
  EmptyCart({
    Key key
  }) : super(key: key);

  @override
  _EmptyCartState createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart> {
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
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: Text(
                  S.of(context).dont_have_any_item_in_your_cart,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              !loading
                  ? FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 2);
                      },
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      color: Theme.of(context).accentColor.withOpacity(1),
                      shape: StadiumBorder(),
                      child: Text(
                        S.of(context).start_exploring,
                        style: Theme.of(context)
                            .textTheme
                            .title
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
