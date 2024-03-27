import 'package:flutter/material.dart';
import 'package:running_community_mobile/screens/CreateGroupScreen.dart';
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
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (_) => const CreateGroupScreen());
      // case CameraScreen.routeName:
      // return MaterialPageRoute(builder: (_) => const CameraScreen());
    default:
      return MaterialPageRoute(builder: (_) => const NotFoundScreen());
  }
}


