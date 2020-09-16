
import 'package:dmart/constant.dart';
import 'package:dmart/src/controllers/search_controller.dart';
import 'package:dmart/src/screens/serach_result.dart';
import 'package:dmart/utils.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import '../widgets/SearchModal.dart';
import '../../generated/l10n.dart';

class SearchBar extends StatefulWidget {

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends StateMVC<SearchBar> {
  SearchController _con;
  String textToSearch = '';
//  final ValueChanged onClickFilter;

//  _SearchBarState({Key key, this.onClickFilter}) : super();
  _SearchBarState() : super(new SearchController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
//    return InkWell(
//      onTap: () {
//        Navigator.of(context).push(SearchModal());
//      },
//      child: SearchWid(),
//    );
    return SearchWid(onTapOnSearchIcon: _onTapOnSearchIcon, onSubmitted: _onSubmitted,onTextChanged: _onTextChanged,
        isEditable: true, isAutoFocus: false);
  }

  _onSubmitted(String v) {
  }

  _onTextChanged(String v) {
    textToSearch = v??'';
  }

  _onTapOnSearchIcon() {
    _con.search(textToSearch, onDone: (){
      print("_con.products ${_con.products?.length}");
      if(isNullOrEmptyList(_con.products)) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).searchResultEmpty),
        ));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return SearchResultScreen(_con.products, this.textToSearch);
        }));
      }
    });
  }
}

class SearchWid extends StatelessWidget {
  final Function() onTapOnSearchIcon;
  final Function(String) onSubmitted;
  final Function(String) onTextChanged;

  final bool isEditable;

  final bool isAutoFocus;

  String hintText;

  SearchWid({
    Key key, this.isEditable = true, this.isAutoFocus = false, this.onTapOnSearchIcon, this.onSubmitted, this.onTextChanged,
    this.hintText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: EdgeInsets.all(0),
        height: DmConst.appBarHeight * 0.7,
        decoration: BoxDecoration(
            color: DmConst.bgrColorSearchBar,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: buildTextField(context),
              ),
            ),
            InkWell(
                onTap: onTapOnSearchIcon,
                child: Image.asset('assets/img/S_Search.png', height: DmConst.appBarHeight * 0.7 + 2, fit: BoxFit.scaleDown)),
          ],
        ),
      ),
    );
  }

  Widget buildTextField (BuildContext context) {
    if(this.isEditable) {
      return TextField(
        onSubmitted: this.onSubmitted,
        onChanged: this.onTextChanged,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          hintText: hintText??S.of(context).searchForProducts,
          hintStyle: Theme.of(context).textTheme.caption.copyWith(color: DmConst.textColorSearchBar, fontSize: 15),
        ),
      );
    } else {
      return Text(
        S.of(context).searchForProducts,
        maxLines: 1,
        style: Theme.of(context).textTheme.caption.copyWith(color: DmConst.textColorSearchBar, fontSize: 15),
      );
    }
  }
}


