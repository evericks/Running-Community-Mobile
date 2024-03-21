import 'package:flutter/material.dart';
import 'package:running_community_mobile/screens/LoginScreen.dart';
import 'package:running_community_mobile/screens/SignUpScreen.dart';
import '../screens/DashboardScreen.dart';
import '../screens/SplashScreen.dart';
import '../screens/NotFoundScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case DashboardScreen.routeName:
      return MaterialPageRoute(builder: (_) => DashboardScreen());
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    default:
      return MaterialPageRoute(builder: (_) => const NotFoundScreen());
  }
}


