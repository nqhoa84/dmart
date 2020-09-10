import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/repository/promotion_repository.dart';
import '../models/promotion.dart';

class PromotionController extends ControllerMVC {
  List<Promotion> promotions = <Promotion>[];

  PromotionController();

  void listenForPromotions({String message}) async {
    final Stream<Promotion> stream = await getPromotions();
    promotions.clear();
    stream.listen((Promotion _slider) {
      if(_slider.isValid) {
        setState(() {
          promotions.add(_slider);
        });
      } else {
        print('promotion $_slider is Invalid');
      }

    }, onError: (a) {print(a);
    }, onDone: () {
      print('promotions.length ${promotions.length}');
    });
  }

  Future<void> refreshPromotions() async {
    listenForPromotions(message: 'Sliders refreshed successfully');
  }
}
