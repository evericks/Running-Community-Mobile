import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';

import 'cubit/archivement/archivement_cubit.dart';
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
      home: MultiBlocProvider(
          providers: [BlocProvider<UserCubit>(create: (context) => UserCubit()..getUserProfile()), BlocProvider(create: (context) => ArchivementCubit()..getArchivements())],
          child: MultiBlocListener(listeners: [BlocListener<UserCubit, UserState>(listener: (context, state){})], child: _fetchAuthAndInitialRoute())),
      theme: ThemeData(fontFamily: 'Roboto', scaffoldBackgroundColor: white.withOpacity(0.8)),
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
