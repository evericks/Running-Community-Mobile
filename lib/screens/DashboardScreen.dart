import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../utils/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = '/dashboard';
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        // automaticallyImplyLeading: false,
        title: 'Dashboard',
        
      ),
      body: Center(
        child: TextButton(onPressed: () async {
          await setValue(AppConstant.TOKEN_KEY, '');
        },
        child: Text('Logout'),),
      ),
    );
  }
}