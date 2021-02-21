import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/user.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../repository/user_repository.dart' as userRepo;

class EmptyDataLoginWid extends StatefulWidget {
  final IconData iconData;
  final String message;
  EmptyDataLoginWid({Key key,
    this.iconData = Icons.info_outline,
    this.message = ''
  }) : super(key: key);

  @override
  _EmptyDataLoginWidState createState() => _EmptyDataLoginWidState();
}

class _EmptyDataLoginWidState extends State<EmptyDataLoginWid> with SingleTickerProviderStateMixin {
  Animation animationOpacity;
  AnimationController animationController;

  User _user = userRepo.currentUser.value;

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    CurvedAnimation curve = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationOpacity = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationOpacity,
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.all(10),
//      height: config.App(context).appHeight(60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                          Theme.of(context).focusColor,
                          Theme.of(context).focusColor.withOpacity(0.1),
                        ])),
                    child: Icon(widget.iconData, size: 70),
                  ),
                  Positioned(
                    right: -30,
                    bottom: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Opacity(
              opacity: 0.4,
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(height: 10),
            FlatButton(
              onPressed: () => _onPressHome(context),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              color: Theme.of(context).accentColor.withOpacity(1),
              shape: StadiumBorder(),
              child: Text(S.of(context).home, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)),
            ),
            SizedBox(height: 10),
            _user == null || !_user.isLogin
            ? FlatButton(
              onPressed: () => RouteGenerator.gotoLogin(context, replaceOld: true),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              color: Theme.of(context).accentColor.withOpacity(1),
              shape: StadiumBorder(),
              child: Text(S.of(context).login, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white)),
            )
            : SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  void _onPressHome(BuildContext context) {
    RouteGenerator.gotoHome(context);
  }


}
