import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/reset_pass_controller.dart';
import 'package:dmart/src/pkg/sms_otp_auto_1.2/src/sms_retrieved.dart';
import 'package:dmart/src/pkg/sms_otp_auto_1.2/src/text_field_pin.dart';
import 'package:dmart/src/widgets/profile/profile_common.dart';
import 'package:dmart/src/widgets/toolbars/LogoOnlyAppBar.dart';
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
  void initState() {
    super.initState();
    _getSignatureCode();
  }
  _getSignatureCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("signature $signature");
  }

  @override
  void dispose() {
//  SmsRetrieved.stopListening();

  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: LogoOnlyAppBar(),
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
      padding: EdgeInsets.all(DmConst.masterHorizontalPad),
      margin: EdgeInsets.all(DmConst.masterHorizontalPad),
      decoration: createRoundedBorderBoxDecoration(),
      child: Wrap(
        children: [
          Offstage(
            offstage: this.haveOtp,
            child: Form(
              key: _con.resetPassFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//            Text(S.of(context).weWillSendNewPass),
//            SizedBox(height: 15),

                  Text(S.of(context).resetPassEnterPhoneNumber),
                  SizedBox(height: DmConst.masterHorizontalPad),
                  PhoneNoWid(onSaved: (value) => _con.user.phone = value),

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
          ),

          Offstage(
            offstage: this.haveOtp == false,
            child: Form(
              key: _con.newPassFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).verifyOtpNote),
                  TextFieldPin(
                    filled: true,
                    filledColor: DmConst.bgrColorSearchBar,
                    codeLength: 6,
                    boxSize: 40,
                    margin: 2,
                    filledAfterTextChange: false,
                    textStyle: TextStyle(color: DmConst.accentColor).copyWith(fontSize: 20),
                    borderStyle: OutlineInputBorder(
                        borderSide: BorderSide(color: DmConst.accentColor), borderRadius: BorderRadius.circular(5)),
                    borderStyeAfterTextChange: OutlineInputBorder(
                        borderSide: BorderSide(color: DmConst.accentColor), borderRadius: BorderRadius.circular(5)),
                    onOtpCallback: (code, isAutofill) => _onOtpCallBack(code, isAutofill),
                  ),
                  SizedBox(height: DmConst.masterHorizontalPad),

                  PasswordWid(onSaved: (value) => _con.user.password = value),
                  SizedBox(height: DmConst.masterHorizontalPad),
                  PasswordConfirmWid(onValidate: (value) => value == _con.user.password ? null : S.of(context).passwordNotMatch),
                  SizedBox(height: DmConst.masterHorizontalPad),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          onPressed: onPressSaveNewPass,
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
          )
        ],
      ),
    );
  }

  String userEnterOtp;
  _onOtpCallBack(String otpCode, bool isAutofill) async {
    this.userEnterOtp = otpCode;
  }

  bool haveOtp = false;
  void onPressResetPass() async {
    print('------onPressResetPass');
    bool re = await _con.sendOtpForgotPass();
    setState(() {this.haveOtp = re;});
  }

  void onPressSaveNewPass() async {
    print('------onPressResetPass');
    bool re = await _con.saveNewPasses(this.userEnterOtp);
    if(re == true)
      RouteGenerator.gotoProfileUpdatedScreen(context);
  }
}
