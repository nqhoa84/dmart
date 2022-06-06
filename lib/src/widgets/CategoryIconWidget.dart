//import 'package:cached_network_image/cached_network_image.dart';
import 'package:dmart/buidUI.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../src/models/category.dart';
import 'package:flutter/material.dart';

class CategoryIconWidget extends StatefulWidget {
  Category category;
  String heroTag;
  double marginLeft;
  ValueChanged<int> onPressed;

  CategoryIconWidget(
      {Key? key,
      required this.category,
      required this.heroTag,
      required this.marginLeft,
      required this.onPressed})
      : super(key: key);

  @override
  _CategoryIconWidgetState createState() => _CategoryIconWidgetState();
}

class _CategoryIconWidgetState extends StateMVC<CategoryIconWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsetsDirectional.only(
          start: widget.marginLeft, top: 10, bottom: 10),
      child: buildSelectedCategory(context),
    );
  }

  InkWell buildSelectedCategory(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      highlightColor: Theme.of(context).colorScheme.secondary,
      onTap: () {
        setState(() {
          widget.onPressed(widget.category.id);
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: widget.category.selected!
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Hero(
              tag: widget.heroTag + '${widget.category.id}',
              child: widget.category.image!.url!.toLowerCase().endsWith('.svg')
                  ? Container(
                      height: 32,
                      width: 32,
                      child: SvgPicture.network(
                        widget.category.image!.url!,
                        color: widget.category.selected!
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).primaryColor,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
//                      child: CachedNetworkImage(
//                        height: 32,
//                        width: 32,
//                        fit: BoxFit.cover,
//                        imageUrl: widget.category.image.thumb,
//                        placeholder: (context, url) => Image.asset(
//                          'assets/img/loading.gif',
//                          fit: BoxFit.cover,
//                          height: 32,
//                          width: 32,
//                        ),
//                        errorWidget: (context, url, error) => Icon(Icons.error),
//                      ),
                      child: createNetworkImage(
                          url: widget.category.image!.thumb!,
                          width: 32,
                          height: 32),
                    ),
            ),
            SizedBox(width: 10),
            AnimatedSize(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              vsync: this,
              child: Text(
                widget.category.selected! ? widget.category.name : '',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
