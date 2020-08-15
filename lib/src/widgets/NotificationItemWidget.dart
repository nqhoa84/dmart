import '../../src/helpers/helper.dart';
import 'package:intl/intl.dart';

import '../../src/helpers/ui_icons.dart';
import '../../src/models/notification.dart' as model;
import 'package:flutter/material.dart';

class NotificationItemWidget extends StatefulWidget {

  NotificationItemWidget({Key key, this.notification, this.onDismissed}) : super(key: key);
  model.Notification notification;
  ValueChanged<model.Notification> onDismissed;

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
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
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed(widget.notification);
        });

        // Then show a snackbar.
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("${widget.notification.id} dismissed")));
      },
      child: Container(
        color: this.widget.notification.read ? Colors.transparent : Theme.of(context).focusColor.withOpacity(0.15),
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
                      gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                        Theme.of(context).focusColor.withOpacity(0.7),
                        Theme.of(context).focusColor.withOpacity(0.05),
                      ])),
                  child: Icon(
                    Icons.notifications,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 40,
                  ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
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
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
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
                    Helper.trans(this.widget.notification.type),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.body2.merge(
                        TextStyle(fontWeight: this.widget.notification.read ? FontWeight.w300 : FontWeight.w600)),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd - HH:mm').format(this.widget.notification.createdAt),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
