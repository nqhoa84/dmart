import 'package:flutter/material.dart';

import '../../constant.dart';
class TitleDivider extends StatelessWidget {
  final String title;
  final Color titleTextColor;
  final Color dividerColor;
  final double dividerThickness;
  const TitleDivider({
    Key key, this.title = '',
    this.titleTextColor = DmConst.accentColor,
    this.dividerColor = Colors.black12,
    this.dividerThickness = 2
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Divider(thickness: this.dividerThickness, color: dividerColor),
        )),
        Text(title, style: Theme.of(context).textTheme.headline6.copyWith(
            color: titleTextColor
        )),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Divider(thickness: this.dividerThickness, color: dividerColor),
        )),
      ],
    );
  }
}