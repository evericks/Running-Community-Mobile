import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class SearchFragment extends StatelessWidget {
  const SearchFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Search'),
      body: Center(
        child: Text('Search Fragment'),
      ),
    );
  }
}