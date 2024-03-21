import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'screens/DashboardScreen.dart';
import 'screens/SplashScreen.dart';
import 'utils/constants.dart';
import 'utils/get_it.dart';
import 'utils/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await initialGetIt();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _fetchAuthAndInitialRoute(),
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
      return DashboardScreen();
    }
  } catch (e) {
    debugPrint("ex ${e.toString()}"); // Print exception 
  }
    return const SplashScreen();
}

