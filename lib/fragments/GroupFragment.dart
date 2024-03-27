import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/domain/models/groups.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import '../cubit/group/group_cubit.dart';
import '../cubit/group/group_state.dart';
import '../utils/app_assets.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';

class GroupFragment extends StatelessWidget {
  const GroupFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Group',
      ),
      body: BlocProvider<GroupCubit>(
        create: (context) => GroupCubit()..getGroups(),
        child: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
          if (state is GroupsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GroupsSuccessState) {
            var groups = state.groups.groups!;
            var joinedGroups = groups.where((gr) => gr.groupMembers!.any((mem) => mem.user!.id == UserRepo.user.id)).toList();
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GroupCubit>().getGroups();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: blueColor),
                        ),
                        child: Text(
                          'New Group',
                          style: primaryTextStyle(color: blueColor),
                          textAlign: TextAlign.center,
                        ),
                      ).onTap(() {
                        Navigator.pushNamed(context, '/create-group');
                      }).expand(),
                      Gap.k16.width,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: blueColor),
                        ),
                        child: Text(
                          'Join',
                          style: primaryTextStyle(color: blueColor,),
                          textAlign: TextAlign.center,
                        ),
                      ).expand(),
                    ],
                  ),
                  Gap.k16.height,
                  Text('Joined Groups', style: secondaryTextStyle()),
                  Gap.k8.height,
                  GroupsList(groups: joinedGroups),
                  Gap.k16.height,
                  Text('Suggestion for you', style: secondaryTextStyle()),
                  Gap.k8.height,
                  GroupsList(groups: groups.where((gr) => !joinedGroups.contains(gr)).toList()),
                ],
              ).paddingSymmetric(horizontal: 32, vertical: 16),
            );
          }
          return const SizedBox();
        }),
      ),
    );
  }
}

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
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 3))],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
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
        );
      },
    );
  }
}
