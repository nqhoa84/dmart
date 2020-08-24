import 'package:dmart/src/screens/contactus.dart';
import 'package:dmart/src/screens/delivery_to.dart';
import 'package:dmart/src/screens/error.dart';
import 'package:flutter/material.dart';
import 'src/models/route_argument.dart';
import 'src/screens/brand.dart';
import 'src/screens/brands.dart';
import 'src/screens/cart.dart';
import 'src/screens/categories_unused.dart';
import 'src/screens/category.dart';
import 'src/screens/checkout.dart';
import 'src/screens/debug.dart';
import 'src/screens/delivery_addresses.dart';
import 'src/screens/favorites.dart';
import 'src/screens/forget_password.dart';
import 'src/screens/help.dart';
import 'src/screens/order_success.dart';
import 'src/screens/pages.dart';
import 'src/screens/payment_methods.dart';
import 'src/screens/paypal_payment.dart';
import 'src/screens/product_detail.dart';
import 'src/screens/razorpay_payment.dart';
import 'src/screens/reviews.dart';
import 'src/screens/settings.dart';
import 'src/screens/signin.dart';
import 'src/screens/signup.dart';
import 'src/screens/special_4U.dart';
import 'src/screens/splash_screen.dart';
import 'src/screens/tracking.dart';

class RouteGenerator {
  static void gotoSplash(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/Splash', arguments: 0);
  }

  static gotoLogin(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushNamed('/Login')
        : Navigator.of(context).pushNamed('/Login');
  }

  static void gotoHome(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0)
        : Navigator.of(context).pushNamed('/Pages', arguments: 0);
  }
  static void gotoCategories(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
  }
  static void gotoPromotions(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2)
        : Navigator.of(context).pushNamed('/Pages', arguments: 2);
  }
  static void gotoNotifications(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 3);
  }
  static void gotoMenu(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 4);
  }
  static void gotoMyFavorites(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/MyFavorites')
    : Navigator.of(context).pushNamed('/MyFavorites');
  }
  static void gotoMyOrders(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/MyOrders') : Navigator.of(context).pushNamed('/MyOrders');
  }

  static void gotoCart(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/Cart', arguments: RouteArgument())
        : Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument()) ;
  }

  static gotoSpecial4U(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/Special4U', arguments: RouteArgument())
        : Navigator.of(context).pushNamed('/Special4U', arguments: RouteArgument()) ;
  }

  static gotoHelp(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/Help', arguments: RouteArgument())
        : Navigator.of(context).pushNamed('/Help', arguments: RouteArgument()) ;
  }

  static gotoContactUs(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/ContactUs')
        : Navigator.of(context).pushNamed('/ContactUs') ;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Debug':
        return MaterialPageRoute(builder: (_) => DebugWidget(routeArgument: args as RouteArgument));
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/Login':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesScreen(currentTab: args));

      case '/Product':
        return MaterialPageRoute(builder: (_) => ProductDetailScreen(routeArgument: args as RouteArgument));
      case '/Brand':
        return MaterialPageRoute(builder: (_) => BrandWidget(routeArgument: args as RouteArgument));
      case '/Brands':
        return MaterialPageRoute(builder: (_) => BrandsWidget());
      case '/Category':
        return MaterialPageRoute(builder: (_) => CategoryScreen(routeArgument: args as RouteArgument));
      case '/Categories': //todo unused
        return MaterialPageRoute(builder: (_) => CategoriesWidget());

      case '/Cart':
        return MaterialPageRoute(builder: (_) => CartsScreen(routeArgument: args as RouteArgument));
      case '/DeliveryPickup':
        return MaterialPageRoute(builder: (_) => DeliveryToScreen(routeArgument: args as RouteArgument));
      case '/Tracking':
        return MaterialPageRoute(builder: (_) => TrackingWidget(routeArgument: args as RouteArgument));
      case '/Reviews':
        return MaterialPageRoute(builder: (_) => ReviewsWidget(routeArgument: args as RouteArgument));
      case '/PaymentMethod':
        return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      case '/DeliveryAddresses':
        return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      case '/DeliveryPickup':
        return MaterialPageRoute(builder: (_) => DeliveryToScreen(routeArgument: args as RouteArgument));
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
      case '/Help':
        return MaterialPageRoute(builder: (_) => HelpScreen());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());

      case '/Special4U':
        return MaterialPageRoute(builder: (_) => Special4UScreen());
      case '/MyFavorites':
        return MaterialPageRoute(builder: (_) => FavoritesScreen());
      case '/ContactUs':
        return MaterialPageRoute(builder: (_) => ContactUsScreen());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => ErrorScreen());
    }
  }





}
