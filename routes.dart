import 'package:flutter/widgets.dart';
import 'home/home_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
 // SplashScreen.routeName: (context) => SplashScreen(),
  //SignInScreen.routeName: (context) => SignInScreen(),
  //ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  //LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  //SignUpScreen.routeName: (context) => SignUpScreen(),
  //CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  //OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),

  // DeatilsScreen1.routeName:(context)=> DeatilsScreen1(),

  //AuthScreen.routeName: (context) => AuthScreen(),
  //ProfileScreen.routeName: (context) => ProfileScreen(),
};
