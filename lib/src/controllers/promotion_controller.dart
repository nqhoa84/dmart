import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/repository/promotion_repository.dart';
import '../models/promotion.dart';
import 'controller.dart';

class PromotionController extends Controller {
  List<Promotion> promotions = <Promotion>[];

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

  Future<Promotion> loadPromotion({int id}) async{
    //TODO need api from to get info of one promotion.
    return Promotion()..id = id;
  }
}
