import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:flutter/material.dart';

class LogoOnlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isPressLogoToHome;
  LogoOnlyAppBar({Key key, this.isPressLogoToHome = true})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
//        automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: InkWell(
        onTap: isPressLogoToHome ? () => RouteGenerator.gotoHome(context) : null,
        child: Image.asset(DmConst.assetImgLogo, width: kToolbarHeight - 10, height: kToolbarHeight - 10,
            fit: BoxFit.scaleDown),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: Divider(height: 4, thickness: 2, color: DmConst.accentColor),
      ),
    );
  }
}
