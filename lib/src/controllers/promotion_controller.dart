import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/repository/promotion_repository.dart';
import '../models/promotion.dart';

class PromotionController extends ControllerMVC {
  List<Promotion> promotions = <Promotion>[];

  PromotionController() {
    listenForPromotions();
  }

  void listenForPromotions({String message}) async {
    final Stream<Promotion> stream = await getPromotions();
    promotions.clear();
    stream.listen((Promotion _slider) {
      setState(() {
        promotions.add(_slider);
      });
    }, onError: (a) {print(a);
    }, onDone: () {});
  }

  Future<void> refreshPromotions() async {
    listenForPromotions(message: 'Sliders refreshed successfully');
  }
}
