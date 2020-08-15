import 'src/screens/reviews.dart';
import 'src/screens/cart.dart';
import 'src/screens/checkout.dart';
import 'src/screens/debug.dart';
import 'src/screens/delivery_addresses.dart';
import 'src/screens/delivery_pickup.dart';
import 'src/screens/forget_password.dart';
import 'src/screens/order_success.dart';
import 'src/screens/payment_methods.dart';
import 'src/screens/paypal_payment.dart';
import 'src/screens/tracking.dart';
import 'src/screens/help.dart';
import 'src/screens/languages.dart';
import 'src/screens/brand.dart';
import 'src/screens/categories.dart';
import 'src/screens/category.dart';
import 'src/models/route_argument.dart';
import 'src/screens/pages.dart';
import 'src/screens/product.dart';
import 'src/screens/settings.dart';
import 'src/screens/signin.dart';
import 'src/screens/signup.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/brands.dart';
import 'package:flutter/material.dart';
import 'src/screens/razorpay_payment.dart';




class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget());
      case '/Login':
        return MaterialPageRoute(builder: (_) => SignInWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));

      /*case '/Details':
        return MaterialPageRoute(builder: (_) => DetailsWidget(routeArgument: args as RouteArgument));
      case '/Menu':
        return MaterialPageRoute(builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      */
      case '/Product':
        return MaterialPageRoute(builder: (_) => ProductWidget(routeArgument: args as RouteArgument));
      case '/Brand':
        return MaterialPageRoute(builder: (_) => BrandWidget(routeArgument: args as RouteArgument));
      case '/Brands':
        return MaterialPageRoute(builder: (_) => BrandsWidget());
      case '/Category':
      return MaterialPageRoute(builder: (_) => CategoryWidget(routeArgument: args as RouteArgument));
      case '/Categories':
        return MaterialPageRoute(builder: (_) => CategoriesWidget());

      case '/Cart':
        return MaterialPageRoute(builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/DeliveryPickup':
        return MaterialPageRoute(builder: (_) => DeliveryPickupWidget(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(builder: (_) => TrackingWidget(routeArgument: args as RouteArgument));
      case '/Reviews':
        return MaterialPageRoute(builder: (_) => ReviewsWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/DeliveryPickup':
        return MaterialPageRoute(builder: (_) => DeliveryPickupWidget(routeArgument: args as RouteArgument));
      case '/Checkout':
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/CashOnDelivery':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Cash on Delivery')));
      case '/PayOnPickup':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Pay on Pickup')));
      case '/PayPal':
        return MaterialPageRoute(builder: (_) => PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/RazorPay':
        return MaterialPageRoute(builder: (_) => RazorPayPaymentWidget(routeArgument: args as RouteArgument));
      case '/OrderSuccess':
        return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: args as RouteArgument));
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => Scaffold(body: SizedBox(height: 0)));
    }
  }
}
