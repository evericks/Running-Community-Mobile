import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class PersonalTrainingFragment extends StatelessWidget {
  const PersonalTrainingFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Personal Training'),
      body: Center(
        child: Text('Personal Training Fragment'),
      ),
    );
  }
}