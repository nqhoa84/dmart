import 'dart:async';

import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/register_controller.dart';
import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/i_name.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/pkg/sms_otp_auto_1.2/src/sms_retrieved.dart';
import 'package:dmart/src/pkg/sms_otp_auto_1.2/src/text_field_pin.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/TitleDivider.dart';
import 'package:dmart/src/widgets/profile/profile_common.dart';
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
import '../repository/user_repository.dart' as userRepo;

class SignUpFbScreen extends StatefulWidget {
  final String fbId, name, avatarUrl, accessToken;

  SignUpFbScreen({@required this.fbId, this.name, this.avatarUrl, this.accessToken});

  @override
  _SignUpFbScreenState createState() => _SignUpFbScreenState();
}

class _SignUpFbScreenState extends StateMVC<SignUpFbScreen> {
  RegController _con;
  int _stepIdx = 0;

  int _otpCodeLength = 6;
  String _userEnteredOtp = "";

  _SignUpFbScreenState() : super(RegController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _con.getProvinces();
    _getSignatureCode();
  }

  /// get signature code
  _getSignatureCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    print("signature $signature");
  }

  _onOtpCallBack(String otpCode, bool isAutofill) async {
//    print("_onOtpCallBack $otpCode -- $isAutofill");
    this._userEnteredOtp = otpCode;
    if (otpCode.length == this._otpCodeLength) {
      await verifyOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: createAppBarLogo(context, haveBackIcon: this._stepIdx < 2),
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      body: SafeArea(
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
//            setState(() {
//              _stepIdx = index;
//            });
          },
          steps: [
            Step(
              title: SizedBox(),
              content: _buildMobileOtpWidget(context),
              isActive: (_stepIdx == 0),
            ),
            Step(
              title: SizedBox(),
              content: _buildVerificationWidget(context),
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

  get txtStyleHeadline => Theme.of(context).textTheme.headline6;

  get txtStyleGrey => Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey);

//  get txtStyleAccent => Theme.of(context).textTheme.subtitle1.copyWith(color: DmConst.accentColor);
  final txtStyleAccent = TextStyle(color: DmConst.accentColor);

  Widget _buildMobileOtpWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).providePhoneNoAndTapSendOtpToVerify,
          style: txtStyleHeadline,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildMobileExistedWid(context),
            Form(
                key: _con.regFormKey,
                child: PhoneNoWid(onSaved: (value) => _con.user.phone = value)),

            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    onPressed: _con.loading ? null : _onPressSendOtp,
                    child: Text(_con.loading == false ? S.of(context).next : S.of(context).processing,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                    color: DmConst.accentColor,
//                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),

            Offstage(
              offstage: DmUtils.isNullOrEmptyStr(_con.OTP),
              child: _buildVerificationWidget(context),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerificationWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
        buildOtpExpiredWidget(context),
        Text('${_con.OTP}', style: TextStyle(color: Colors.grey.shade400)),
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressNext2LocationStep,
                child: Text(S.of(context).register,
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

  Widget buildOtpExpiredWidget(BuildContext context) {
    return Offstage(
      offstage: _con.otpExpInSeconds == null,
      child: Row(children: [
        Text('${S.of(context).otpExpiredIn} ${_con.otpMin}:${_con.otpSecond.toString().padLeft(2, '0')}',
            style: txtStyleGrey),
        FlatButton(
            onPressed: _con.otpExpInSeconds != null && _con.otpExpInSeconds > 0 ? null : resendOtp,
            child: Text(S.of(context).resend))
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
                onPressed: () {
                  setState(() {
                    _stepIdx++;
                  });
                },
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
                              onSaved: (input) => _con.address.address = input.trim(),
                              validator: (input) =>
                                  DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
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
                              validator: (input) =>
                                  DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                              decoration: buildInputDecorationForLocation(context, S.of(context).streetName),
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
                        VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
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
                              onSaved: (input) => _con.address.description = input.trim(),
                              decoration: buildInputDecorationForLocation(context, S.of(context).note),
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
                      _con.user.name = input.trim();
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
              ],
            )),

        SizedBox(height: 10),
        Text(S.of(context).dateOfBirthNote, style: txtStyleGrey),
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
                    itemStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)), onConfirm: (date) {
              _con.user.birthday = date;
              print('confirm $date');
            }, onChanged: (date) {
              setState(() {
                _con.user.birthday = date;
              });
            }, currentTime: _con.user.birthday, locale: LocaleType.en);
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
                        context, _con.user.birthday != null ? _con.user.birthday.day.toString() : S.of(context).day),
                  )),
                  VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                  Expanded(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    enabled: false,
                    decoration: buildInputDecorationForLocation(context,
                        _con.user.birthday != null ? _con.user.birthday.month.toString() : S.of(context).month),
                  )),
                  VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                  Expanded(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    enabled: false,
                    decoration: buildInputDecorationForLocation(
                        context, _con.user.birthday != null ? _con.user.birthday.year.toString() : S.of(context).year),
                  )),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
//        Text(S.of(context).personalDetailNote, textAlign: TextAlign.center),
//        SizedBox(height: 10),
        //button Save.
        Row(
          children: [
            Expanded(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                onPressed: onPressYesRegMe,
                child: Text(S.of(context).yesRegMe,
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

  _onPressSendOtp() async {
//    await _con.register();
//    if (DmUtils.isNotNullEmptyStr(_con.OTP)) {
//      setState(() {
//        this._stepIdx++;
//      });
//    }
  }

  Future<void> onPressNext2LocationStep() async {
    if (this._userEnteredOtp.length == this._otpCodeLength) {
      await verifyOtp();
    }
  }

  void verifyOtp() async {
    print('void verifyOtp() async');
    if (this._userEnteredOtp == _con.OTP) {
      User u = await _con.verifyOtp();
      if (u != null && u.isValid) {
        // login suggest.
        setState(() {
          _con.getProvinces();
          this._stepIdx++;
        });
      } else {
        _con.showErr(S.of(context).invalidOTP);
      }
    } else {
      _con.showErr(S.of(context).invalidOTP);
    }
  }

  void onPressSaveLocation() async {
    //this step will now call api to save data.
    _con.locationFormKey.currentState.save();
    if (_con.locationFormKey.currentState.validate()) {
      setState(() {
        this._stepIdx++;
      });
    }
//    bool saveOK = await _con.addAddress();
  }

  void onPressYesRegMe() async {
    _con.personalFormKey.currentState.save();
    if (_con.personalFormKey.currentState.validate()) {
      _con.address.phone = _con.user.phone;
      _con.address.fullName = _con.user.name;
      _con.address.userId = _con.user.id;
      _con.address.isDefault = true;

      print('--start add address');
//      bool a = await _con.addAddress();
      print('--start _con.updateUser()');
      bool b = await _con.updateUser();
      if (b) {
        //to thank you page.
        RouteGenerator.gotoProfileUpdatedScreen(context);
      } else {
        _con.showMsg(S.of(context).generalErrorMessage);
      }
    }
  }

  Widget buildGenderDropdown() {
    var _genders = [
      S.of(context).notToTell,
      S.of(context).male,
      S.of(context).female,
    ];
    List<DropdownMenuItem> its = [
      DropdownMenuItem<Gender>(value: Gender.Others, child: Text(S.of(context).notToTell, style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(value: Gender.Male, child: Text(S.of(context).male, style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(value: Gender.Female, child: Text(S.of(context).female, style: this.txtStyleAccent)),
    ];
//    _genders.forEach((pro) {
////      print(pro);
//      its.add(DropdownMenuItem<Gender>(value: Gender.Female, child: Text(pro, style: this.txtStyleAccent)));
//    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: DropdownButtonFormField(
        items: its,
        onChanged: (newValue) {
          setState(() => _con.user.gender = newValue);
        },
//        value: _con.address.province,
        onSaved: (value) => _con.user.gender = value,
        validator: (value) => value == null ? S.of(context).invalidGender : null,
        decoration: buildInputDecorationForLocation(context, S.of(context).gender),
      ),
    );
  }

  Widget buildProvincesDropDown() {
    List<DropdownMenuItem> its = [];
    _con.provinces.forEach((pro) {
//      print(pro);
      its.add(DropdownMenuItem<Province>(value: pro, child: Text(pro.name, style: this.txtStyleAccent)));
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: DropdownButtonFormField(
        items: its,
        onChanged: (newValue) async {
          setState(() => _con.address.province = newValue);
          await _con.getDistricts(_con.address.province.id);
          setState(() {
            _con.wards.clear();
            _con.address.district = null;
            _con.address.ward = null;
          });
        },
        value: _con.address.province,
        onSaved: (value) => _con.address.province = value,
        validator: (value) => value == null ? S.of(context).invalidProvince : null,
        decoration: buildInputDecorationForLocation(context, S.of(context).province),
      ),
    );
  }

  Widget buildDistrictsDropDown() {
    List<DropdownMenuItem> its = [];
    _con.districts.forEach((dis) {
      its.add(DropdownMenuItem(value: dis, child: Text(dis.name, style: this.txtStyleAccent)));
    });
    return DropdownButtonFormField(
      items: its,
      onChanged: (newValue) async {
        // do other stuff with _category
        setState(() => _con.address.district = newValue);
        await _con.getWards(_con.address.district.id);
        setState(() => _con.address.ward = null);
      },
      value: _con.address.district,
      onSaved: (value) => _con.address.district = value,
      validator: (value) => value == null ? S.of(context).invalidDistrict : null,
      decoration: buildInputDecorationForLocation(context, S.of(context).district),
    );
  }

  Widget buildWardsDropDown() {
    List<DropdownMenuItem> its = [];
    _con.wards.forEach((w) {
      its.add(DropdownMenuItem(value: w, child: Text(w.name, style: this.txtStyleAccent)));
    });
    return DropdownButtonFormField(
      items: its,
      onChanged: (newValue) {
        _con.address.ward = newValue;
//        setState(() => _con.address.ward = newValue);
      },
      value: _con.address.ward,
      onSaved: (value) => _con.address.ward = value,
      validator: (value) => value == null ? S.of(context).invalidWard : null,
      decoration: buildInputDecorationForLocation(context, S.of(context).commune),
    );
  }
}
