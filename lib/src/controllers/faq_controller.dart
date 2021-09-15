import 'package:dmart/src/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/faq_category.dart';
import '../repository/faq_repository.dart';

class FaqController extends Controller {
  List<FaqCategory> faqs;

  FaqController() {
    scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForFaqs({String message}) async {
    final Stream<FaqCategory> stream = await getFaqCategories();
    if(faqs == null) faqs = [];
    stream.listen((FaqCategory _faq) {
      setState(() {
        faqs.add(_faq);
      });
    }, onError: (a) {
      print(a);
      showErrNoInternet();
    }, onDone: () {
      if (message != null) {
        showMsg(message);
      }
    });
  }

  Future<void> refreshFaqs() async {
    if(faqs != null) faqs.clear();
    listenForFaqs();
  }
}
