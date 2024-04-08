import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Home'),
      body: Center(child: Text('Home Fragment'),),
    );
  }
}
