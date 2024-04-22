import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:running_community_mobile/screens/ExerciseItemScreen.dart';
import 'package:running_community_mobile/screens/FullScreenVideoScreen.dart';
import 'package:running_community_mobile/screens/QRCodeScreen.dart';
import 'package:running_community_mobile/screens/SeeAllTournamentScreen.dart';
import 'package:video_player/video_player.dart';
import '../screens/CreateGroupScreen.dart';
import '../screens/CreatePostScreen.dart';
import '../screens/DashboardScreen.dart';
import '../screens/ExerciseScreen.dart';
import '../screens/GroupDetailScreen.dart';
import '../screens/LoginScreen.dart';
import '../screens/PostDetailScreen.dart';
import '../screens/PostsScreen.dart';
import '../screens/SignUpScreen.dart';
import '../screens/SplashScreen.dart';
import '../screens/NotFoundScreen.dart';
import '../screens/TournamentDetailScreen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case DashboardScreen.routeName:
      return MaterialPageRoute(builder: (_) => DashboardScreen(tabIndex: settings.arguments as int,));
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(builder: (_) => const CreateGroupScreen());
    case GroupDetailScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => GroupDetailScreen(
                id: settings.arguments.toString(),
              ));
    case PostsScreen.routeName:
      return MaterialPageRoute(builder: (_) => PostsScreen(groupId: settings.arguments.toString(),));
    case CreatePostScreen.routeName:
      return MaterialPageRoute(builder: (_) => CreatePostScreen(groupId: settings.arguments.toString(),));
    case PostDetailScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => PostDetailScreen(
                postId: settings.arguments.toString(),
              ));
    case ExerciseScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => ExerciseScreen(
                id: settings.arguments.toString(),
              ));
    case ExerciseItemScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => ExerciseItemScreen(
                id: settings.arguments.toString(),
              ));
    case FullScreenVideoScreen.routeName:
      return MaterialPageRoute(
          builder: (_) => FullScreenVideoScreen(
                videoPlayerController: settings.arguments as VideoPlayerController,
              ));
    case SeeAllTournamentScreen.routeName:
      return MaterialPageRoute(builder: (_) => SeeAllTournamentScreen(status: settings.arguments as String,));
    case TournamentDetailScreen.routeName:
      return MaterialPageRoute(builder: (_) => TournamentDetailScreen(id: settings.arguments as String,));
    case QRCodeScreen.routeName:
      return MaterialPageRoute(builder: (_) => QRCodeScreen(qrCodeImage: settings.arguments as Uint8List,));
    default:
      return MaterialPageRoute(builder: (_) => const NotFoundScreen());
  }
}
