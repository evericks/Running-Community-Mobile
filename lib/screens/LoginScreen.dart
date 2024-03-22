import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';
import 'package:running_community_mobile/widgets/Button.dart';

import '../utils/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const MyAppBar(title: 'Login'),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: context.height() * 0.4,
              child: Image.asset(
                AppAssets.login_background,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: primaryColor.withOpacity(0.1)),
              child: Column(
                children: [
                  const Center(
                      child: SizedBox(
                          width: 150,
                          child: Text(
                            'Log In',
                            style: TextStyle(color: primaryColor, fontSize: 30),
                            textAlign: TextAlign.center,
                          ))),
                  Gap.k16.height,
                  Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Username',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ).paddingOnly(left: 16),
                  ),
                  Gap.k16.height,
                  Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ).paddingOnly(left: 16),
                  ),
                  Gap.k16.height,
                  const Text('Forgot Password?', style: TextStyle(color: textSecondaryColor))..onTap(() {
                    Navigator.pushNamed(context, '/signup');
                  }),
                  Gap.k16.height,
                  Button(title: 'Log In', onPressed: (){
                    Navigator.pushNamed(context, '/dashboard');
                  }).paddingSymmetric(horizontal: 32),
                  Gap.k16.height,
                  const Text('Don\'t have an account?')..onTap(() {
                    Navigator.pushNamed(context, '/signup');
                  }),
                ],
              ).paddingSymmetric(horizontal: 32, vertical: 32),
            ),
          ],
        ),
      ),
    );
  }
}
