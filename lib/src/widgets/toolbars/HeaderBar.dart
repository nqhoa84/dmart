import 'package:dmart/DmState.dart';
import 'package:dmart/constant.dart';
import 'package:dmart/src/helpers/ui_icons.dart';
import 'package:flutter/material.dart';
import 'SearchBar.dart';

class HeaderBar extends StatefulWidget {
  const HeaderBar({
    Key key,
    this.haveBackIcon = true, this.haveFilter = false, this.title = ''
  }) : super(key: key);

  final bool haveBackIcon, haveFilter;
  final String title;

  @override
  _HeaderBarState createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {

  @override
  Widget build(BuildContext context) {
    TextStyle ts =
    Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white);

    List<Widget> _buildMenu() {
      List<Widget> re = [];
      if (widget.title != null && widget.title.isNotEmpty) {
//      re.add(VerticalDivider(color: Colors.white, thickness: 2, width: 10,));
        re.add(Container(
            padding: EdgeInsets.fromLTRB(8, 5, 0, 5),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.white, width: 1.5)),
            ),
            child: Center(child: Text(widget.title ?? '', style: ts))));
      }
      return re;
    }

    return SliverAppBar(
      toolbarHeight: DmConst.appBarHeight * 0.6,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,

      leading: widget.haveBackIcon
          ? new IconButton(
        icon: new Icon(UiIcons.return_icon),
        onPressed: () => Navigator.of(context).pop(),
      )
          : null,
//    centerTitle: true,
      title: Align(
          alignment: Alignment.centerRight,
          // child: SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: _buildMenu(),
          //   ),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildMenu(),
          )
      ),
      actions: <Widget>[widget.haveFilter ? InkWell(
          onTap: onTapOpenFitlterDialog,
          child: Icon(Icons.menu)) : Container()],
      backgroundColor: DmConst.accentColor,
    );
  }

  void onTapOpenFitlterDialog() {
    Scaffold.of(context).openEndDrawer();
  }
}
