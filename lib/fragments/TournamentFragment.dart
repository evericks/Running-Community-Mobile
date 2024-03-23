import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class TournamentFragment extends StatelessWidget {
  const TournamentFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Tournament'),
      body: Center(
        child: Text('Tournament Fragment'),
      ),
    );
  }
}