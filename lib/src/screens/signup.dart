import 'dart:async';

import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/register_controller.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/pkg/sms_otp_auto_1.2/src/sms_retrieved.dart';
import 'package:dmart/src/pkg/sms_otp_auto_1.2/src/text_field_pin.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils.dart';
import '../controllers/user_controller.dart';
import '../../generated/l10n.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends StateMVC<SignUpScreen> {
  RegController _con;
  int _stepIdx = 0;

  int _otpCodeLength = 6;
  String _otpCode = "";

  _SignUpScreenState() : super(RegController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("signature $signature");
  }

  _onOtpCallBack(String otpCode, bool isAutofill) async {
    print("_onOtpCallBack $otpCode -- $isAutofill");
    this._otpCode = otpCode;
    if (otpCode.length == this._otpCodeLength) {
      await verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: this._stepIdx >= 2 ? null : InkWell(
            onTap: () {
              if (Navigator.of(context).canPop()) Navigator.pop(context);
            },
            child: Icon(UiIcons.return_icon, color: DmConst.accentColor)),
        title: InkWell(
            onTap: () => RouteGenerator.gotoHome(context, replaceOld: true),
            child: Image.asset(DmConst.assetImgLogo, width: 46, height: 46, fit: BoxFit.scaleDown)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Divider(height: 4, thickness: 2, color: DmConst.accentColor),
        ),
      ),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      body: SafeArea(
//        child: SingleChildScrollView(
//          child: Column(
//            children: <Widget>[
//              //our code.
//              buildContent(context),
////              _typeStep()
//            ],
//          ),
////           child: buildContent(context),
//        ),
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height),
      child: Theme(
        data: ThemeData(primaryColor: DmConst.accentColor),

        ///TODO change to latest version to use optional steppers
        /// https://material.io/archive/guidelines/components/steppers.html#
        child: Stepper(
          type: StepperType.horizontal,
          controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
              Container(),
          currentStep: _stepIdx,
          onStepTapped: (index) {
            setState(() {
              _stepIdx = index;
            });
          },
          steps: [
            Step(
              title: SizedBox(),
              content: buildMobileNoAndPassWidget(context),
              isActive: (_stepIdx == 0),
            ),
            Step(
              title: SizedBox(),
              content: buildVerificationWidget(context),
              state: StepState.indexed,
              isActive: (_stepIdx == 1),
            ),
            Step(
              title: SizedBox(),
              content: buildRegOkWidget(context),
//              content: SizedBox(),
              state: StepState.indexed,
              isActive: (_stepIdx == 2),
            ),
            Step(
              title: SizedBox(),
              content: buildLocationWidget(context),
              state: StepState.indexed,
              isActive: (_stepIdx == 3),
            ),
            Step(
              title: SizedBox(),
              content: buildPersonalDetailWidget(context),
              state: StepState.complete,
              isActive: (_stepIdx == 4),
            ),
          ],
        ),
      ),
    );
  }

  get txtStyleHeadline => Theme.of(context).textTheme.headline5;

  get txtStyleGrey => Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey);

//  get txtStyleAccent => Theme.of(context).textTheme.subtitle1.copyWith(color: DmConst.accentColor);
  final txtStyleAccent = TextStyle(color: DmConst.accentColor);

  Widget buildMobileNoAndPassWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).mobileNoAndPass,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Form(
          key: _con.regFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildMobileExistedWid(context),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: buildBoxDecorationForTextField(context),
                child: TextFormField(
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    onSaved: (input) {
//                    if (DmUtils.isNullOrEmptyStr(input)) return;
//                    input = input.trim();
                      _con.user.phone = input;
                    },
                    validator: _phoneValidate,
                    decoration: new InputDecoration(
                      hintText: S.of(context).phone,
                      hintStyle: txtStyleAccent,
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                      prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
                    ),
                    inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]),
              ),

              SizedBox(height: 10),

              //password
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
//                height: DmConst.appBarHeight * 0.7,
                decoration: buildBoxDecorationForTextField(context),
                child: TextFormField(
                  style: this.txtStyleAccent,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  onSaved: (input) => _con.user.password = input,
                  validator: (input) => input.length < 4 ? S.of(context).passwordNote : null,
                  obscureText: _con.hidePassword,
                  decoration: new InputDecoration(
                    hintText: S.of(context).password,
                    hintStyle: txtStyleAccent,
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                    prefixIcon: Icon(UiIcons.padlock_1, color: DmConst.accentColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _con.hidePassword = !_con.hidePassword;
                        });
                      },
                      color: DmConst.accentColor.withOpacity(0.4),
                      icon: Icon(_con.hidePassword ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              //repeat pass
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: buildBoxDecorationForTextField(context),
                child: TextFormField(
                  style: this.txtStyleAccent,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
//                  onSaved: (input) => _con.user.password = input,
                  validator: (input) {
                    //return null if OK
                    print('-$input---${_con.user.password}-');
                    if (input != null && input == _con.user.password) {
                      return null;
                    } else {
                      return S.of(context).passwordNotMatch;
                    }
                  },
                  obscureText: _con.hidePassword2,
                  decoration: new InputDecoration(
                    hintText: S.of(context).confirmPassword,
                    hintStyle: txtStyleAccent,
                    enabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                    prefixIcon: Icon(UiIcons.padlock_1, color: DmConst.accentColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _con.hidePassword2 = !_con.hidePassword2;
                        });
                      },
                      color: DmConst.accentColor.withOpacity(0.4),
                      icon: Icon(_con.hidePassword2 ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                ),
              ),
              Text(S.of(context).passwordNote, style: txtStyleGrey),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      onPressed: _con.loading ? null : onPressNext2VerifyStep,
                      child: Text(S.of(context).next,
                          style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                      color: DmConst.accentColor,
//                    shape: StadiumBorder(),
                    ),
                  ),
                ],
              ),
              Offstage(
                offstage: _con.loading == false,
                child: Text(S.of(context).processing),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildVerificationWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).verification,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          S.of(context).input6digitCode,
          style: TextStyle(color: DmConst.accentColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        TextFieldPin(
          filled: true,
          filledColor: DmConst.bgrColorSearchBar,
          codeLength: _otpCodeLength,
          boxSize: 40,
          margin: 2,
          filledAfterTextChange: false,
          textStyle: txtStyleAccent.copyWith(fontSize: 20),
          borderStyle: OutlineInputBorder(
              borderSide: BorderSide(color: DmConst.accentColor), borderRadius: BorderRadius.circular(5)),
          borderStyeAfterTextChange: OutlineInputBorder(
              borderSide: BorderSide(color: DmConst.accentColor), borderRadius: BorderRadius.circular(5)),
          onOtpCallback: (code, isAutofill) => _onOtpCallBack(code, isAutofill),
        ),
        SizedBox(height: 10),
        Text(S.of(context).verifyOtpNote, style: txtStyleGrey),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressNext2LocationStep,
                child: Text(S.of(context).next,
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRegOkWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          isThreeLine: false,
          leading: Image.asset(DmConst.assetImgUserThumbUp),
          title: Wrap(
            alignment: WrapAlignment.start,
              children: [
            Text(S.of(context).yourPhoneRegOK),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(S.of(context).welcomeTo),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("Dmart24.com", style: TextStyle(color: DmConst.accentColor)),
            ),
            Text(S.of(context).enjoyShopping),
          ],),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () {
                  RouteGenerator.gotoHome(context, replaceOld: true);
                },
                child: Text(S.of(context).startShopping,
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        TitleDivider(title: S.of(context).personalDetails),
        SizedBox(height: 10),
        Text(S.of(context).personalDetailNote),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressSaveLocation,
                child: Text(S.of(context).next,
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        )

      ],
    );
  }

  Widget buildLocationWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).location,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(S.of(context).locationNote, style: txtStyleGrey),
        Form(
          key: _con.locationFormKey,
            child: Column(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: buildBoxDecorationForTextField(context),
                margin: EdgeInsets.symmetric(vertical: 5),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.address.address = input.trim(),
                            validator: (input) => DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                            decoration: buildInputDecorationForLocation(context, S.of(context).houseNo),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
    //            SizedBox(width: 2, height: 100, child: Container(color: Colors.white)),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.address.street = input.trim(),
                            validator: (input) => DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                            decoration: buildInputDecorationForLocation(context, S.of(context).streetName),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: buildBoxDecorationForTextField(context),
                margin: EdgeInsets.symmetric(vertical: 5),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.address.ward = input.trim(),
                            validator: (input) => DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                            decoration: buildInputDecorationForLocation(context, S.of(context).commune),
                          ),
                        ),
                      ),
                      VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
    //            SizedBox(width: 2, height: 100, child: Container(color: Colors.white)),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.address.district = input.trim(),
                            validator: (input) => DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                            decoration: buildInputDecorationForLocation(context, S.of(context).district),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: buildBoxDecorationForTextField(context),
                margin: EdgeInsets.symmetric(vertical: 5),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.address.province = S.of(context).phnompenh,
                            validator: (input) => DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                            decoration: buildInputDecorationForLocation(context, S.of(context).phnompenh),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: buildBoxDecorationForTextField(context),
                margin: EdgeInsets.symmetric(vertical: 5),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            style: txtStyleAccent,
                            maxLines: 2,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            onSaved: (input) => _con.address.description = input.trim(),
                            decoration: buildInputDecorationForLocation(context, S.of(context).note),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],)
        ),

        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressSaveLocation,
                child: Text(S.of(context).save,
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration buildBoxDecorationForTextField(BuildContext context) {
    return BoxDecoration(
        color: DmConst.bgrColorSearchBar,
        border: Border.all(
          color: Theme.of(context).focusColor.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(7));
  }

  InputDecoration buildInputDecorationForLocation(BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: this.txtStyleAccent,
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
    );
  }

  Widget buildPersonalDetailWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).personalDetails,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        buildGenderDropdown(),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: buildBoxDecorationForTextField(context),
          child: TextFormField(
            style: txtStyleAccent,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.text,
            onSaved: (input) {
              if (DmUtils.isNullOrEmptyStr(input)) return;
              input = input.trim();
              _con.user.name = input;
            },
            validator: (value) => DmUtils.isNullOrEmptyStr(value) ? S.of(context).invalidFullName : null,
            decoration: buildInputDecorationForLocation(context, S.of(context).fullName),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: buildBoxDecorationForTextField(context),
          child: TextFormField(
            style: txtStyleAccent,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.text,
            onSaved: (input) {
              _con.user.email = input.trim();
            },
            validator: (value) => !DmUtils.isEmail(value) ? S.of(context).invalidEmail : null,
            decoration: buildInputDecorationForLocation(context, S.of(context).email),
          ),
        ),
        SizedBox(height: 10),
        Text(S.of(context).dateOfBirthNote, style: txtStyleGrey),
        InkWell(
          onTap: () {
            print('tap to select birthday');
            DatePicker.showDatePicker(context,
                showTitleActions: false,
                minTime: DateTime(2018, 3, 5),
                maxTime: DateTime(2019, 6, 7),
                theme: DatePickerTheme(
//                          headerColor: Colors.orange,
                    backgroundColor: DmConst.accentColor,
                    itemStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)), onChanged: (date) {
              print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
            }, onConfirm: (date) {
              print('confirm $date');
            }, currentTime: DateTime.now(), locale: LocaleType.en);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: buildBoxDecorationForTextField(context),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: txtStyleAccent,
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                    decoration:buildInputDecorationForLocation(context, S.of(context).day),
                  )),
                  VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                  Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: txtStyleAccent,
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        decoration:buildInputDecorationForLocation(context, S.of(context).month),
                      )),
                  VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                  Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: txtStyleAccent,
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        decoration:buildInputDecorationForLocation(context, S.of(context).year),
                      )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
//        Text(S.of(context).personalDetailNote, textAlign: TextAlign.center),
//        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressYesRegMe,
                child: Text(S.of(context).save,
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Offstage buildMobileExistedWid(BuildContext context) {
    return Offstage(
      offstage: _con.isRegMobileExistedReg == false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Row(
          children: [
            Icon(Icons.error, color: DmConst.colorFavorite, size: kToolbarHeight),
            Expanded(
              child: Text(
                S.of(context).loginErrorIncorrectPhonePassFullMsg,
                style: TextStyle(color: DmConst.colorFavorite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _phoneValidate(String value) {
    if (value != null && !DmUtils.isPhone(value.trim()))
      return S.of(context).invalidPhone;
    else {
      return null;
    }
  }

  onPressNext2VerifyStep() async {
    await _con.register();
    if (DmUtils.isNotNullEmptyStr(_con.OTP)) {
      setState(() {
        this._stepIdx++;
      });
    }
  }

  Future<void> onPressNext2LocationStep() async {
    if (this._otpCode.length == this._otpCodeLength) {
      await verifyOtp();
    }
  }

  void verifyOtp() async {
    print('void verifyOtp() async');
    if (this._otpCode == _con.OTP) {
      User u = await _con.verifyOtp();
      if(u != null && u.isValid) {
        // login suggest.
        setState(() {
          this._stepIdx++;
        });
      } else {
        _con.showErr(S.of(context).invalidOTP);
      }
    } else {
      _con.showErr(S.of(context).invalidOTP);
    }
  }

  void onPressSaveLocation() {
    _con.addAddress();
    setState(() {
      this._stepIdx++;
    });
  }

  void onPressYesRegMe() {}

  String _currentSelectedValue;

  Widget buildGenderDropdown() {
    var genders = [
      S.of(context).notToTell,
      S.of(context).male,
      S.of(context).female,
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: DropdownButtonFormField(
        items: genders.map((String category) {
          return new DropdownMenuItem(
              value: category,
              child: Text(category, style: this.txtStyleAccent)
          );
        }).toList(),
        onChanged: (newValue) {
          // do other stuff with _category
          setState(() => _currentSelectedValue = newValue);
        },
        value: _currentSelectedValue,
        decoration: buildInputDecorationForLocation(context, S.of(context).gender),
      ),
    );

    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: buildInputDecorationForLocation(context, S.of(context).gender),
          isEmpty: _currentSelectedValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _currentSelectedValue = newValue;
                  state.didChange(newValue);
                });
              },
              items: genders.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
