import 'dart:async';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
class FlashSalesHeaderWidget extends StatefulWidget {
  const FlashSalesHeaderWidget({
    Key key,
  }) : super(key: key);

  @override
  _FlashSalesHeaderWidgetState createState() => _FlashSalesHeaderWidgetState();
}

class _FlashSalesHeaderWidgetState extends State<FlashSalesHeaderWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0),
        leading: Icon(
          UiIcons.megaphone,
          color: Theme.of(context).hintColor,
        ),
        title: Text( 'trending_this_week',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
