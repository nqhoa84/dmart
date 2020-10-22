import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../buidUI.dart';
import '../../constant.dart';
import '../../generated/l10n.dart';
import '../../src/helpers/ui_icons.dart';
import '../../utils.dart';
import '../controllers/user_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends StateMVC<ForgetPasswordScreen> {
  UserController _con;

  _ForgetPasswordScreenState() : super(UserController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
//        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(DmConst.assetImgLogo, width: 46, height: 46, fit: BoxFit.scaleDown),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Divider(height: 4, thickness: 2, color: DmConst.accentColor),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).resetYourPass),
            SliverList(
              delegate: SliverChildListDelegate([
                buildContent(context),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: createRoundedBorderBoxDecoration(),
      child: Form(
        key: _con.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).weWillSendNewPass),
            SizedBox(height: 15),

            Text(S.of(context).resetPassEnterPhoneNumber),
            SizedBox(height: 15),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
//                height: DmConst.appBarHeight * 0.7,
              decoration: BoxDecoration(
                  color: DmConst.bgrColorSearchBar,
                  border: Border.all(
                    color: Theme.of(context).focusColor.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(7)),
              child: TextFormField(
                style: TextStyle(color: DmConst.accentColor),
                keyboardType: TextInputType.phone,
                onSaved: (input) {
                  if (DmUtils.isNullOrEmptyStr(input)) return;
                  input = input.trim();
                  if (DmUtils.isEmail(input)) {
                    _con.user.email = input;
                  } else {
                    _con.user.phone = input;
                  }
                },
//                validator: _phoneOrEmailValidate,
                decoration: new InputDecoration(
                  hintText: S.of(context).phone,
                  hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: DmConst.accentColor),
                  enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
                  prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
                ),
              ),
            ),

            SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    onPressed: onPressResetPass,
                    child: Text(S.of(context).resetPassword,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                    color: DmConst.colorFavorite,
//                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
             
          ],
        ),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                          Text(S.of(context).emailToResetPass, style: Theme.of(context).textTheme.headline2.merge(TextStyle(fontSize:20,))),
                          SizedBox(height: 60),
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
                          SizedBox(height: 70),
                          FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                            onPressed: () {
                              _con.resetPassword();
                            },
                            child: Text(
                              S.of(context).sendLink,
                              style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                            color: Theme.of(context).accentColor,
                            shape: StadiumBorder(),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/Login');
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(fontSize:16,color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
                        ),
                        children: [
                          TextSpan(text: 'i_remember_my_password_return_to_login'),
                        ],
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/SignUp');
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline6.merge(
                          TextStyle(fontSize:16,color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
                        ),
                        children: [
                          TextSpan(text: S.of(context).dontHaveAccount),
                        ],
                      ),
                    ),
                  ),

                ],

              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressResetPass() {
    print('------onPressResetPass');
  }
}
