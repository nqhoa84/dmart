import 'dart:convert';
import 'dart:io';
import 'package:dmart/src/widgets/profile/profile_common.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:http/http.dart' as http;

import 'package:dmart/buidUI.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/route_generator.dart';
import 'package:dmart/src/widgets/DmBottomNavigationBar.dart';
import 'package:dmart/utils.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../../DmState.dart';
import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../repository/user_repository.dart' as userRepo;

class SignInScreen extends StatefulWidget {
  final fb = FacebookLogin();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends StateMVC<SignInScreen> {
  UserController _con;
  get txtStyleGrey => Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.grey);
//  get txtStyleAccent => Theme.of(context).textTheme.subtitle1.copyWith(color: DmConst.accentColor);
  final txtStyleAccent = TextStyle(color: DmConst.accentColor);

  _SignInScreenState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
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
      bottomNavigationBar: DmBottomNavigationBar(currentIndex: DmState.bottomBarSelectedIndex),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createSilverTopMenu(context, haveBackIcon: true, title: S.of(context).login),
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
            Offstage(
              offstage: _con.isLoginError == false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  children: [
                    Icon(Icons.error, color: DmConst.colorFavorite, size: kToolbarHeight),
                    Expanded(
                      child: Text(S.of(context).loginErrorIncorrectPhonePassFullMsg,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: DmConst.colorFavorite),),
                    ),
                  ],
                ),
              ),
            ),
            PhoneNoWid(
              onSaved: (value) {
                _con.user.phone = value;
              }),
//            Container(
//              padding: EdgeInsets.symmetric(horizontal: 5),
////                height: DmConst.appBarHeight * 0.7,
//              decoration: BoxDecoration(
//                  color: DmConst.bgrColorSearchBar,
//                  border: Border.all(
//                    color: Theme.of(context).focusColor.withOpacity(0.2),
//                  ),
//                  borderRadius: BorderRadius.circular(7)),
//              child: TextFormField(
//                style: txtStyleAccent,
//                textAlignVertical: TextAlignVertical.center,
//                keyboardType: TextInputType.text,
//                onSaved: (input) {
//                  if (DmUtils.isNullOrEmptyStr(input)) return;
//                  input = input.trim();
//                  if (DmUtils.isEmail(input)) {
//                    _con.user.email = input;
//                  } else {
//                    _con.user.phone = input;
//                  }
//                },
//                validator: _phoneOrEmailValidate,
//                decoration: new InputDecoration(
//                  hintText: S.of(context).phoneOrEmail,
//                  hintStyle: txtStyleAccent,
//                  enabledBorder:
//                  UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
//                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor)),
//                  prefixIcon: Icon(Icons.phone, color: DmConst.accentColor),
//                ),
//              ),
//            ),

            SizedBox(height: 10),

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
                style: txtStyleAccent,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                onSaved: (input) => _con.user.password = input,
                validator: (input) => input.length < 3 ? S.of(context).passwordNote : null,
                obscureText: _con.hidePassword,
                decoration: new InputDecoration(
                  hintText: S.of(context).password,
                  hintStyle: txtStyleAccent,
                  enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: DmConst.accentColor.withOpacity(0.2))),
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
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: onPressForgetPass,
                  child: Text(S.of(context).forgetPassword,
                      style: txtStyleAccent.copyWith(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            // Login button
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    onPressed: onPressLogin,
                    child: Text(S.of(context).login,
                        style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
                    color: DmConst.accentColor,
//                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            //Facebook button.
            //TODO enable this
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: [
//                Padding(
//                  padding: const EdgeInsets.only(right: 15),
//                  child: Text(S.of(context).orSignInWith),
//                ),
//                InkWell(
//                  onTap: onPressFbLogin,
//                  child: Image.asset('assets/img/C_Facebook.png', width: 40, fit: BoxFit.scaleDown),
//                ),
//              ],
//            ),
//            SizedBox(height: 8),
            Divider(thickness: 2, height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(S.of(context).dontHaveAccount),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: DmConst.bgrColorSearchBar,
                      border: Border.all(color: Theme.of(context).accentColor, width: 2),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      onPressed: onPressRegister,
                      child: Text(S.of(context).register,
                          style: Theme.of(context).textTheme.headline6.copyWith(color: DmConst.accentColor)),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Text(
                S.of(context).youCanUseThisAccountOnDmart24Web,
                style: txtStyleGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _phoneOrEmailValidate(String value) {
    if (DmUtils.isNullOrEmptyStr(value) || (!DmUtils.isEmail(value.trim()) && !DmUtils.isPhone(value.trim())))
      return S.of(context).invalidPhoneOrEmail;
    else {
      return null;
    }
  }

  void onPressLogin(){
    _con.login() ;
  }

  Future<void> onPressFbLogin() async {
    print('Press on FB login.');
    await loginFb3();

    // Log in
    final res = await widget.fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

// Check result status
    switch (res.status) {
      case FacebookLoginStatus.Success:
      // Logged in

      // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken;
        print('Access token: ${accessToken.token}');

        // Get profile data
        final profile = await widget.fb.getUserProfile();
        print('Hello, ${profile.name}! You ID: ${profile.userId}');

        // Get user profile image url
        final imageUrl = await widget.fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');

        // Get email (since we request email permission)
        final email = await widget.fb.getUserEmail();
        // But user can decline permission
        if (email != null)
          print('And your email is $email');

        break;
      case FacebookLoginStatus.Cancel:
      // User cancel log in
        break;
      case FacebookLoginStatus.Error:
      // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  Future loginFb3() async {
//    final fb = widget.fb;
//
//    // Log in
//    final result = await fb.logIn (['email',
//    ]);
//
//    // Check result status
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        final FacebookAccessToken accessToken = result.accessToken;
//        final token = accessToken.token;
//
//        print('''
//         Logged in!
//
//         Token: ${accessToken.token}
//         User id: ${accessToken.userId}
//         Expires: ${accessToken.expires}
//         Permissions: ${accessToken.permissions}
//         Declined permissions: ${accessToken.declinedPermissions}
//         ''');
//
//        final graphResponse = await http.get(
//            'https://graph.facebook.com/v2.12/me?fields=picture,name,first_name,last_name,email&breaking_change=profile_picture&access_token=${token}');
//        final profile = json.decode(graphResponse.body);
//        print(profile);
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        print('Login cancelled by the user.');
//        break;
//      case FacebookLoginStatus.error:
//        print('Something went wrong with the login process.\n'
//            'Here\'s the error Facebook gave us: ${result.errorMessage}');
//        break;
//    }
  }

  void onPressForgetPass() {
    RouteGenerator.gotoForgetPass(context);
  }

  void onPressRegister() {
    Navigator.of(context).pushNamed('/SignUp');
  }

}
