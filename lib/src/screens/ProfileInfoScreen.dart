import 'package:dmart/DmState.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/controllers/delivery_addresses_controller.dart';
import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/screens/addressesScreen.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/profile/profile_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../utils.dart';
import '../controllers/settings_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/PaymentSettingsDialog.dart';
import '../widgets/ProfileSettingsDialog.dart';
import '../widgets/SearchBar.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import '../helpers/ui_icons.dart';

class ProfileInfoScreen extends StatefulWidget {
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends StateMVC<ProfileInfoScreen> {
  ProfileInfoController _con;

  _ProfileInfoScreenState() : super(ProfileInfoController()) {
    _con = controller;
  }

  User u;

  @override
  void initState() {
    u = currentUser.value;
    _con.user = u;
    super.initState();

    _con.getAddrs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).myAccount),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(padding: const EdgeInsets.all(DmConst.masterHorizontalPad), child: buildContent(context)),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        ListTile(
          trailing: CircleAvatar(backgroundImage: NetworkImage(u.image.thumb)),
          title: Text(
            '${S.of(context).welcome} ${u.fullNameWithTitle}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildPersonalDetailStack(context),
        SizedBox(height: DmConst.masterHorizontalPad),
        buildAddressDetailStack(context),
//        FlatButton(
//          onPressed: _onPressAddressesButton,
//          child: Text('lasfklsdf'),
//          color: DmConst.accentColor),
        SizedBox(height: DmConst.masterHorizontalPad),
        buildChangePassStack(context),
      ],
    );
  }

  final txtStyleBold = TextStyle(fontWeight: FontWeight.bold);
  final txtStyleGrey = TextStyle(color: Colors.grey);
  final txtStyleAccent = TextStyle(color: DmConst.accentColor);

  Stack buildPersonalDetailStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: createRoundedBorderBoxDecoration(),
          padding: EdgeInsets.fromLTRB(DmConst.masterHorizontalPad, DmConst.masterHorizontalPad * 2,
              DmConst.masterHorizontalPad, DmConst.masterHorizontalPad),
//          width: double.infinity,
          child: Form(
            key: _con.personalDetailFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).fullName, style: txtStyleBold),
                Row(
                  children: [
                    SizedBox(width: 100, child: buildGenderDropdown()),
                    SizedBox(width: DmConst.masterHorizontalPad),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: buildBoxDecorationForTextField(context),
                        child: TextFormField(
                          style: txtStyleAccent,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.text,
                          onSaved: (input) {
                            u.name = input.trim();
                          },
                          onChanged: (value) {
                            setState(() { _con.isPersonalChange = true;});
                          },
                          initialValue: u.name,
                          validator: (value) => DmUtils.isNullOrEmptyStr(value) ? S.of(context).invalidFullName : null,
                          decoration: buildInputDecoration(context, S.of(context).fullName),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.of(context).dateOfBirth, style: txtStyleBold),
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
                      u.birthday = date;
                    }, onChanged: (date) {
                      setState(() {
                        u.birthday = date;
                      });
                    }, currentTime: u.birthday, locale: LocaleType.en);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: buildBoxDecorationForTextField(context),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            enabled: false,
                            decoration: buildInputDecoration(
                                context, u.birthday != null ? u.birthday.day.toString() : S.of(context).day),
                          )),
                          VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            enabled: false,
                            decoration: buildInputDecoration(
                                context, u.birthday != null ? u.birthday.month.toString() : S.of(context).month),
                          )),
                          VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                          Expanded(
                              child: TextFormField(
                            textAlign: TextAlign.center,
                            style: txtStyleAccent,
                            textAlignVertical: TextAlignVertical.center,
                            enabled: false,
                            decoration: buildInputDecoration(
                                context, u.birthday != null ? u.birthday.year.toString() : S.of(context).year),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(S.of(context).dateOfBirthNote, style: txtStyleGrey),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.of(context).mobilePhoneNumber, style: txtStyleBold),
                PhoneNoWid(initValue: u.phone, onSaved: (value) => u.phone = value, enable: false),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.of(context).email, style: txtStyleBold),
                EmailWid(initValue: u.email,
                    onSaved: (value) {
                      u.email = value;
                      print('current email value');
                    },
                    onChanged: (value) {
                      setState(() { _con.isPersonalChange = true;});
                    }),
                SizedBox(height: DmConst.masterHorizontalPad),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        onPressed: _con.loading || _con.isPersonalChange == false ? null : onPressSavePersonDetail,
                        child: Text(_con.loading == false? S.of(context).save : S.of(context).processing,
                            style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                        color: DmConst.accentColor,
                        disabledColor: DmConst.accentColor.withOpacity(0.8),
                        disabledTextColor: Colors.grey,
//                    shape: StadiumBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        buildTitle(context, title: S.of(context).personalDetails)
      ],
    );
  }

  Stack buildAddressDetailStack(BuildContext context) {

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: createRoundedBorderBoxDecoration(),
          padding: EdgeInsets.fromLTRB(DmConst.masterHorizontalPad, DmConst.masterHorizontalPad * 2,
              DmConst.masterHorizontalPad, DmConst.masterHorizontalPad),
//          width: double.infinity,
          child: AddressInfoWid(address: _con.defaultAddress),
        ),
        buildTitle(context, title: '${S.of(context).deliveryAddresses} >>',
        onPressedOnTitle: _onPressAddressesButton)
      ],
    );
  }

  String userEnterPass;
  Stack buildChangePassStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: createRoundedBorderBoxDecoration(),
          padding: EdgeInsets.fromLTRB(DmConst.masterHorizontalPad, DmConst.masterHorizontalPad * 2,
              DmConst.masterHorizontalPad, DmConst.masterHorizontalPad),
//          width: double.infinity,
          child: Form(
            key: _con.changePassFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).currentPassword, style: txtStyleBold),
                PasswordWid(initValue: "",onSaved: (value) => _con.currentPass = value),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.of(context).mobilePhoneNumber, style: txtStyleBold),
                PhoneNoWid(initValue: u.phone, enable: false),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.of(context).newPassword, style: txtStyleBold),
                PasswordWid(onSaved: (value) => _con.newPass = value),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.of(context).confirmNewPass, style: txtStyleBold),
                PasswordConfirmWid(onValidate: (value) => _con.newPass == value ? null : S.of(context).passwordNotMatch),
                SizedBox(height: DmConst.masterHorizontalPad),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        onPressed: _con.loading ? null : onPressChangePass,
                        child: Text(_con.loading == false? S.of(context).save : S.of(context).processing,
                            style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                        color: DmConst.accentColor,
                        disabledColor: DmConst.accentColor.withOpacity(0.8),
                        disabledTextColor: Colors.grey,
//                    shape: StadiumBorder(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        buildTitle(context, title: S.of(context).changePassword)
      ],
    );
  }

  Align buildTitle(BuildContext context, {String title, Function() onPressedOnTitle}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: onPressedOnTitle,
          child: Text(
            title??'',
            style: Theme.of(context).textTheme.headline6.copyWith(color: DmConst.accentColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    List<DropdownMenuItem> its = [
      DropdownMenuItem<Gender>(value: Gender.Others, child: Text('N/A', style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(value: Gender.Male, child: Text('Mr', style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(value: Gender.Female, child: Text('Mrs', style: this.txtStyleAccent)),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: DropdownButtonFormField(
        items: its,
        onChanged: (newValue) {
          setState(() {
            u.gender = newValue;
            _con.isPersonalChange = true;
          });
        },
        value: u.gender,
        onSaved: (value) => u.gender = value,
//        validator: (value) => value == null ? S.of(context).invalidGender : null,
        decoration: buildInputDecoration(context, S.of(context).gender),
      ),
    );
  }

  void onPressSavePersonDetail() async {
    print('onPressSavePersonDetail --');
    _con.personalDetailFormKey.currentState.save();
    if (_con.personalDetailFormKey.currentState.validate()) {
      bool re = await _con.updatePersonDetail();
      if(re) {
        _con.showMsg(S.of(context).accountInfoUpdated);
      }
    }
  }

  void onPressChangePass() async {
    print('onPressChangePass --');
    _con.changePassFormKey.currentState.save();
    if (_con.changePassFormKey.currentState.validate()) {
      bool re = await _con.changePwd();
      _con.changePassFormKey.currentState.reset();
//      setState(() {
//        u.password = '';
//        _con.newPass = '';
//      });
//      if(re) {
//        _con.showMsg(S.of(context).passwordChanged);
//      }
    }
  }

  void _onPressAddressesButton() {
    print('_onPressAddressesButton');
    RouteGenerator.gotoAddressesScreen(context);
  }
}
