import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';
import '../widgets/Button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 150, child: Text('RUNNING COMMUNITY', style: TextStyle(color: primaryColor, fontSize: 24), textAlign: TextAlign.center,)),
          Image.asset(AppAssets.login_background),
          Gap.kSection.height,
          Center(
            child: Button(title: ' Log In', onPressed: () {
              Navigator.pushNamed(context, '/login');
            }),
          ),
          Gap.k16.height,
          Text('SIGN UP', style: TextStyle(color: textSecondaryColor),).onTap(() {
            Navigator.pushNamed(context, '/signup');
          }),
        ],
      ),);
  }
}

