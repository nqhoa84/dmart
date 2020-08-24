import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';

import '../../DmState.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../repository/user_repository.dart' as userRepo;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends StateMVC<SignInScreen> {
  UserController _con;

  _SignInScreenState() : super(UserController()) {
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
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
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
                  decoration: createRoundedBorderBoxDecoration(),
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: TextStyle(color: DmConst.accentColor),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _con.user.email = input,
                          validator: (input) => !input.contains('@') ? S.of(context).invalidAddress : null,
                          decoration: new InputDecoration(
                            hintText: S.of(context).emailAddress,
                            hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                            prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
                          ),
                        ),
                        SizedBox(height: 10),
                        new TextFormField(
                          style: TextStyle(color: DmConst.accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length < 3 ? S.of(context).shouldBeMoreThan6Chars : null,
                          obscureText: _con.hidePassword,
                          decoration: new InputDecoration(
                            hintText: S.of(context).password,
                            hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
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
//                        SizedBox(height: 10),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                          },
                          child: Text(
                            S.of(context).forgetPassword,
                            style: Theme.of(context).textTheme.bodyText2
                          ),
                        ),
//                        SizedBox(height: 10),
                      // Login button
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                onPressed: () {
                                  _con.login();
                                },
                                child: Text(S.of(context).login,
                                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                                color: DmConst.accentColor,
                                shape: StadiumBorder(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        //Facebook button.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(S.of(context).orSignInWith),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Image.asset('assets/img/C_Facebook.png', width: 40, fit: BoxFit.scaleDown),
                            ),
                          ],
                        ),
                        Divider(thickness: 2),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            children: [
                              TextSpan(text: S.of(context).dontHaveAccount),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/SignUp');
                                },
                                child: Text(S.of(context).register,
                                    style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                                color: DmConst.accentColor,
                                shape: StadiumBorder(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
