import '../../src/controllers/brand_controller.dart';
import '../../src/widgets/CircularLoadingWidget.dart';
import '../../generated/l10n.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/widgets/BrandGridWidget.dart';
import '../../src/widgets/DrawerWidget.dart';
import '../../src/widgets/SearchBar.dart';
import '../../src/widgets/ShoppingCartButtonWidget.dart';
import 'package:flutter/material.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class BrandsWidget extends StatefulWidget {

  const BrandsWidget({Key key,}) : super(key: key);
  @override
  _BrandsWidgetState createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends StateMVC<BrandsWidget> {
  BrandController _con;

  _BrandsWidgetState() : super(BrandController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
          Container(
            width: 30,
            height: 30,
            //margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 20),
            margin: EdgeInsetsDirectional.only(top: 12.5, bottom: 12.5, end: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: () {
                currentUser.value.apiToken != null
                    ? Navigator.of(context).pushNamed('/Pages', arguments: 1)
                    : Navigator.of(context).pushNamed('/Login');
              },
              child: currentUser.value.apiToken != null
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(currentUser.value.image.thumb),
                    )
                  : Icon(
                      Icons.person,
                      size: 26,
                      color: Theme.of(context).accentColor.withOpacity(1),
                    ),
            ),
          )
        ],
      ),
      body:
      _con.brands.isEmpty ? CircularLoadingWidget(height: 500,):
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SearchBar(
                onClickFilter: (event) {
                  _con.scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ),
            BrandGridWidget(brands: _con.brands),
          ],
        ),
      ),
    );
  }
}
