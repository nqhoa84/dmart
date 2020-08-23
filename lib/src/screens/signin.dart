import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../../src/widgets/SocialMediaWidget.dart';
import '../controllers/user_controller.dart';
import '../repository/user_repository.dart' as userRepo;


class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends StateMVC<SignInWidget> {
  UserController _con;

  _SignInWidgetState() : super(UserController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    if (userRepo.currentUser.value.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: createAppBar(context, _con.scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            Divider(thickness: 3, color: DmConst.primaryColor),
          createTitleRowWithBack(context, title: S.of(context).login),
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 2, color: Colors.grey.shade300),
//                      color: Theme.of(context).primaryColor,
//                      boxShadow: [
//                        BoxShadow(
//                            color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 10), blurRadius: 20)
//                      ],
                  ),
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: DmConst.primaryColor),
                          keyboardType: TextInputType.phone,
                          onSaved: (input) => _con.user.phone = input,
//                          validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                          decoration: new InputDecoration(
                            hintText: S.of(context).phone,
                            hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.primaryColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: DmConst.primaryColor.withOpacity(0.2))),
                            focusedBorder:
                                UnderlineInputBorder(borderSide: BorderSide(color: DmConst.primaryColor)),
                            prefixIcon: Icon(Icons.phone, color: DmConst.primaryColor),
                          ),
                        ),
                        SizedBox(height: 10),
                        new TextFormField(
                          style: TextStyle(color: DmConst.primaryColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length < 3 ? S.of(context).shouldBeMoreThan6Chars : null,
                          obscureText: _con.hidePassword,
                          decoration: new InputDecoration(
                            hintText: S.of(context).password,
                            hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.primaryColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: DmConst.primaryColor.withOpacity(0.2))),
                            focusedBorder:
                                UnderlineInputBorder(borderSide: BorderSide(color: DmConst.primaryColor)),
                            prefixIcon: Icon(UiIcons.padlock_1,  color: DmConst.primaryColor
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _con.hidePassword = !_con.hidePassword;
                                });
                              },
                              color: DmConst.primaryColor.withOpacity(0.4),
                              icon: Icon(_con.hidePassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),
//                        SizedBox(height: 10),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                          },
                          child: Text(
                            S.of(context).forgetPassword,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
//                        SizedBox(height: 10),
                        FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                          onPressed: () {
                            _con.login();
                          },
                          child: Text(
                            S.of(context).login,
                            style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)
                          ),
                          color: DmConst.primaryColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(height: 15),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                          },
                          shape: StadiumBorder(),
                          textColor: Theme.of(context).hintColor,
                          child: Text(S.of(context).orSignInWith),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/SignUp');
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline6.merge(
                        TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight: FontWeight.w600),
                      ),
                  children: [
                    TextSpan(text: S.of(context).dontHaveAccount),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
