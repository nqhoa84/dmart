

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
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 65, horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2), offset: Offset(0, 10), blurRadius: 20)
                      ]),
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Text(
                            S.of(context).login,
                            style: Theme.of(context).textTheme.display3),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _con.user.email = input,
                          validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                          decoration: new InputDecoration(
                            hintText: S.of(context).email_address,
                            hintStyle: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(color: Theme.of(context).accentColor),
                                ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).accentColor.withOpacity(0.2))),
                            focusedBorder:
                                UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              UiIcons.envelope,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                          obscureText: _con.hidePassword,
                          decoration: new InputDecoration(
                            hintText: S.of(context).password,
                            hintStyle: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(color: Theme.of(context).accentColor),
                                ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).accentColor.withOpacity(0.2))),
                            focusedBorder:
                                UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              UiIcons.padlock,
                              color: Theme.of(context).accentColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _con.hidePassword = !_con.hidePassword;
                                });
                              },
                              color: Theme.of(context).accentColor.withOpacity(0.4),
                              icon: Icon(_con.hidePassword ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                          },
                          child: Text(
                            S.of(context).i_forgot_password,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                        SizedBox(height: 20),
                        FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                          onPressed: () {
                            _con.login();
                          },
                          child: Text(
                            S.of(context).login,
                            style: Theme.of(context).textTheme.title.merge(
                                  TextStyle(color: Theme.of(context).primaryColor),
                                ),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(height: 15),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                          },
                          shape: StadiumBorder(),
                          textColor: Theme.of(context).hintColor,
                          child: Text(S.of(context).skip),
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
                  style: Theme.of(context).textTheme.title.merge(
                        TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight: FontWeight.w600),
                      ),
                  children: [
                    TextSpan(text: S.of(context).i_dont_have_an_account),
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
