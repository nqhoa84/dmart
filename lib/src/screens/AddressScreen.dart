import 'package:dmart/DmState.dart';
import 'package:dmart/src/controllers/delivery_addresses_controller.dart';
import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/user.dart';
import 'package:dmart/src/repository/settings_repository.dart';
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

// ignore: must_be_immutable
class AddressWid extends StatefulWidget {
  Address _address;
  final List<Province> provinces;

  ///This widget will handle address.
  AddressWid({Key key, Address address, this.provinces}) : super(key: key) {
    this._address = address != null ? address.clone() : Address();
  }

  @override
  _AddressWidState createState() => _AddressWidState(this._address);
}

class _AddressWidState extends StateMVC<AddressWid> {
  DeliveryAddressesController _con;

  var txtStyleAccent = TextStyle(color: DmConst.accentColor);

  _AddressWidState(Address a) : super(DeliveryAddressesController()) {
    _con = controller;
    _con.address = a;
  }

  @override
  void initState() {
    _con.getProvinces();
    if(_con.address.district != null) {
      _con.getDistricts(_con.address.province.id);
    }

    if(_con.address.ward != null) {
      _con.getWards(_con.address.district.id);
    }

    super.initState();
  }

  @override
  Future<bool> initAsync() {
    return super.initAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DmBottomNavigationBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSliverTopBar(context),
            createSliverSearch(context),
            createSilverTopMenu(context,
                haveBackIcon: true,
                title: _con.address.id <= 0 ? S.of(context).addDeliveryAddress : S.of(context).deliveryAddress),
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
    Address a = _con.address;
    return Form(
      key: _con.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextEditWid(
            initValue: a.fullName,
            hintText: S.of(context).fullName,
            validator: (v) => DmUtils.isNotNullEmptyStr(v) ? null : S.of(context).invalidFullName,
            onSaved: (v) => a.fullName = v,
            prefixIcon: Icons.person_outline,
          ),
          SizedBox(height: DmConst.masterHorizontalPad),
          PhoneNoWid(
            initValue: a.phone,
            onSaved: (v) => a.phone = v,
          ),
          SizedBox(height: 5),
          Column(
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
                          style: TextStyle(color: DmConst.accentColor),
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.address.address = input.trim(),
                          initialValue: _con.address.address,
                          validator: (input) =>
                          DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                          decoration: buildInputDecoration(context, S.of(context).houseNo),
                        ),
                      ),
                    ),
                    VerticalDivider(width: 10, thickness: 2, indent: 5, endIndent: 5, color: Colors.white),
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          style: TextStyle(color: DmConst.accentColor),
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.address.street = input.trim(),
                          initialValue: _con.address.street,
                          validator: (input) =>
                          DmUtils.isNullOrEmptyStr(input) ? S.of(context).invalidAddress : null,
                          decoration: buildInputDecoration(context, S.of(context).streetName),
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
                          decoration: buildInputDecoration(context, S.of(context).note),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
//          Row(
//            children: [
//              Text(S.of(context).defaultDeliveryAddress),
//              CheckboxListTile(value: a.isDefault, onChanged: (v) => a.isDefault = v),
//            ],
//          ),
          CheckboxListTile(
            title: Text(S.of(context).defaultDeliveryAddress, style: TextStyle(color: DmConst.accentColor)),
              value: a.isDefault,
              onChanged: (v) {
                setState(() { a.isDefault = v;});
              },
            activeColor: DmConst.accentColor,
            checkColor: DmConst.accentColor,
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: OutlineButton(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  onPressed: onPressCancel,
                  child: Text(S.of(context).cancel,
                      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.red)),
//                    shape: StadiumBorder(),
                ),
              ),
              Expanded(
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  onPressed: onPressSave,
                  child: Text(S.of(context).save,
                      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                  color: DmConst.accentColor,
//                    shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ],
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
        decoration: buildInputDecoration(context, S.of(context).province),
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
      decoration: buildInputDecoration(context, S.of(context).district),
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
      decoration: buildInputDecoration(context, S.of(context).commune),
    );
  }

  Future<void> onPressSave() async {
    print('_AddressWidState.onPressSave');
    bool re = await _con.saveAddress();
    if(re == true && Navigator.canPop(context)) {
      print('-----pop, re.length = ${_con.addresses.length}');
      Navigator.pop<List<Address>>(context, _con.addresses);
    }
  }

  void onPressCancel() {
    if(Navigator.canPop(context))
      Navigator.of(context).pop();
  }
}
