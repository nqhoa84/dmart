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
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

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
//    _con.user.name = widget.name;
//    _con.user.facebookId = widget.fbId;
//    _con.user.fbAvatar = widget.avatarUrl;
//    _con.user.fbAccessToken = widget.accessToken;
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
          S.current.providePhoneNoAndTapSendOtpToVerify,
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
                    onPressed: _con.loading || DmUtils.isNotNullEmptyStr(_con.OTP) ? null : _onPressSendOtp,
                    child: Text(_con.loading == false ? S.current.requestOtp : S.current.processing,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                    color: DmConst.accentColor,
                    disabledColor: DmConst.accentColor,
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
          S.current.input6digitCode,
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
        Text('${S.current.otpExpiredIn} ${_con.otpMin}:${_con.otpSecond.toString().padLeft(2, '0')}',
            style: txtStyleGrey),
        FlatButton(
            onPressed: _con.otpExpInSeconds != null && _con.otpExpInSeconds > 0 ? null : resendOtp,
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
                child: Text("Dmart24.com", style: TextStyle(color: DmConst.accentColor)),
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
                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
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
                              onSaved: (input) => _con.address.address = input.trim(),
                              validator: (input) =>
                                  DmUtils.isNullOrEmptyStr(input) ? S.current.invalidAddress : null,
                              decoration: buildInputDecorationForLocation(context, S.current.houseNo),
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
                                  DmUtils.isNullOrEmptyStr(input) ? S.current.invalidAddress : null,
                              decoration: buildInputDecorationForLocation(context, S.current.streetName),
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
                              decoration: buildInputDecorationForLocation(context, S.current.note),
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
                      _con.user.name = input.trim();
                    },
                    validator: (value) => DmUtils.isNullOrEmptyStr(value) ? S.current.invalidFullName : null,
                    decoration: buildInputDecorationForLocation(context, S.current.fullName),
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
                    validator: (value) => !DmUtils.isEmail(value) ? S.current.invalidEmail : null,
                    decoration: buildInputDecorationForLocation(context, S.current.email),
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
                        context, _con.user.birthday != null ? _con.user.birthday.day.toString() : S.current.day),
                  )),
                  VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                  Expanded(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    enabled: false,
                    decoration: buildInputDecorationForLocation(context,
                        _con.user.birthday != null ? _con.user.birthday.month.toString() : S.current.month),
                  )),
                  VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                  Expanded(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    style: txtStyleAccent,
                    textAlignVertical: TextAlignVertical.center,
                    enabled: false,
                    decoration: buildInputDecorationForLocation(
                        context, _con.user.birthday != null ? _con.user.birthday.year.toString() : S.current.year),
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
                S.current.loginErrorIncorrectPhonePassFullMsg,
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
      return S.current.invalidPhone;
    else {
      return null;
    }
  }

  _onPressSendOtp() async {
    _con.user.name = widget.name;
    _con.user.facebookId = widget.fbId;
    _con.user.fbAvatar = widget.avatarUrl;
    _con.user.fbAccessToken = widget.accessToken;
    _con.sendOtpFb();
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
        _con.showErr(S.current.invalidOTP);
      }
    } else {
      _con.showErr(S.current.invalidOTP);
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
        _con.showMsg(S.current.generalErrorMessage);
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
      DropdownMenuItem<Gender>(value: Gender.Others, child: Text(S.current.notToTell, style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(value: Gender.Male, child: Text(S.current.male, style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(value: Gender.Female, child: Text(S.current.female, style: this.txtStyleAccent)),
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
        validator: (value) => value == null ? S.current.invalidGender : null,
        decoration: buildInputDecorationForLocation(context, S.current.gender),
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
        validator: (value) => value == null ? S.current.invalidProvince : null,
        decoration: buildInputDecorationForLocation(context, S.current.province),
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
      validator: (value) => value == null ? S.current.invalidDistrict : null,
      decoration: buildInputDecorationForLocation(context, S.current.district),
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
      validator: (value) => value == null ? S.current.invalidWard : null,
      decoration: buildInputDecorationForLocation(context, S.current.commune),
    );
  }
}
