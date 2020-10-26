import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PhoneNoWid extends StatefulWidget {
  Function(String) onSaved;
  Function(String) onChanged;
  String initValue;
  final bool enable;

  PhoneNoWid({Key key, this.onSaved, this.onChanged,
    this.initValue, this.enable = true}) : super(key: key);

  @override
  _PhoneNoWidState createState() => _PhoneNoWidState();
}

class _PhoneNoWidState extends State<PhoneNoWid> {
  final TextStyle txtStyleAccent = TextStyle(color: DmConst.accentColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: TextFormField(
        style: txtStyleAccent,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        initialValue: widget.initValue,
        enabled: widget.enable,
        validator: (value) => DmUtils.isNotPhoneNo(value) ? S.of(context).invalidPhone : null,
        decoration: new InputDecoration(
          hintText: S.of(context).phone,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
          prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
        ),
        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
      ),
    );
  }
}

// ignore: must_be_immutable
class EmailWid extends StatefulWidget {
  Function(String) onSaved;
  Function(String) onChanged;
  String initValue;
  final bool enable;

  EmailWid({Key key, @required this.onSaved, this.onChanged, this.initValue,
  this.enable = true}) : super(key: key);

  @override
  _EmailWidState createState() => _EmailWidState();
}

class _EmailWidState extends State<EmailWid> {
  final TextStyle txtStyleAccent = TextStyle(color: DmConst.accentColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: TextFormField(
        style: txtStyleAccent,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.emailAddress,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        initialValue: widget.initValue,
        enabled: widget.enable,
        validator: (value) => DmUtils.isNotEmail(value) ? S.of(context).invalidEmail : null,
        decoration: new InputDecoration(
          hintText: S.of(context).email,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
          prefixIcon: Icon(Icons.email, color: DmConst.accentColor),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PasswordWid extends StatefulWidget {
  Function(String) onSaved;
  Function(String) onChanged;
  String initValue;
  final bool enable;

  PasswordWid({Key key, @required this.onSaved, this.onChanged, this.initValue,
    this.enable = true}) : super(key: key);
  @override
  _PasswordWidState createState() => _PasswordWidState();
}

class _PasswordWidState extends State<PasswordWid> {
  final TextStyle txtStyleAccent = TextStyle(color: DmConst.accentColor);
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
//                height: DmConst.appBarHeight * 0.7,
      decoration: BoxDecoration(
          color: DmConst.bgrColorSearchBar,
          border: Border.all(
            color: Theme.of(context).focusColor.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(7)),
      child: TextFormField(
        style: txtStyleAccent,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        enabled: widget.enable,
        initialValue: widget.initValue,
        validator: (input) => input.length < 4 ? S.of(context).passwordNote : null,
        obscureText: hidePassword,
        decoration: new InputDecoration(
          hintText: S.of(context).password,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
          prefixIcon: Icon(Icons.lock_outline, color: DmConst.accentColor),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            color: DmConst.accentColor.withOpacity(0.4),
            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class PasswordConfirmWid extends StatefulWidget {
  Function(String) onValidate;
  final bool enable;

  PasswordConfirmWid({Key key, @required this.onValidate,
    this.enable = true}) : super(key: key);
  @override
  _PasswordConfirmWidState createState() => _PasswordConfirmWidState();
}

class _PasswordConfirmWidState extends State<PasswordConfirmWid> {
  final TextStyle txtStyleAccent = TextStyle(color: DmConst.accentColor);
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
//                height: DmConst.appBarHeight * 0.7,
      decoration: BoxDecoration(
          color: DmConst.bgrColorSearchBar,
          border: Border.all(
            color: Theme.of(context).focusColor.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(7)),
      child: TextFormField(
        style: txtStyleAccent,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        enabled: widget.enable,
        validator: widget.onValidate,
        obscureText: hidePassword,
        decoration: new InputDecoration(
          hintText: S.of(context).confirmPassword,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
          prefixIcon: Icon(Icons.lock_outline, color: DmConst.accentColor),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                hidePassword = !hidePassword;
              });
            },
            color: DmConst.accentColor.withOpacity(0.4),
            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
    );
  }
}


