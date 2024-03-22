import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';
import '../widgets/Button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const MyAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: context.height() * 0.3,
              child: Image.asset(
                AppAssets.login_background,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), color: primaryColor.withOpacity(0.1)),
              child: Column(
                children: [
                  const Center(
                      child: SizedBox(
                          width: 150,
                          child: Text(
                            'Sign Up',
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
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
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
                        hintText: 'Email',
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
                        hintText: 'Phone number',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ).paddingOnly(left: 16),
                  ),
                  Gap.k16.height,
                  Button(title: 'Sign Up', onPressed: (){
                    Navigator.pushNamed(context, '/login');
                  }).paddingSymmetric(horizontal: 32),
                  Gap.k16.height,
                  const Text('Already has an account?').onTap(() {
                    Navigator.pushNamed(context, '/login');
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