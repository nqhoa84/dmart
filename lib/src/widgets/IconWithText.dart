import 'package:dmart/constant.dart';
import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final TextStyle style;
//  final EdgeInsets padding;

  const IconWithText(
      {Key? key,
      this.title = '',
      this.icon = Icons.info_outline,
      this.color = DmConst.accentColor,
      this.style = const TextStyle(color: DmConst.accentColor)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: color),
        ),
        Expanded(
          child: Text(title, style: this.style.copyWith(color: this.color)),
        ),
      ],
    );
  }
}
