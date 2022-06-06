import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/generated/l10n.dart';
import 'package:dmart/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextEditWid extends StatefulWidget {
  void Function(String?)? onSaved;
  void Function(String?)? onChanged;
  String? Function(String?)? validator;
  String? initValue;
  final bool enable = true;
  String? hintText;
  IconData? prefixIcon;

  TextEditWid({
    Key? key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.initValue,
    this.hintText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  _TextEditWidState createState() => _TextEditWidState();
}

class _TextEditWidState extends State<TextEditWid> {
  final TextStyle txtStyleAccent = TextStyle(color: DmConst.accentColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: buildBoxDecorationForTextField(context),
      child: TextFormField(
        style: txtStyleAccent,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        initialValue: widget.initValue,
        enabled: widget.enable,
        validator: widget.validator!,
        decoration: new InputDecoration(
            hintText: widget.hintText,
            hintStyle: txtStyleAccent,
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: DmConst.accentColor)),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: DmConst.accentColor)
                : null),
      ),
    );
  }
}

// ignore: must_be_immutable
class PhoneNoWid extends StatefulWidget {
  void Function(String?)? onSaved;
  void Function(String?)? onChanged;
  String? initValue;
  final bool? enable;

  PhoneNoWid(
      {Key? key,
      this.onSaved,
      this.onChanged,
      this.initValue,
      this.enable = true})
      : super(key: key);

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
        validator: (value) =>
            DmUtils.isNotPhoneNo(value!) ? S.current.invalidPhone : null,
        decoration: new InputDecoration(
          hintText: S.current.phone,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DmConst.accentColor)),
          prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
        ),
        inputFormatters: <TextInputFormatter>[
          // WhitelistingTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class EmailWid extends StatefulWidget {
  Function(String?)? onSaved;
  Function(String?)? onChanged;
  String? initValue;
  final bool enable;
  final bool isOptional;

  EmailWid(
      {Key? key,
      required this.onSaved,
      this.onChanged,
      this.initValue,
      this.enable = true,
      this.isOptional = true})
      : super(key: key);

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
        validator:
            emailValidate, //(value) => DmUtils.isNotEmail(value) ? S.current.invalidEmail : null,
        decoration: new InputDecoration(
          hintText: S.current.email,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DmConst.accentColor)),
          prefixIcon: Icon(Icons.email, color: DmConst.accentColor),
        ),
      ),
    );
  }

  String? emailValidate(String? value) {
    if (widget.isOptional) {
      if (value!.trim().length == 0) {
        return null;
      } else {
        return DmUtils.isNotEmail(value)! ? S.current.invalidEmail : null;
      }
    } else {
      return DmUtils.isNotEmail(value!) ? S.current.invalidEmail : null;
    }
  }
}

// ignore: must_be_immutable
class PasswordWid extends StatefulWidget {
  Function(String?)? onSaved;
  Function(String?)? onChanged;
  String? initValue;
  final bool enable;

  PasswordWid(
      {Key? key,
      required this.onSaved,
      this.onChanged,
      this.initValue,
      this.enable = true})
      : super(key: key);
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
        validator: (input) => input!.length < 4 ? S.current.passwordNote : null,
        obscureText: hidePassword,
        decoration: new InputDecoration(
          hintText: S.current.password,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DmConst.accentColor)),
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
  String? Function(String?)? onValidate;
  final bool enable;

  PasswordConfirmWid({Key? key, required this.onValidate, this.enable = true})
      : super(key: key);
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
          hintText: S.current.confirmPassword,
          hintStyle: txtStyleAccent,
          enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: DmConst.accentColor)),
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
