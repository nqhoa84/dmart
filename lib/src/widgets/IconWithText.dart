import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final TextStyle style;

  const IconWithText({Key key, this.title, this.icon, this.color, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color),
        SizedBox(width: 5),
        Text(
          title,
          style: this.style.copyWith(color: this.color)
        ),
      ],
    );
  }
}
