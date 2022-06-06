import 'package:dmart/DmState.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/screens/addressesScreen.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/src/widgets/DrawerWidget.dart';
import 'package:dmart/src/widgets/profile/profile_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_datetime_picker/src/datetime_util.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../utils.dart';
import '../controllers/settings_controller.dart';
import '../repository/user_repository.dart';

class ProfileInfoScreen extends StatefulWidget {
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends StateMVC<ProfileInfoScreen> {
  ProfileInfoController _con = ProfileInfoController();

  _ProfileInfoScreenState({this.u}) : super(ProfileInfoController()) {
    _con = controller as ProfileInfoController;
  }

  User? u;

  @override
  void initState() {
    u = currentUser.value;
    _con.user = u!;
    super.initState();

    _con.getAddrs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      bottomNavigationBar:
          DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      drawer: DrawerWidget(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(context,
                haveBackIcon: true, title: S.current.myAccount),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    padding: const EdgeInsets.all(DmConst.masterHorizontalPad),
                    child: buildContent(context)),
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
          trailing: CircleAvatar(backgroundImage: NetworkImage(u!.avatarUrl!)),
          title: Text(
            '${S.current.welcome} ${u!.fullNameWithTitle}',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildPersonalDetailStack(context),
        SizedBox(height: DmConst.masterHorizontalPad),
        buildAddressDetailStack(context),
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
          padding: EdgeInsets.fromLTRB(
              DmConst.masterHorizontalPad,
              DmConst.masterHorizontalPad * 2,
              DmConst.masterHorizontalPad,
              DmConst.masterHorizontalPad),
//          width: double.infinity,
          child: Form(
            key: _con.personalDetailFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.current.fullName, style: txtStyleBold),
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
                            u!.name = input!.trim();
                          },
                          onChanged: (value) {
                            setState(() {
                              _con.isPersonalChange = true;
                            });
                          },
                          initialValue: u!.name,
                          validator: (value) => DmUtils.isNullOrEmptyStr(value!)
                              ? S.current.invalidFullName
                              : null,
                          decoration:
                              buildInputDecoration(context, S.current.fullName),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.current.dateOfBirth, style: txtStyleBold),
                InkWell(
                  onTap: onTapOnBirthDay,
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
                                context,
                                u!.birthday != null
                                    ? u!.birthday!.day.toString()
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
                            decoration: buildInputDecoration(
                                context,
                                u!.birthday != null
                                    ? u!.birthday!.month.toString()
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
                            decoration: buildInputDecoration(
                                context,
                                u!.birthday != null
                                    ? u!.birthday!.year.toString()
                                    : S.current.year),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(S.current.dateOfBirthNote, style: txtStyleGrey),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.current.mobilePhoneNumber, style: txtStyleBold),
                PhoneNoWid(
                    initValue: u!.phone,
                    onSaved: (value) => u!.phone = value!,
                    enable: false),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.current.email, style: txtStyleBold),
                EmailWid(
                    initValue: u!.email,
                    onSaved: (value) {
                      u!.email = value;
                      print('current email value');
                    },
                    onChanged: (value) {
                      setState(() {
                        _con.isPersonalChange = true;
                      });
                    }),
                SizedBox(height: DmConst.masterHorizontalPad),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        onPressed:
                            _con.loading || _con.isPersonalChange == false
                                ? null
                                : onPressSavePersonDetail,
                        child: Text(
                            _con.loading == false
                                ? S.current.save
                                : S.current.processing,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
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
        buildTitle(context, title: S.current.personalDetails)
      ],
    );
  }

  Stack buildAddressDetailStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: createRoundedBorderBoxDecoration(),
          padding: EdgeInsets.fromLTRB(
              DmConst.masterHorizontalPad,
              DmConst.masterHorizontalPad * 2,
              DmConst.masterHorizontalPad,
              DmConst.masterHorizontalPad),
//          width: double.infinity,
          child: AddressInfoWid(address: _con.defaultAddress!),
        ),
        buildTitle(context,
            title: '${S.current.deliveryAddresses} >>',
            onPressedOnTitle: _onPressAddressesButton)
      ],
    );
  }

  String? userEnterPass;
  Stack buildChangePassStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: createRoundedBorderBoxDecoration(),
          padding: EdgeInsets.fromLTRB(
              DmConst.masterHorizontalPad,
              DmConst.masterHorizontalPad * 2,
              DmConst.masterHorizontalPad,
              DmConst.masterHorizontalPad),
//          width: double.infinity,
          child: Form(
            key: _con.changePassFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.current.currentPassword, style: txtStyleBold),
                PasswordWid(
                    initValue: "",
                    onSaved: (value) => _con.currentPass = value!),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.current.mobilePhoneNumber, style: txtStyleBold),
                PhoneNoWid(initValue: u!.phone, enable: false),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.current.newPassword, style: txtStyleBold),
                PasswordWid(onSaved: (value) => _con.newPass = value!),
                SizedBox(height: DmConst.masterHorizontalPad),
                Text(S.current.confirmNewPass, style: txtStyleBold),
                PasswordConfirmWid(
                    onValidate: (value) => _con.newPass == value
                        ? null
                        : S.current.passwordNotMatch),
                SizedBox(height: DmConst.masterHorizontalPad),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        onPressed: _con.loading ? null : onPressChangePass,
                        child: Text(
                            _con.loading == false
                                ? S.current.save
                                : S.current.processing,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.white)),
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
        buildTitle(context, title: S.current.changePassword)
      ],
    );
  }

  Align buildTitle(BuildContext context,
      {String? title, Function()? onPressedOnTitle}) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: InkWell(
          onTap: onPressedOnTitle,
          child: Text(
            title ?? '',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: DmConst.accentColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget buildGenderDropdown() {
    List<DropdownMenuItem> its = [
      DropdownMenuItem<Gender>(
          value: Gender.Others, child: Text('N/A', style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(
          value: Gender.Male, child: Text('Mr', style: this.txtStyleAccent)),
      DropdownMenuItem<Gender>(
          value: Gender.Female, child: Text('Mrs', style: this.txtStyleAccent)),
    ];
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: buildBoxDecorationForTextField(context),
        child: Container()
        //! comment by hoang
        // DropdownButtonFormField(
        //   items: its,
        //   onChanged: (newValue) {
        //     setState(() {
        //       u!.gender = newValue as dynamic;
        //       _con.isPersonalChange = true;
        //     });
        //   },
        //   value: u!.gender,
        //   onSaved: (value) => u!.gender = value as dynamic,
        //   // validator: (value) => value == null ? S.current.invalidGender : null,
        //   decoration: buildInputDecoration(context, S.current.gender),
        // ),
        );
  }

  void onPressSavePersonDetail() async {
    print('onPressSavePersonDetail --');
    _con.personalDetailFormKey!.currentState!.save();
    if (_con.personalDetailFormKey!.currentState!.validate()) {
      bool re = await _con.updatePersonDetail();
      if (re) {
        _con.showMsg(S.current.accountInfoUpdated);
      }
    }
  }

  void onPressChangePass() async {
    print('onPressChangePass --');
    _con.changePassFormKey!.currentState!.save();
    if (_con.changePassFormKey!.currentState!.validate()) {
      bool re = await _con.changePwd();
      _con.changePassFormKey!.currentState!.reset();
//      setState(() {
//        u.password = '';
//        _con.newPass = '';
//      });
//      if(re) {
//        _con.showMsg(S.current.passwordChanged);
//      }
    }
  }

  void _onPressAddressesButton() {
    print('_onPressAddressesButton');
    RouteGenerator.gotoAddressesScreen(context);
  }

  void onTapOnBirthDay() {
    print('tap to select birthday');
    DatePicker.showPicker(
      context,
      pickerModel: BirthdayPicker(
          currentTime: u!.birthday!,
          locale: DmState.isKhmer ? LocaleType.kh : LocaleType.en),
      showTitleActions: false,
      // minTime: DateTime(1930, 1, 1),
      // maxTime: DateTime.now().subtract(Duration(days: 3650)),
      theme: DatePickerTheme(
          backgroundColor: DmConst.accentColor,
          itemStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
      onConfirm: (date) {
        u!.birthday = date;
      },
      onChanged: (date) {
        setState(() {
          u!.birthday = date;
        });
      },
    );
//     DatePicker.showDatePicker(context,
//         locale: LocaleType.kh,
//         showTitleActions: false,
//         minTime: DateTime(1930, 1, 1),
//         maxTime: DateTime.now().subtract(Duration(days: 3650)),
//         theme: DatePickerTheme(
// //                          headerColor: Colors.orange,
//             backgroundColor: DmConst.accentColor,
//             itemStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
//             doneStyle: TextStyle(color: Colors.white, fontSize: 16)), onConfirm: (date) {
//           u.birthday = date;
//         }, onChanged: (date) {
//           setState(() {
//             u.birthday = date;
//           });
//         }, currentTime: u.birthday);
  }
}

//a date picker model
class BirthdayPicker extends CommonPickerModel {
  DateTime? maxTime;
  DateTime? minTime;
  int? _currentLeftIndex;
  int? _currentMiddleIndex;
  int? _currentRightIndex;

  BirthdayPicker(
      {DateTime? currentTime,
      DateTime? maxTime,
      DateTime? minTime,
      LocaleType? locale})
      : super(locale: locale) {
    this.maxTime = maxTime ?? DateTime(2010, 12, 31);
    this.minTime = minTime ?? DateTime(1930, 1, 1);

    currentTime = currentTime ?? DateTime.now();

    if (currentTime.compareTo(this.maxTime!) > 0) {
      currentTime = this.maxTime;
    } else if (currentTime.compareTo(this.minTime!) < 0) {
      currentTime = this.minTime;
    }

    this.currentTime = currentTime!;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = this.currentTime.day - minDay;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.year - this.minTime!.year;

    super.setLeftIndex(_currentLeftIndex!);
    super.setMiddleIndex(_currentMiddleIndex!);
    super.setRightIndex(_currentRightIndex!);

    // this.setLeftIndex(this.currentTime.day - minDay);
    // this.setMiddleIndex(this.currentTime.month - minMonth);
    // this.setRightIndex(this.currentTime.year - this.minTime.year);
  }

  void _fillRightLists() {
    this.rightList =
        List.generate(maxTime!.year - minTime!.year + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime!.year + index}${_localeYear()}';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime!.year ? maxTime!.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime!.year ? minTime!.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime!.year &&
            currentTime.month == maxTime!.month
        ? maxTime!.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime!.year &&
            currentTime.month == minTime!.month
        ? minTime!.day
        : 1;
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    this.middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${_localeMonth(minMonth + index)}';
    });
  }

  void _fillLeftLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    this.leftList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}${_localeDay()}';
    });
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    _currentRightIndex = index;
    //adjust middle
    int destYear = index + minTime!.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              currentTime.day,
            )
          : DateTime(
              destYear,
              currentTime.month,
              currentTime.day,
            );
    }
    //min/max check
    if (newTime.isAfter(maxTime!)) {
      currentTime = maxTime!;
    } else if (newTime.isBefore(minTime!)) {
      currentTime = minTime!;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime.month - minMonth;
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    _currentMiddleIndex = index;
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime!)) {
      currentTime = maxTime!;
    } else if (newTime.isBefore(minTime!)) {
      currentTime = minTime!;
    } else {
      currentTime = newTime;
    }

    _fillLeftLists();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = currentTime.day - minDay;
    super.setLeftIndex(_currentLeftIndex!);
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    _currentLeftIndex = index;
    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            minDay + index,
          );
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  String _localeYear() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '年';
    } else if (locale == LocaleType.ko) {
      return '년';
    } else {
      return '';
    }
  }

  String _localeMonth(int month) {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '$month月';
    } else if (locale == LocaleType.ko) {
      return '$month월';
    } else {
      List monthStrings = i18nObjInLocale(locale)['monthLong'] as List<String>;
      return monthStrings[month - 1];
    }
  }

  String _localeDay() {
    if (locale == LocaleType.zh || locale == LocaleType.jp) {
      return '日';
    } else if (locale == LocaleType.ko) {
      return '일';
    } else {
      return '';
    }
  }

  @override
  DateTime finalTime() {
    return currentTime;
  }
}
