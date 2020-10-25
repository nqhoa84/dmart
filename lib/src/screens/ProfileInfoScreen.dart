import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../widgets/PaymentSettingsDialog.dart';
import '../widgets/ProfileSettingsDialog.dart';
import '../widgets/SearchBar.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import '../helpers/ui_icons.dart';


class ProfileInfoScreen extends StatefulWidget {
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends StateMVC<ProfileInfoScreen> {
  ProfileInfoController _con;

  _ProfileInfoScreenState() : super(ProfileInfoController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).settings,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
          leading: new IconButton(
            icon: new Icon(UiIcons.return_icon,
                color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body:  true //currentUser.value.id == null
            ? CircularLoadingWidget(height: 500)
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBar(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  currentUser.value.name,
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Text(
                                  currentUser.value.email,
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          SizedBox(
                              width: 55,
                              height: 55,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(300),
                                onTap: () {
                                  Navigator.of(context).pushNamed('/Pages', arguments: 1);
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(currentUser.value.image.thumb),
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(UiIcons.user_1),
                            title: Text(
                              S.of(context).profileSettings,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              minWidth: 50.0,
                              height: 25.0,
                              child: ProfileSettingsDialog(user: currentUser.value, onChanged: () {_con.update(currentUser.value);},
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).fullName,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              currentUser.value.name,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).email,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              currentUser.value.email,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).phone,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              currentUser.value.phone,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).address,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              Helper.limitString(currentUser.value.address),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            dense: true,
                            title: Text(
                              S.of(context).about,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              Helper.limitString(currentUser.value.bio),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.credit_card),
                            title: Text('payments_settings',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: ButtonTheme(
                              padding: EdgeInsets.all(0),
                              minWidth: 50.0,
                              height: 25.0,
                              child: PaymentSettingsDialog(
                                creditCard: _con.creditCard,
                                onChanged: () {
                                  _con.updateCreditCard(_con.creditCard);
                                  //setState(() {});
                                },
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            title: Text('default_credit_card',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              _con.creditCard.number.isNotEmpty
                                  ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...')
                                  : '',
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).hintColor.withOpacity(0.15),
                              offset: Offset(0, 3),
                              blurRadius: 10)
                        ],
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: <Widget>[
                          ListTile(
                            leading: Icon(UiIcons.settings_1),
                            title: Text('app_settings',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Languages');
                            },
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                Icon(
                                  UiIcons.planet_earth,
                                  size: 22,
                                  color: Theme.of(context).focusColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).languages,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            trailing: Text(
                              S.of(context).langEnglish,
                              style: TextStyle(color: Theme.of(context).focusColor),
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed('/DeliveryAddresses');
                            },
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                Icon(
                                  UiIcons.map,
                                  size: 22,
                                  color: Theme.of(context).focusColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).deliveryAddresses,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pushNamed('/Help');
                            },
                            dense: true,
                            title: Row(
                              children: <Widget>[
                                Icon(
                                  UiIcons.information,
                                  size: 22,
                                  color: Theme.of(context).focusColor,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  S.of(context).helpAndSupports,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
