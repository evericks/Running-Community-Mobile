import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class GroupFragment extends StatelessWidget {
  const GroupFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Group',
      ),
      body: const Center(
        child: Text('Group Fragment'),
      ),
    );
  }
}