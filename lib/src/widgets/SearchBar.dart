
import 'package:dmart/constant.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import '../widgets/SearchWidget.dart';
import '../../generated/l10n.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged onClickFilter;

  const SearchBar({Key key, this.onClickFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(SearchModal());
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12, start: 0),
              child: Icon(UiIcons.loupe, color: DmConst.primaryColor),
//              child: Image.asset('assets/img/S_Search.png', width: 25),
            ),
            Expanded(
              child: Text(
                S.of(context).searchForProducts,
                maxLines: 1,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
              ),
            ),
            InkWell(
              onTap: () {
                onClickFilter('e');
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5, top: 3, bottom: 3),
                child: Icon(UiIcons.settings_2, color: DmConst.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
