import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domain/models/groups.dart';
import '../domain/repositories/user_repo.dart';
import '../screens/GroupDetailScreen.dart';
import '../screens/PostsScreen.dart';
import '../utils/app_assets.dart';
import '../utils/gap.dart';

class GroupsList extends StatelessWidget {
  const GroupsList({
    super.key,
    required this.groups,
  });

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groups.length,
      separatorBuilder: (context, index) => Gap.k16.height,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 3))],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  child: FadeInImage.assetNetwork(placeholder: AppAssets.placeholder, image: groups[index].thumbnailUrl!, width: 80, height: 80, fit: BoxFit.cover),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groups[index].name!,
                      style: primaryTextStyle(),
                    ),
                    SizedBox(
                      width: context.width() * 0.6,
                      child: Text(
                        groups[index].description!,
                        style: secondaryTextStyle(),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 8, vertical: 8),
              ],
            ),
          ),
        ).onTap(() {
          Navigator.pushNamed(context, groups[index].groupMembers!.any((mem) => mem.user!.id == UserRepo.user.id) ? PostsScreen.routeName : GroupDetailScreen.routeName, arguments: groups[index].id);
          // Navigator.pushNamed(context, GroupDetailScreen.routeName, arguments: groups[index].id);
        });
      },
    );
  }
}
