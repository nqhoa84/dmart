import '../../src/helpers/ui_icons.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/user_controller.dart';
import '../../generated/l10n.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
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
                    ],
                  ),
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Text(S.of(context).register, style: Theme.of(context).textTheme.headline2),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => _con.user.name = input,
                          validator: (input) => input.length < 6 ? S.of(context).shouldBeMoreThan6Chars : null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12),
                            hintText: S.of(context).fullName,
                            hintStyle: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(color: Theme.of(context).accentColor),
                            ),
                            prefixIcon: Icon(UiIcons.user_1, color: Theme.of(context).accentColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).accentColor.withOpacity(0.2))),
                            focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor)),
                          ),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style: TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _con.user.email = input,
                          validator: (input) => !input.contains('@') ? S.of(context).shouldBeValidEmail : null,
                          decoration: new InputDecoration(
                            hintText: S.of(context).emailAddress,
                            hintStyle: Theme.of(context).textTheme.bodyText2.merge(
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
                          obscureText: _con.hidePassword,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length < 6 ? S.of(context).shouldBeMoreThan6Chars : null,
                          decoration: new InputDecoration(
                            hintText: S.of(context).password,
                            hintStyle: Theme.of(context).textTheme.bodyText2.merge(
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
                        SizedBox(height: 50),
                        /*new TextFormField(
                          style: TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          obscureText: !_con.hidePassword,
                          onSaved: (input) => _con.user.password = input,
                          validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                          decoration: new InputDecoration(
                            hintText: '••••••••••••',
                            hintStyle: Theme.of(context).textTheme.bodyText2.merge(
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
                        SizedBox(height: 30),*/
                        FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
                          onPressed: () {
                            _con.register();
                          },
                          child: Text(
                            S.of(context).register,
                            style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(color: Theme.of(context).primaryColor),
                                ),
                          ),
                          color: Theme.of(context).accentColor,
                          shape: StadiumBorder(),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Login');
              },
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline6.merge(
                        TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight: FontWeight.w600),
                      ),
                  children: [
                    TextSpan(text: 'i_have_account_back_to_login'),
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
