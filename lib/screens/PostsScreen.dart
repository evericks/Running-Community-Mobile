import 'package:flutter/material.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, required this.groupId});
  static const String routeName = '/posts';
  final String groupId;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Posts',
      ),
      body: Container(
        child: Center(
          child: Text('Posts'),
        ),
      ),
    );
  }
}