import 'package:dmart/constant.dart';
import 'package:dmart/src/models/noti.dart';

import 'package:intl/intl.dart';

import '../../src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatefulWidget {
  NotificationItem(
      {Key? key, required this.notification, required this.onDismissed})
      : super(key: key);
  Noti notification;
  ValueChanged<Noti> onDismissed;

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              UiIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: onDismissed,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: DmConst.accentColor),
          ),
        ),
        // color: this.widget.notification.read ? Colors.transparent : Theme.of(context).focusColor.withOpacity(0.15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Theme.of(context).focusColor.withOpacity(0.7),
                            Theme.of(context).focusColor.withOpacity(0.05),
                          ])),
                  child: Icon(Icons.notifications,
                      color: widget.notification.tapable
                          ? DmConst.accentColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      // color: Theme.of(context).scaffoldBackgroundColor,
                      size: 40),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    '${this.widget.notification.title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: widget.notification.tapable
                            ? DmConst.accentColor
                            : Theme.of(context).textTheme.bodyText1!.color,
                        fontWeight: this.widget.notification.read
                            ? FontWeight.w300
                            : FontWeight.w600),
                  ),
                  Text(
                      DateFormat('yyyy-MM-dd - HH:mm')
                          .format(this.widget.notification.dateTime!),
                      style: Theme.of(context).textTheme.caption),
                  Text(
                    '${widget.notification.body}',
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onDismissed(DismissDirection direction) {
    setState(() {
      widget.onDismissed(widget.notification);
    });
  }
}
