import 'package:dmart/src/models/i_name.dart';
import 'package:flutter/material.dart';

class DmDropDown extends StatefulWidget {
  final List<IdNameObj> items;
  DmDropDown({@required this.items = const []});

  @override
  _DmDropDownState createState() => _DmDropDownState(items: this.items);
}

class _DmDropDownState extends State<DmDropDown> {
  List<IdNameObj>? items;

  _DmDropDownState({required List<IdNameObj> items}) {
    this.items = items;
    dropdownValue = items[0].name;
  }

  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white),
//      underline: Container(
//        height: 2,
//        color: Colors.deepPurpleAccent,
//      ),
//        selectedItemBuilder: (context) {
//          return [Text(dropdownValue, style: TextStyle(color: Colors.white))];
//        },
//      selectedItemBuilder: (BuildContext context) {
//        return items.map ((IdNameObj item) {
//          return Text(item.name, style: TextStyle(color: Colors.white));
//        }).toList();
//      },
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((IdNameObj value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(
            value.name,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
