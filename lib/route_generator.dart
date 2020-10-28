import 'package:dmart/src/screens/ProfileUpdated.dart';
import 'package:dmart/src/screens/bottom_right_menu.dart';
import 'package:dmart/src/screens/contactus.dart';
import 'package:dmart/src/screens/delivery_to.dart';
import 'package:dmart/src/screens/error.dart';
import 'package:dmart/src/screens/home2.dart';
import 'package:dmart/src/screens/new_arrival.dart';
import 'package:dmart/src/screens/notifications.dart';
import 'package:dmart/src/screens/orders.dart';
import 'package:dmart/src/screens/promotions.dart';
import 'package:flutter/material.dart';

import 'src/models/route_argument.dart';
import 'src/screens/ProfileInfoScreen.dart';
import 'src/screens/best_sale.dart';
import 'src/screens/brand.dart';
import 'src/screens/brands.dart';
import 'src/screens/cart.dart';
import 'src/screens/categories.dart';
import 'src/screens/category.dart';
import 'src/screens/checkout.dart';
import 'src/screens/debug.dart';
import 'src/screens/addressesScreen.dart';
import 'src/screens/favorites.dart';
import 'src/screens/forget_password.dart';
import 'src/screens/help.dart';
import 'src/screens/payment_methods.dart';
import 'src/screens/paypal_payment.dart';
import 'src/screens/product_detail.dart';
import 'src/screens/promotion.dart';
import 'src/screens/razorpay_payment.dart';
import 'src/screens/reviews.dart';
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
    replaceOld ? Navigator.of(context).pushReplacementNamed('/Login')
        : Navigator.of(context).pushNamed('/Login');
  }

  static void gotoForgetPass(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/ForgetPassword')
        : Navigator.of(context).pushNamed('/ForgetPassword');
  }

  ///This will remove all route, except /Home
  static void gotoHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
//    Navigator.of(context).pushReplacementNamed('/Home');
  }
  static void gotoCategories(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/Categories', (Route<dynamic> route) => false);

//    Navigator.of(context).pushReplacementNamed('/Categories');
  }
  static void gotoPromotions(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/Promotions', (Route<dynamic> route) => false);
//    Navigator.of(context).pushReplacementNamed('/Promotions');
  }
  static void gotoNotifications(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/Notifications', (Route<dynamic> route) => false);
//    Navigator.of(context).pushReplacementNamed('/Notifications');
  }
  static void gotoMenu(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/BottomRightMenu', (Route<dynamic> route) => false);
//    Navigator.of(context).pushReplacementNamed('/BottomRightMenu');
  }

  static void gotoBestSale(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/BestSale')
        : Navigator.of(context).pushNamed('/BestSale');
  }

  static void gotoNewArrivals(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/NewArrivals')
        : Navigator.of(context).pushNamed('/NewArrivals');
  }

  static void gotoMyFavorites(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/MyFavorites')
    : Navigator.of(context).pushNamed('/MyFavorites');
  }


  static void gotoMyOrders(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushReplacementNamed('/MyOrders')
        : Navigator.of(context).pushNamed('/MyOrders');
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

  static void gotoProfileUpdatedScreen(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/ProfileUpdated', (Route<dynamic> route) => false);
  }

  static gotoProfileInfo(BuildContext context, {bool replaceOld = false}) {
    replaceOld ? Navigator.of(context).pushNamedAndRemoveUntil('/ProfileInfo', (Route<dynamic> route) => false)
        : Navigator.of(context).pushNamed('/ProfileInfo') ;
  }

  static gotoAddressesScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/Addresses');
//    replaceOld ? Navigator.of(context).pushNamedAndRemoveUntil('/A', (Route<dynamic> route) => false)
//        : Navigator.of(context).pushNamed('/Addresses') ;
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
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
//      case '/Pages':
//        return MaterialPageRoute(builder: (_) => PagesScreen(currentTab: args));

      case '/Product':
        return MaterialPageRoute(builder: (_) => ProductDetailScreen(routeArgument: args as RouteArgument));
      case '/Brand':
        return MaterialPageRoute(builder: (_) => BrandWidget(routeArgument: args as RouteArgument));
      case '/Brands':
        return MaterialPageRoute(builder: (_) => BrandsWidget());
      case '/Category':
        return MaterialPageRoute(builder: (_) => CategoryScreen(routeArgument: args as RouteArgument));


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
      case '/Addresses':
        return MaterialPageRoute(builder: (_) => AddressesScreen());
      case '/Checkout'://todo unused
        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/PayPal':
        return MaterialPageRoute(builder: (_) => PayPalPaymentWidget(routeArgument: args as RouteArgument));
      case '/RazorPay':
        return MaterialPageRoute(builder: (_) => RazorPayPaymentWidget(routeArgument: args as RouteArgument));
     case '/Help':
        return MaterialPageRoute(builder: (_) => HelpScreen());
      case '/ProfileInfo':
        return MaterialPageRoute(builder: (_) => ProfileInfoScreen());

      case '/MyFavorites':
        return MaterialPageRoute(builder: (_) => FavoritesScreen());
      case '/ContactUs':
        return MaterialPageRoute(builder: (_) => ContactUsScreen());

      case '/MyOrders':
        return MaterialPageRoute(builder: (_) => OrdersScreen());
      case '/Promotion':
        return MaterialPageRoute(builder: (_) => PromotionScreen(routeArgument: args as RouteArgument));

      case '/Home':
        return MaterialPageRoute(builder: (_) => Home2Screen());
      case '/Categories':
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      case '/Promotions':
        return MaterialPageRoute(builder: (_) => PromotionsScreen());
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case '/BottomRightMenu':
        return MaterialPageRoute(builder: (_) => BottomRightMenuScreen());
      case '/BestSale':
        return MaterialPageRoute(builder: (_) => BestSaleScreen());
      case '/NewArrivals':
        return MaterialPageRoute(builder: (_) => NewArrivalsScreen());
      case '/Special4U':
        return MaterialPageRoute(builder: (_) => Special4UScreen());

      case '/ProfileUpdated':
        return MaterialPageRoute(builder: (_) => ProfileUpdatedScreen());

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => ErrorScreen());
    }
  }




}
