import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/notification/notification_cubit.dart';
import 'package:running_community_mobile/services/messaging_service.dart';
import 'firebase_options.dart';
import 'screens/DashboardScreen.dart';
import 'screens/SplashScreen.dart';
import 'utils/constants.dart';
import 'utils/get_it.dart';
import 'utils/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await initialGetIt();
  var accessToken = getStringAsync(AppConstant.TOKEN_KEY);
  if (accessToken.isNotEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await MessagingService().initNotification();
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: MultiBlocProvider(providers: [
      //   BlocProvider<UserCubit>(create: (context) => UserCubit()..getUserProfile()),
      //   BlocProvider(create: (context) => ArchivementCubit()..getArchivements()),
      //   // BlocProvider<GroupCubit>(
      //   //   create: (context) => GroupCubit(),
      //   // )
      // ], child: MultiBlocListener(listeners: [BlocListener<UserCubit, UserState>(listener: (context, state) {})], child: _fetchAuthAndInitialRoute())),
      // home: _fetchAuthAndInitialRoute(),
      home: MultiBlocProvider(providers: [BlocProvider<NotificationCubit>(create: (context) => NotificationCubit())], child: DashboardScreen()),
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false, // Remove debug banner
      onGenerateRoute: generateRoute,
    );
  }
}

Widget _fetchAuthAndInitialRoute() {
  // Check if logged in
  try {
    var accessToken = getStringAsync(AppConstant.TOKEN_KEY);
    if (accessToken.isNotEmpty) {
      return const DashboardScreen();
    }
  } catch (e) {
    debugPrint("ex ${e.toString()}"); // Print exception
  }
  return const SplashScreen();
}

class CameraService {
  static final CameraService _instance = CameraService._internal();

  factory CameraService() => _instance;

  CameraService._internal();

  List<CameraDescription>? cameras;

  Future<void> initializeCameras() async {
    cameras = await availableCameras();
  }
}
