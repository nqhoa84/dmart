import 'package:dmart/constant.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class PermissionDenied extends StatefulWidget {
  PermissionDenied({Key? key}) : super(key: key);

  @override
  _PermissionDeniedState createState() => _PermissionDeniedState();
}

class _PermissionDeniedState extends State<PermissionDenied> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: config.App(context).appHeight(70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Theme.of(context).focusColor.withOpacity(0.7),
                          Theme.of(context).focusColor.withOpacity(0.05),
                        ])),
                child: Icon(Icons.https,
                    color: Theme.of(context).scaffoldBackgroundColor, size: 70),
              ),
              Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.15),
//                        color: DmConst.productShadowColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ))),
              Positioned(
                left: -20,
                top: -50,
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    )),
              )
            ],
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: 0.4,
            child: Text(S.current.youMustSignToSeeThisSection,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Login');
            },
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
            color: Theme.of(context).colorScheme.secondary.withOpacity(1),
            shape: StadiumBorder(),
            child: Text(S.current.login,
                style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(height: 20),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/SignUp');
              },
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              shape: StadiumBorder(),
              child: Text(
                S.current.dontHaveAccount,
                style: TextStyle(color: Theme.of(context).focusColor),
              )),
        ],
      ),
    );
  }
}
