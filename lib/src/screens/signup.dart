import 'dart:async';

import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/register_controller.dart';
import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:dmart/src/widgets/profile/profile_common.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../DmState.dart';
import '../../buidUI.dart';
import '../../constant.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import '../../utils.dart';
import '../../generated/l10n.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends StateMVC<SignUpScreen> {
  RegController _con = RegController();
  int _stepIdx = 0;

  int? _otpCodeLength = 6;
  String? _userEnteredOtp = "";

  _SignUpScreenState() : super(RegController()) {
    _con = controller as RegController;
  }

  @override
  void initState() {
    super.initState();
    _con.getProvinces();
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {
    // String signature = await SmsRetrieved!.getAppSignature()!;
    // print("signature $signature");
  }

  _onOtpCallBack(String otpCode, bool isAutofill) async {
//    print("_onOtpCallBack $otpCode -- $isAutofill");
    this._userEnteredOtp = otpCode;
    if (otpCode.length == this._otpCodeLength) {
      verifyOtp();
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
        leading: this._stepIdx >= 2
            ? null
            : InkWell(
                onTap: () {
                  if (Navigator.of(context).canPop()) Navigator.pop(context);
                },
                child: Icon(UiIcons.return_icon, color: DmConst.accentColor)),
        title: InkWell(
            onTap: () => RouteGenerator.gotoHome(context),
            child: Image.asset(DmConst.assetImgLogo,
                width: 46, height: 46, fit: BoxFit.scaleDown)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Divider(height: 4, thickness: 2, color: DmConst.accentColor),
        ),
      ),
      bottomNavigationBar:
          DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
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
      constraints:
          BoxConstraints.expand(height: MediaQuery.of(context).size.height),
      child: Theme(
        data: ThemeData(primaryColor: DmConst.accentColor),

        ///TODO change to latest version to use optional steppers
        /// https://material.io/archive/guidelines/components/steppers.html#
        child: Stepper(
          type: StepperType.horizontal,
          controlsBuilder: (BuildContext context, ControlsDetails) =>
              Container(),
          currentStep: _stepIdx,
          onStepTapped: (index) {
//            setState(() {
//              _stepIdx = index;
//            });
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

  get txtStyleGrey =>
      Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey);

//  get txtStyleAccent => Theme.of(context).textTheme.subtitle1.copyWith(color: DmConst.accentColor);
  final txtStyleAccent = TextStyle(color: DmConst.accentColor);

  Widget buildMobileNoAndPassWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.current.mobileNoAndPass,
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
              PhoneNoWid(
                onSaved: (input) {
                  _con.user!.phone = input!;
                },
                initValue: '',
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 5),
              //   decoration: buildBoxDecorationForTextField(context),
              //   child: TextFormField(
              //       style: txtStyleAccent,
              //       textAlignVertical: TextAlignVertical.center,
              //       keyboardType: TextInputType.number,
              //       onSaved: (input) {
              //         _con.user.phone = input;
              //       },
              //       validator: _phoneValidate,
              //       decoration: new InputDecoration(
              //         hintText: S.current.phone,
              //         hintStyle: txtStyleAccent,
              //         enabledBorder:
              //             UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
              //         focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
              //         prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
              //       ),
              //       inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]),
              // ),

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
                  onSaved: (input) => _con.user!.password = input,
                  validator: (input) =>
                      input!.length < 4 ? S.current.passwordNote : null,
                  obscureText: _con.hidePassword!,
                  decoration: new InputDecoration(
                    hintText: S.current.password,
                    hintStyle: txtStyleAccent,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: DmConst.accentColor.withOpacity(0.2))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DmConst.accentColor)),
                    prefixIcon:
                        Icon(UiIcons.padlock_1, color: DmConst.accentColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _con.hidePassword = !_con.hidePassword!;
                        });
                      },
                      color: DmConst.accentColor.withOpacity(0.4),
                      icon: Icon(_con.hidePassword!
                          ? Icons.visibility_off
                          : Icons.visibility),
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
                    print('-$input---${_con.user!.password}-');
                    if (input != null && input == _con.user!.password) {
                      return null;
                    } else {
                      return S.current.passwordNotMatch;
                    }
                  },
                  obscureText: _con.hidePassword2!,
                  decoration: new InputDecoration(
                    hintText: S.current.confirmPassword,
                    hintStyle: txtStyleAccent,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: DmConst.accentColor.withOpacity(0.2))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DmConst.accentColor)),
                    prefixIcon:
                        Icon(UiIcons.padlock_1, color: DmConst.accentColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _con.hidePassword2 = !_con.hidePassword2!;
                        });
                      },
                      color: DmConst.accentColor.withOpacity(0.4),
                      icon: Icon(_con.hidePassword2!
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
              ),
              Text(S.current.passwordNote, style: txtStyleGrey),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      onPressed: _con.loading ? null : onPressNext2VerifyStep,
                      child: Text(
                          _con.loading == false
                              ? S.current.next
                              : S.current.processing,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.white)),
                      color: DmConst.accentColor,
//                    shape: StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildVerificationWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.current.verification,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          S.current.input6digitCode,
          style: TextStyle(color: DmConst.accentColor),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        //! comment by hoang
        // TextFieldPin(
        //   onChange: () {} as dynamic,
        //   defaultBoxSize: 0,
        //   // filled: true,
        //   // filledColor: DmConst.bgrColorSearchBar,
        //   codeLength: _otpCodeLength!,
        //   // boxSize: 40,
        //   margin: 2,
        //   // filledAfterTextChange: false,
        //   textStyle: txtStyleAccent.copyWith(fontSize: 20),
        //   // borderStyle: OutlineInputBorder(
        //   //     borderSide: BorderSide(color: DmConst.accentColor),
        //   //     borderRadius: BorderRadius.circular(5)),
        //   // borderStyeAfterTextChange: OutlineInputBorder(
        //   //     borderSide: BorderSide(color: DmConst.accentColor),
        //   //     borderRadius: BorderRadius.circular(5)),
        //   // onOtpCallback: (code, isAutofill) => _onOtpCallBack(code, isAutofill),
        // ),
        SizedBox(height: 10),
        Text(S.current.verifyOtpNote, style: txtStyleGrey),
        buildOtpExpiredWidget(context),
        Text('${_con.OTP}', style: TextStyle(color: Colors.grey.shade400)),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressNext2LocationStep,
                child: Text(S.current.register,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildOtpExpiredWidget(BuildContext context) {
    return Offstage(
      offstage: _con.otpExpInSeconds == null,
      child: Row(children: [
        Text(
            '${S.current.otpExpiredIn} ${_con.otpMin}:${_con.otpSecond.toString().padLeft(2, '0')}',
            style: txtStyleGrey),
        FlatButton(
            onPressed: _con.otpExpInSeconds > 0 ? null : resendOtp,
            child: Text(S.current.resend))
      ]),
    );
  }

  void resendOtp() {
    _con.resendOtp();
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
              Text(S.current.yourPhoneRegOK),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(S.current.welcomeTo),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Dmart24.com",
                    style: TextStyle(color: DmConst.accentColor)),
              ),
              Text(S.current.enjoyShopping),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () {
                  RouteGenerator.gotoHome(context);
                },
                child: Text(S.current.startShopping,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TitleDivider(title: S.current.personalDetails),
        SizedBox(height: 10),
        Text(S.current.personalDetailNote),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () {
                  setState(() {
                    _stepIdx++;
                  });
                },
                child: Text(S.current.next,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
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
          S.current.location,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(S.current.locationNote, style: txtStyleGrey),
        Form(
            key: _con.locationFormKey,
            child: Column(
              children: [
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
                              onSaved: (input) =>
                                  _con.address!.address = input!.trim(),
                              validator: (input) =>
                                  DmUtils.isNullOrEmptyStr(input!)
                                      ? S.current.invalidAddress
                                      : null,
                              decoration: buildInputDecorationForLocation(
                                  context, S.current.houseNo),
                            ),
                          ),
                        ),
                        VerticalDivider(
                            width: 10,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.white),
                        //            SizedBox(width: 2, height: 100, child: Container(color: Colors.white)),
                        Expanded(
                          child: Container(
                            child: TextFormField(
                              style: txtStyleAccent,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  _con.address!.street = input!.trim(),
                              validator: (input) =>
                                  DmUtils.isNullOrEmptyStr(input!)
                                      ? S.current.invalidAddress
                                      : null,
                              decoration: buildInputDecorationForLocation(
                                  context, S.current.streetName),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                buildProvincesDropDown(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: buildBoxDecorationForTextField(context),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: buildDistrictsDropDown(),
                        ),
                        VerticalDivider(
                            width: 10,
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                            color: Colors.white),
                        //            SizedBox(width: 2, height: 100, child: Container(color: Colors.white)),
                        Expanded(
                          child: buildWardsDropDown(),
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
                              onSaved: (input) =>
                                  _con.address!.description = input!.trim(),
                              decoration: buildInputDecorationForLocation(
                                  context, S.current.note),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressSaveLocation,
                child: Text(S.current.next,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey.shade700),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () => RouteGenerator.gotoHome(context),
                child: Text(S.current.startShopping,
                    style: Theme.of(context).textTheme.headline6),
                // borderSide: BorderSide(color: DmConst.accentColor, width: 2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration buildInputDecorationForLocation(
      BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: this.txtStyleAccent,
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DmConst.accentColor)),
    );
  }

  Widget buildPersonalDetailWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.current.personalDetails,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Form(
            key: _con.personalFormKey,
            child: Column(
              children: [
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
//                      if (DmUtils.isNullOrEmptyStr(input)) return;
//                      input = input.trim();
                      _con.user!.name = input!.trim();
                    },
                    validator: (value) => DmUtils.isNullOrEmptyStr(value!)
                        ? S.current.invalidFullName
                        : null,
                    decoration: buildInputDecorationForLocation(
                        context, S.current.fullName),
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
                      _con.user!.email = input!.trim();
                    },
                    validator: (value) => !DmUtils.isEmail(value!)
                        ? S.current.invalidEmail
                        : null,
                    decoration: buildInputDecorationForLocation(
                        context, S.current.email),
                  ),
                ),
              ],
            )),

        SizedBox(height: 10),
        Text(S.current.dateOfBirthNote, style: txtStyleGrey),
        InkWell(
          onTap: () {
            print('tap to select birthday');
            DatePicker.showDatePicker(context,
                showTitleActions: false,
                minTime: DateTime(1930, 1, 1),
                maxTime: DateTime.now().subtract(Duration(days: 3650)),
                theme: DatePickerTheme(
//                          headerColor: Colors.orange,
                    backgroundColor: DmConst.accentColor,
                    itemStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                onConfirm: (date) {
              _con.user!.birthday = date;
              print('confirm $date');
            }, onChanged: (date) {
              setState(() {
                _con.user!.birthday = date;
              });
            }, currentTime: _con.user!.birthday!, locale: LocaleType.en);
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
                    decoration: buildInputDecorationForLocation(
                        context,
                        _con.user!.birthday != null
                            ? _con.user!.birthday!.day.toString()
                            : S.current.day),
                  )),
                  VerticalDivider(
                      width: 10,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                      color: Colors.white),
                  Expanded(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    enabled: false,
                    decoration: buildInputDecorationForLocation(
                        context,
                        _con.user!.birthday != null
                            ? _con.user!.birthday!.month.toString()
                            : S.current.month),
                  )),
                  VerticalDivider(
                      width: 10,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                      color: Colors.white),
                  Expanded(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    enabled: false,
                    decoration: buildInputDecorationForLocation(
                        context,
                        _con.user!.birthday != null
                            ? _con.user!.birthday!.year.toString()
                            : S.current.year),
                  )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
//        Text(S.current.personalDetailNote, textAlign: TextAlign.center),
//        SizedBox(height: 10),
        //button Save.
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressYesRegMe,
                child: Text(S.current.yesRegMe,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white)),
                color: DmConst.accentColor,
//                    shape: StadiumBorder(),
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey.shade700),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: () => RouteGenerator.gotoHome(context),
                child: Text(S.current.startShopping,
                    style: Theme.of(context).textTheme.headline6),
                // borderSide: BorderSide(color: DmConst.accentColor, width: 2),
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
            Icon(Icons.error,
                color: DmConst.colorFavorite, size: kToolbarHeight),
            Expanded(
              child: Text(
                S.current.loginErrorIncorrectPhonePassFullMsg,
                style: TextStyle(color: DmConst.colorFavorite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _phoneValidate(String value) {
    if (!DmUtils.isPhone(value.trim()))
      return S.current.invalidPhone;
    else {
      return null;
    }
  }

  onPressNext2VerifyStep() async {
    _con.register();
    if (DmUtils.isNotNullEmptyStr(_con.OTP!)) {
      setState(() {
        this._stepIdx++;
      });
    }
  }

  Future<void> onPressNext2LocationStep() async {
    if (this._userEnteredOtp!.length == this._otpCodeLength) {
      verifyOtp();
    }
  }

  void verifyOtp() async {
    print('void verifyOtp() async');
    if (this._userEnteredOtp == _con.OTP) {
      User u = await _con.verifyOtp();
      if (u.isValid) {
        // login suggest.
        setState(() {
          _con.getProvinces();
          this._stepIdx++;
        });
      } else {
        _con.showErr(S.current.invalidOTP);
      }
    } else {
      _con.showErr(S.current.invalidOTP);
    }
  }

  void onPressSaveLocation() async {
    //this step will now call api to save data.
    _con.locationFormKey!.currentState!.save();
    if (_con.locationFormKey!.currentState!.validate()) {
      setState(() {
        this._stepIdx++;
      });
    }
//    bool saveOK = await _con.addAddress();
  }

  void onPressYesRegMe() async {
    _con.personalFormKey!.currentState!.save();
    if (_con.personalFormKey!.currentState!.validate()) {
      if (!_con.address!.isValid) {
        _con.address!.phone = _con.user!.phone;
        _con.address!.fullName = _con.user!.name;
        _con.address!.userId = _con.user!.id;
        _con.address!.isDefault = true;
        print('--start add address');
        bool a = await _con.addAddress();
      }

      print('--start _con.updateUser()');
      bool b = await _con.updateUser();
      if (b) {
        //to thank you page.
        RouteGenerator.gotoProfileUpdatedScreen(context);
      }
    }
  }

  Widget buildGenderDropdown() {
    var _genders = [
      S.current.notToTell,
      S.current.male,
      S.current.female,
    ];
    List<DropdownMenuItem> its = [
      DropdownMenuItem<Gender>(
          value: Gender.Others,
          child: Text(S.current.notToTell, style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(
          value: Gender.Male,
          child: Text(S.current.male, style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(
          value: Gender.Female,
          child: Text(S.current.female, style: this.txtStyleAccent)),
    ];
//    _genders.forEach((pro) {
////      print(pro);
//      its.add(DropdownMenuItem<Gender>(value: Gender.Female, child: Text(pro, style: this.txtStyleAccent)));
//    });
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: buildBoxDecorationForTextField(context),
        child: Container()
//! comment by hoang
//        DropdownButtonFormField(
//         items: its,
//         onChanged: (newValue) {
//           setState(() => _con.user!.gender = newValue as dynamic);
//         },
// //        value: _con.address.province,
//         onSaved: (value) => _con.user!.gender = value as dynamic,
//         validator: (value) => value == null ? S.current.invalidGender : null,
//         decoration: buildInputDecorationForLocation(context, S.current.gender),
//       ),
        );
  }

  Widget buildProvincesDropDown() {
    List<DropdownMenuItem> its = [];
    _con.provinces?.forEach((pro) {
//      print(pro);
      its.add(DropdownMenuItem<Province>(
          value: pro, child: Text(pro.name, style: this.txtStyleAccent)));
    });
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: buildBoxDecorationForTextField(context),
        child: Container()
        //! comment by hoang
        // DropdownButtonFormField(
        //   items: its,
        //   onChanged: (newValue) async {
        //     setState(() => _con.address.province = newValue as dynamic);
        //     _con.getDistricts(_con.address.province!.id);
        //     setState(() {
        //       _con.wards.clear();
        //       _con.address.district = null;
        //       _con.address.ward = null;
        //     });
        //   },
        //   value: _con.address.province,
        //   onSaved: (value) => _con.address.province = value as dynamic,
        //   validator: (value) => value == null ? S.current.invalidProvince : null,
        //   decoration:
        //       buildInputDecorationForLocation(context, S.current.province),
        // ),
        );
  }

  Widget buildDistrictsDropDown() {
    List<DropdownMenuItem> its = [];
    _con.districts?.forEach((dis) {
      its.add(DropdownMenuItem(
          value: dis, child: Text(dis.name, style: this.txtStyleAccent)));
    });
    return Container();
    //! comment by hoang
    //  DropdownButtonFormField(
    //   items: its,
    //   onChanged: (newValue) async {
    //     // do other stuff with _category
    //     setState(() => _con.address.district = newValue as dynamic);
    //     _con.getWards(_con.address.district!.id);
    //     setState(() => _con.address.ward = null);
    //   },
    //   value: _con.address.district,
    //   onSaved: (value) => _con.address.district = value as dynamic,
    //   validator: (value) => value == null ? S.current.invalidDistrict : null,
    //   decoration: buildInputDecorationForLocation(context, S.current.district),
    // );
  }

  Widget buildWardsDropDown() {
    List<DropdownMenuItem> its = [];
    _con.wards?.forEach((w) {
      its.add(DropdownMenuItem(
          value: w, child: Text(w.name, style: this.txtStyleAccent)));
    });
    return Container();
//     return DropdownButtonFormField(
//       items: its,
//       onChanged: (newValue) {
//         _con.address.ward = newValue as dynamic;
// //        setState(() => _con.address.ward = newValue);
//       },
//       value: _con.address.ward,
//       onSaved: (value) => _con.address.ward = value as dynamic,
//       validator: (value) => value == null ? S.current.invalidWard : null,
//       decoration: buildInputDecorationForLocation(context, S.current.commune),
//     );
  }
}
