//import 'package:cached_network_image/cached_network_image.dart';

import '../../buidUI.dart';
import '../../src/models/brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandIconWidget extends StatefulWidget {
  Brand brand;
  String heroTag;
  double marginLeft;
  ValueChanged<int> onPressed;

  BrandIconWidget(
      {Key key, this.brand, this.heroTag, this.marginLeft, this.onPressed})
      : super(key: key);

  @override
  _BrandIconWidgetState createState() => _BrandIconWidgetState();
}

class _BrandIconWidgetState extends State<BrandIconWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.only(right: widget.marginLeft, top: 10, bottom: 10),
      child: buildSelectedBrand(context),
    );
  }

  InkWell buildSelectedBrand(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).accentColor,
      onTap: () {
        setState(() {
          widget.onPressed(widget.brand.id);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: widget.brand.selected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Hero(
              tag: widget.heroTag + widget.brand.id.toString(),
              child: widget.brand.image.url.toLowerCase().endsWith('.svg') ? Container(
                height: 36,
                width: 36,
                child: SvgPicture.network(
                  widget.brand.image.url,
                  color: widget.brand.selected?Theme.of(context).accentColor:Theme.of(context).primaryColor,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
//                child: CachedNetworkImage(
//                  height: 32,
//                  width: 32,
//                  fit: BoxFit.cover,
//                  imageUrl: widget.brand.image.thumb,
//                  placeholder: (context, url) => Image.asset(
//                    'assets/img/loading.gif',
//                    fit: BoxFit.cover,
//                    height: 32,
//                    width: 32,
//                  ),
//                  errorWidget: (context, url, error) => Icon(Icons.error),
//                ),
                child: createNetworkImage(url: widget.brand.image.thumb, width: 32, height: 32),
              ),
            ),
            SizedBox(width: 10),
            AnimatedSize(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              vsync: this,
              child: Row(
                children: <Widget>[
                  Text(
                    widget.brand.selected ? widget.brand.name : '',
                    style: TextStyle(fontSize: 14, color: Theme.of(context).accentColor),
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
