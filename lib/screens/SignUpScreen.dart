import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';

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
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  DateTime? selectedDate;

  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const MyAppBar(title: 'Sign Up'),
      body: BlocProvider<UserCubit>(
        create: (context) => UserCubit(),
        child: BlocConsumer<UserCubit, UserState>(listener: (context, state) {
          if (state is SignUpLoadingState) {
            showLoader(context);
          } else if (state is SignUpSuccessState) {
            hideLoader(context);
            Fluttertoast.showToast(msg: 'Sign up successfully');
            Navigator.pop(context);
          } else if (state is SignUpFailedState) {
            hideLoader(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error.replaceAll('Exception: ', '')),
              backgroundColor: tomato,
            ));
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            reverse: true,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: context.height() * 0.2,
                  child: Image.asset(
                    AppAssets.login_background,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
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
                        child: TextField(
                          controller: phoneController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                              hintText: 'Phone number (*)',
                              // contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              hintStyle: secondaryTextStyle()),
                        ).paddingOnly(left: 16),
                      ),
                      Gap.k16.height,
                      Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: nameController,
                          onChanged: (value) => setState(() {}),
                          decoration: InputDecoration(
                              hintText: 'Name (*)',
                              // contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              hintStyle: secondaryTextStyle()),
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
                          onChanged: (value) => setState(() {}),
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Password (*)',
                              // contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              hintStyle: secondaryTextStyle()),
                        ).paddingOnly(left: 16),
                      ),
                      Gap.k16.height,
                      Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: confirmPasswordController,
                          onChanged: (value) => setState(() {}),
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: 'Confirm password (*)',
                              // contentPadding: const EdgeInsets.all(16),
                              border: InputBorder.none,
                              hintStyle: secondaryTextStyle()),
                        ).paddingOnly(left: 16),
                      ),
                      Gap.k16.height,
                      Container(
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Text(selectedDate != null ? DateFormat('dd/MM/yyyy').format(selectedDate!) : 'Date of birth (*)', style: secondaryTextStyle()).paddingOnly(left: 16),
                            const Spacer(),
                            SvgPicture.asset(
                              AppAssets.calendar,
                              width: 24,
                              height: 24,
                              color: gray,
                            ).paddingOnly(right: 16),
                          ],
                        ),
                      ).onTap(() {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ).then((value) => setState(() {
                              selectedDate = value;
                            }));
                      }),
                      Gap.k8.height,
                      const Text('(*) Required field', style: TextStyle(color: gray, fontSize: 12)),
                      Gap.k16.height,
                      Button(
                          title: 'Sign Up',
                          isActive:
                              (phoneController.text.isNotEmpty && nameController.text.isNotEmpty && passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty && selectedDate != null) ? true : false,
                          onPressed: () {
                            if (phoneController.text.isNotEmpty && nameController.text.isNotEmpty && passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty && selectedDate != null) {
                              if (passwordController.text == confirmPasswordController.text) {
                                context.read<UserCubit>().signUp(
                                      phone: phoneController.text,
                                      name: nameController.text,
                                      password: passwordController.text,
                                      dob: selectedDate!,
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password does not match')));
                              }
                            }
                          }).paddingSymmetric(horizontal: 32),
                      Gap.k16.height,
                      const Text('Already has an account?').onTap(() {
                        Navigator.pushNamed(context, '/login');
                      }),
                    ],
                  ).paddingOnly(left: 32, right: 32, top: 32),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
