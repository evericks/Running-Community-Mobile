import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  static const String routeName = '/create-post';

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Create Post',
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Post', style: boldTextStyle(color: white),),
          ),
          Gap.k16.width,
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: FadeInImage.assetNetwork(placeholder: AppAssets.user_placeholder, image: UserRepo.user.avatarUrl!, width: 40, height: 40, fit: BoxFit.cover,),
              ),
              Gap.k16.width,
              Text(UserRepo.user.name!, style: boldTextStyle(size: 16)),
            ],
          ),
          Gap.kSection.height,
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Write something here...',
              hintStyle: secondaryTextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: gray.withOpacity(0.1),
              contentPadding: EdgeInsets.all(16),
            ),
            maxLines: 7,
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 16),
    );
  }
}