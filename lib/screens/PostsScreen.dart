import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/screens/GroupDetailScreen.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: textPrimaryColor,),
            onPressed: () {
              Navigator.pushNamed(context, GroupDetailScreen.routeName, arguments: widget.groupId);
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Text('Posts'),
        ),
      ),
    );
  }
}