import 'package:dmart/constant.dart';
import 'package:dmart/src/models/brand.dart';
import 'package:dmart/src/models/category.dart';
import 'package:dmart/src/models/product.dart';
import 'package:dmart/utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/filter_controller.dart';
import '../widgets/CircularLoadingWidget.dart';
import '../models/filter.dart';

class FilterWidget extends StatefulWidget { // ignore: must_be_immutable
  List<Product> products;
  final ValueNotifier<FilterCondition> filterNotifier;

  FilterWidget({Key key, this.filterNotifier, this.products}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends StateMVC<FilterWidget> {
  FilterController _con;

  _FilterWidgetState() : super(FilterController()) {
    _con = controller;
    _cateExpCtrl = ExpandableController(initialExpanded: false);
    this._cateExpCtrl.expanded = false;
    _brandExpCtrl = ExpandableController(initialExpanded: false);
    this._brandExpCtrl.expanded = false;
    _countryExpCtrl = ExpandableController(initialExpanded: false);
    this._countryExpCtrl.expanded = false;
  }

  _extractDataFromProducts() {
    this.cates.clear();
    this.brands.clear();
    this.countries.clear();
    if (widget.products == null) return;

    widget.products.forEach((p) {
//      print('${p.category} in list $cates');
      if (p.category != null && !cates.contains(p.category)) {
        cates.add(p.category);
      }

      if (p.brand != null && !brands.contains(p.brand)) {
        brands.add(p.brand);
      }
      if (DmUtils.isNotNullEmptyStr(p.country)) {
        var ct = p.country.trim().toUpperCase();
        if (!countries.contains(ct)) countries.add(ct);
      }
    });
//    print('cates $cates');
//    print('brands $brands');
//    print('countries $countries');
  }

  List<Category> cates = [];
  List<Brand> brands = [];
  List<String> countries = [];
  bool isPriceUp;
  bool isLatest;

  FilterCondition filter = FilterCondition();

  @override
  void initState() {
    filter.copyFrom(widget.filterNotifier.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _extractDataFromProducts();

    Widget createTitleRow(String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      );
    }

    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //header: Filter - clear
              Container(
                padding: const EdgeInsets.all(8),
                color: DmConst.accentColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(S.current.filter),
                    OutlineButton(
                      onPressed: onPressClearFilter,
                      child: Text(S.current.clear, style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              createTitleRow(S.current.categories),
              _createCateExpansion(),
              Divider(thickness: 1),
              createTitleRow(S.current.brands),
              _createBrandExpansion(),
              Divider(thickness: 1),
              DmUtils.isNotNullEmptyList(this.countries) ? createTitleRow(S.current.country) : SizedBox(),
              _createCountryExpansion(),
              DmUtils.isNotNullEmptyList(this.countries) ? Divider(thickness: 1) : SizedBox(),
              Row(
                children: [
                  Expanded(
                    child: createCheckbox(
                        label: S.current.promotion,
                        tristate: true,
                        isChecked: filter.isPromotion,
                        onChanged: (v) {
                          setState(() {
                            filter.isPromotion = v;
                          });
                        }
                    ),
                  ),
                  Expanded(
                    child: createCheckbox(
                        label: S.current.bestSale,
                        tristate: true,
                        isChecked: filter.isBestSale,
                        onChanged: (v) {
                          setState(() {
                            filter.isBestSale = v;
                          });
                        }
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: createCheckbox(
                        label: S.current.newArrival,
                        tristate: true,
                        isChecked: filter.isNewArrival,
                        onChanged: (v) {
                          setState(() {
                            filter.isNewArrival = v;
                          });
                        }
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1),
              createTitleRow(S.current.sortBy),
              Row(
                children: [
                  Expanded(
                    child: createCheckbox(
                        label: S.current.priceIncreasing,
                        tristate: true,
                        isChecked: filter.isPriceUp,
                        onChanged: (v) {
                          setState(() {
                            filter.isPriceUp = v;
                          });
                        }
                    ),
                  ),
                  Expanded(
                    child: createCheckbox(
                        label: S.current.latestDate,
                        tristate: true,
                        isChecked: filter.isLatest,
                        onChanged: (v) {
                          setState(() {
                            filter.isLatest = v;
                          });
                        }
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                onPressed: onPressApply,
                child: Text(S.current.applyFilters),
                color: DmConst.accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ExpandableController _cateExpCtrl, _brandExpCtrl, _countryExpCtrl;
  var expTheme = ExpandableThemeData(
      headerAlignment: ExpandablePanelHeaderAlignment.center,
      tapBodyToExpand: false,
      tapBodyToCollapse: false,
      tapHeaderToExpand: false,
      hasIcon: false,
      useInkWell: true);

  ///If [tristate] is true the checkbox's value [isChecked] can be true, false, or null.<br/>
  ///Checkbox displays a dash when its value is null.<br/>
  ///When a tri-state checkbox (tristate is true) is tapped, its onChanged callback will be applied to true if the current value is false, to null if value is true, and to false if value is null (i.e. it cycles through false => true => null => false when tapped).
  ///If tristate is false (the default), value must not be null.
  Widget createCheckbox({String label, bool isChecked, bool tristate = false, Function(bool) onChanged}) {
//    return OutlineButton.icon(onPressed: null, icon: Checkbox(
//      value: true,
//    ), label: Text(label));

    return Row(
      children: [
        Checkbox(value: isChecked,
            tristate: tristate,
            activeColor: DmConst.accentColor,
            onChanged: onChanged),
        Expanded(child: Text(label ?? '', style: TextStyle(fontWeight: FontWeight.normal, color: DmConst.accentColor))),
      ],
    );

  }

  Widget _createCateExpansion() {
    int len = cates.length;
    List<TableRow> rows = [];
    for (int i = 0; i < cates.length; i = i + 2) {
      rows.add(TableRow(children: [
        createCheckbox(
            label: cates[i].name,
            isChecked: isCateChecked(cates[i]),
            onChanged: (value) {
              onCheckedCateChanged(value, cates[i]);
            }),
        i + 1 < len
            ? createCheckbox(
                label: cates[i + 1].name,
                isChecked: isCateChecked(cates[i + 1]),
                onChanged: (value) {
                  onCheckedCateChanged(value, cates[i + 1]);
                })
            : SizedBox(),
      ]));
    }
    if (rows.isEmpty) return SizedBox();
    var flexCol = {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(1),
    };
    if (rows.length == 1) {
      return Table(
        columnWidths: flexCol,
        children: [rows[0]],
      );
    } else if (rows.length == 2) {
      return Table(
        columnWidths: flexCol,
        children: [rows[0], rows[1]],
      );
    } else {
      return Column(
        children: [
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: true,
              child: ExpandablePanel(
                controller: _cateExpCtrl,
                theme: expTheme,
                header: Table(
                  columnWidths: flexCol,
                  children: [rows[0]],
                ),
                expanded: Table(
                  columnWidths: flexCol,
                  children: rows.sublist(1),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 20),
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      onPressed: () {
                        setState(() {
                          this._cateExpCtrl.expanded = !this._cateExpCtrl.expanded;
                        });
                      },
                      child: Icon(
                          this._cateExpCtrl.expanded == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  Widget _createBrandExpansion() {
    int len = brands.length;
    List<TableRow> rows = [];
    for (int i = 0; i < brands.length; i = i + 2) {
      rows.add(TableRow(children: [
        createCheckbox(
            label: brands[i].name,
            isChecked: isBrandChecked(brands[i]),
            onChanged: (value) {
              onCheckedBrandChanged(value, brands[i]);
            }),
        i + 1 < len
            ? createCheckbox(
                label: brands[i + 1].name,
                isChecked: isBrandChecked(brands[i + 1]),
                onChanged: (value) {
                  onCheckedBrandChanged(value, brands[i + 1]);
                })
            : SizedBox(),
      ]));
    }
    if (rows.isEmpty) return SizedBox();
    var flexCol = {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(1),
    };
    if (rows.length == 1) {
      return Table(
        columnWidths: flexCol,
        children: [rows[0]],
      );
    } else if (rows.length == 2) {
      return Table(
        columnWidths: flexCol,
        children: [rows[0], rows[1]],
      );
    } else {
      return Column(
        children: [
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: true,
              child: ExpandablePanel(
                controller: _brandExpCtrl,
                theme: this.expTheme,
                header: Table(
                  columnWidths: flexCol,
                  children: [rows[0]],
                ),
                expanded: Table(
                  columnWidths: flexCol,
                  children: rows.sublist(1),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 20),
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      onPressed: () {
                        setState(() {
                          this._brandExpCtrl.expanded = !this._brandExpCtrl.expanded;
                        });
                      },
                      child: Icon(
                          this._brandExpCtrl.expanded == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: DmConst.accentColor),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  Widget _createCountryExpansion() {
    int len = countries.length;
    List<TableRow> rows = [];
    for (int i = 0; i < countries.length; i = i + 2) {
      rows.add(TableRow(children: [
        createCheckbox(
            label: countries[i],
            isChecked: isCountryChecked(countries[i]),
            onChanged: (value) {
              onCheckedCountryChanged(value, countries[i]);
            }),
        i + 1 < len
            ? createCheckbox(
                label: countries[i + 1],
                isChecked: isCountryChecked(countries[i + 1]),
                onChanged: (value) {
                  onCheckedCountryChanged(value, countries[i]);
                })
            : SizedBox(),
      ]));
    }
    if (rows.isEmpty) return SizedBox();
    var flexCol = {
      0: FlexColumnWidth(1),
      1: FlexColumnWidth(1),
    };
    if (rows.length == 1) {
      return Table(
        columnWidths: flexCol,
        children: [rows[0]],
      );
    } else if (rows.length == 2) {
      return Table(
        columnWidths: flexCol,
        children: [rows[0], rows[1]],
      );
    } else {
      return Column(
        children: [
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: true,
              child: ExpandablePanel(
                controller: _countryExpCtrl,
                theme: this.expTheme,
                header: Table(
                  columnWidths: flexCol,
                  children: [rows[0]],
                ),
                expanded: Table(
                  columnWidths: flexCol,
                  children: rows.sublist(1),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DmConst.masterHorizontalPad),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 20),
                    child: OutlineButton(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      onPressed: () {
                        setState(() {
                          this._countryExpCtrl.expanded = !this._countryExpCtrl.expanded;
                        });
                      },
                      child: Icon(
                          this._countryExpCtrl.expanded == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: DmConst.accentColor),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }

  void onCheckedCateChanged(bool value, Category cat) {
    print('onCheckedChanged - $value - $cat');
    setState(() {
      if (value) {
        this.filter.addCate(cat);
      } else {
        this.filter.removeCate(cat);
      }
    });

    print('selected cates: ${this.filter.cates}');
  }

  void onCheckedBrandChanged(bool value, Brand cat) {
    print('onCheckedBrandChanged - $value - $cat');
    setState(() {
      if (value) {
        this.filter.addBrand(cat);
      } else {
        this.filter.removeBrand(cat);
      }
    });
    print('selected brands: ${this.filter.brands}');
  }

  void onCheckedCountryChanged(bool value, String cat) {
    print('onCheckedCountryChanged - $value - $cat');
    setState(() {
      if (value) {
        this.filter.removeCountry(cat);
      } else {
        this.filter.removeCountry(cat);
      }
    });
    print('selected countries: ${this.filter.countries}');
  }

  bool isCateChecked(Category c) {
    if (filter.cates == null) return false;
    return filter.cates.contains(c);
  }

  bool isBrandChecked(Brand b) {
    if (filter.brands == null) return false;
    return filter.brands.contains(b);
  }

  bool isCountryChecked(String c) {
    if (filter.countries == null) return false;
    return filter.countries.contains(c);
  }

  void onPressClearFilter() {
    setState(() {
      this.filter = FilterCondition();
//      this.filter.clear();
    });
  }

  void onPressApply() {
//    setState(() {
//      widget.filter.copyFrom(this.filter);
//      print(widget.filter);
//    });
    widget.filterNotifier?.value = this.filter;
    Navigator.of(context).pop();
  }

}
