import 'package:dmart/src/controllers/reset_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../src/helpers/ui_icons.dart';
import '../../utils.dart';
import '../controllers/user_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends StateMVC<ForgetPasswordScreen> {
  ResetPassController _con;

  _ForgetPasswordScreenState() : super(ResetPassController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(DmConst.assetImgLogo, width: 46, height: 46, fit: BoxFit.scaleDown),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Divider(height: 4, thickness: 2, color: DmConst.accentColor),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).resetYourPass),
            SliverList(
              delegate: SliverChildListDelegate([
                buildContent(context),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: createRoundedBorderBoxDecoration(),
      child: Form(
        key: _con.resetPassFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Text(S.of(context).weWillSendNewPass),
//            SizedBox(height: 15),

            Text(S.of(context).resetPassEnterPhoneNumber),
            SizedBox(height: DmConst.masterHorizontalPad),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
//                height: DmConst.appBarHeight * 0.7,
              decoration: buildBoxDecorationForTextField(context),

              child: TextFormField(
                style: TextStyle(color: DmConst.accentColor),
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                onSaved: (input) {
                  _con.user.phone = input;
                },
                validator: (value) => !DmUtils.isPhone(value) ? S.of(context).invalidPhone : null,
                decoration: new InputDecoration(
                  hintText: S.of(context).phone,
                  hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                  enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                  prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
                ),
                inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],

            ),
            ),

            SizedBox(height: DmConst.masterHorizontalPad * 2),

            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    onPressed: onPressResetPass,
                    child: Text(S.of(context).resetPassword,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                    color: DmConst.colorFavorite,
//                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
             
          ],
        ),
      ),
    );
  }

  void onPressResetPass() {
    print('------onPressResetPass');
    _con.resetPassword();
  }
}
