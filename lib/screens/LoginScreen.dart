import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';
import 'package:running_community_mobile/screens/DashboardScreen.dart';
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
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const MyAppBar(title: 'Login'),
      body: BlocProvider<UserCubit>(
        create: (context) => UserCubit(),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
            } else if (state is LoginFailedState) {
              // Fluttertoast.showToast(msg: state.error.substring(state.error.indexOf(': ') + 2));
              Fluttertoast.showToast(msg: state.error.replaceAll('Exception: ', ''));
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(state.error.replaceAll('Exception. ', '')),
              //   backgroundColor: Colors.red,
              // ));
            }
          
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
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
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
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
                          context.read<UserCubit>().login(username: usernameController.text, password: passwordController.text);
                        }).paddingSymmetric(horizontal: 32),
                        Gap.k16.height,
                        const Text('Don\'t have an account?').onTap(() {
                          Navigator.pushNamed(context, '/signup');
                        }),
                      ],
                    ).paddingSymmetric(horizontal: 32, vertical: 32),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
