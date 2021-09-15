import 'package:dmart/src/models/address.dart';
import 'package:dmart/src/models/api_result.dart';
import 'package:dmart/src/repository/user_repository.dart';
import 'package:dmart/src/screens/signup_fb.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../../route_generator.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import 'controller.dart';

class UserController extends Controller {
  User user = new User();
  String resetPassPhone;
  bool hidePassword = true, hidePassword2 = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> resetPassFormKey;
  GlobalKey<FormState> newPassFormKey;
  OverlayEntry loader;

  Address address = new Address();

  UserController() {
    //todo: unrem and test.
    // loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    resetPassFormKey = GlobalKey<FormState>();
    newPassFormKey = GlobalKey<FormState>();

    this.scaffoldKey = new GlobalKey<ScaffoldState>();

  }

  bool isLoginError = false;
  void login(BuildContext context) async {
    isLoginError = false;
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      // Overlay.of(context).insert(loader);

      repository.login(user).then((value) {
        if (value != null && value.id > 0) {
          RouteGenerator.gotoPromotions(context);
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.wrongEmailOrPassword),
          ));
          setState(() {
            isLoginError = true;
          });
        }
      }).catchError((e) {
        print(e);
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.emailAccountExists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  List<Address> deliveryAddresses = [];
  void listenForDeliveryAddresses({Function() onComplete}) async {
    final Stream<Address> stream = await getAddresses();
    deliveryAddresses.clear();
    stream.listen((Address addr) {
      setState(() {
        if(addr.isValid)
          deliveryAddresses.add(addr);
      });
//      print('new arrival, pro id =${_product.id}, name=${_product.name}');
    }, onError: (a) {
      print(a);
    }, onDone: onComplete,
    );
  }

  void loginFb(BuildContext context, {@required String fbId, String accessToken, String name, String avatarUrl}) async {
    print('Start login FB----fbId=$fbId, name=$name, avatarUrl=$avatarUrl, accessToken=$accessToken');
    if(this.loading) return;
    this.loading = true;
    ApiResult<User> re = await repository.loginFB(fbId: fbId, accessToken: accessToken, name: name, avatarUrl: avatarUrl);
    this.loading = false;

    print(re);

    if(re.isSuccess) {
      re.data.fbAvatar = avatarUrl;
      currentUser.value = re.data;
      saveUserToShare(re.data);

      RouteGenerator.gotoHome(context);
//      currentUser.notifyListeners();
    } else {
      //need to register by FbId
      if(re.isNoJson == true) {
        // Todo call api to collect error.
        // send error message
        showErrGeneral();
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignUpFbScreen(
            fbId: fbId, name: name, avatarUrl: avatarUrl, accessToken: accessToken)));
      }
    }
  }
}
