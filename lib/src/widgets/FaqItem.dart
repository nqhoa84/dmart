import 'package:dmart/constant.dart';
import 'package:flutter/material.dart';

import '../helpers/helper.dart';
import '../models/faq.dart';

class FaqItem extends StatelessWidget {
  final Faq faq;
  FaqItem({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Theme.of(context).focusColor.withOpacity(0.15),
          offset: Offset(0, 5),
          blurRadius: 15,
        )
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: DmConst.bgrColorSearchBar,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Text(
              Helper.skipHtml(this.faq.question),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: DmConst.accentColor),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: DmConst.accentColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5))),
            child: Text(
              Helper.skipHtml(this.faq.answer),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
