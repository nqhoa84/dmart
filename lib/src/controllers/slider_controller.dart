import 'package:mvc_pattern/mvc_pattern.dart';
import '../../src/repository/slider_repository.dart';
import '../models/slider.dart';

class SliderController extends ControllerMVC {
  List<Slider> sliders = <Slider>[];

  SliderController() {
    listenForSliders();
  }

  void listenForSliders({String message}) async {
    final Stream<Slider> stream = await getSliders();
    stream.listen((Slider _slider) {
      setState(() {
        sliders.add(_slider);
      });
    }, onError: (a) {print(a);
    }, onDone: () {});
  }

  Future<void> refreshSliders() async {
    sliders.clear();
    listenForSliders(message: 'Sliders refreshed successfuly');
  }
}
