import 'package:dmart/src/widgets/IconWithText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../DmState.dart';
import '../../constant.dart';
import '../helpers/ui_icons.dart';

class CartBottomButton extends StatelessWidget {
  const CartBottomButton({Key key, this.title = '', this.onPressed}) : super(key: key);

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DmConst.colorFavorite.withOpacity(0.96),
//      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//      decoration: BoxDecoration(
////                color: Theme.of(context).primaryColor,
//          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
////                border: Border.all(color: Colors.red, width: 2),
//          boxShadow: [
//            BoxShadow(color: DmConst.colorFavorite.withOpacity(0.9), offset: Offset(0, -2), blurRadius: 5.0)
//          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: DmState.amountInCart,
                  builder: (context, value, child) {
                    return IconWithText(
                        title: '${DmState.amountInCart.value}',
                        icon: UiIcons.shopping_cart,
                        color: Colors.white,
                        style: Theme.of(context).textTheme.headline6);
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: DmState.cartsValue,
                  builder: (context, value, child) {
                    return IconWithText(
                        title: '${DmState.cartsValue.value.toStringAsFixed(2)}',
                        icon: UiIcons.money,
                        color: Colors.white,
                        style: Theme.of(context).textTheme.headline6);
                  },
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
          ),
          VerticalDivider(thickness: 2, width: 5, color: Colors.white),
          Expanded(
              child: Center(
                child: InkWell(
            // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                child: Text(title, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white)),
            ),
            onTap: onPressed,
          ),
              ))
//                FlatButton(child: Text(S.of(context).processOrder))
        ],
      ),
    );
  }
}
