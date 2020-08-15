import 'package:flutter/material.dart';

class SocialMediaWidget extends StatelessWidget {
  const SocialMediaWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () {},
            child: Image.asset('assets/img/facebook.png'),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () {},
            child: Image.asset('assets/img/twitter.png'),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () {},
            child: Image.asset('assets/img/google-plus.png'),
          ),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: () {},
            child: Image.asset('assets/img/linkedin.png'),
          ),
        )
      ],
    );
  }
}
