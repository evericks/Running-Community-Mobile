import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/constants.dart';
import '../components/GroupsComponent.dart';
import '../cubit/group/group_cubit.dart';
import '../cubit/group/group_state.dart';
import '../domain/repositories/user_repo.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';

class GroupFragment extends StatefulWidget {
  const GroupFragment({super.key});

  @override
  State<GroupFragment> createState() => _GroupFragmentState();
}

class _GroupFragmentState extends State<GroupFragment> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Group',
      ),
      body: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
        if (state is GroupsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GroupsSuccessState) {
          var groups = state.groups.groups!.where((gr) => gr.name!.toLowerCase().contains(searchController.text.toLowerCase()));
          var joinedGroups = groups
              .where((gr) => gr.groupMembers!.any((mem) =>
                  mem.user!.id == UserRepo.user.id && (mem.role != 'Owner')))
              .toList();
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GroupCubit>().getGroups(pageSize: 100);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: white,
                        boxShadow: defaultBoxShadow()),
                    child: TextField(
                      onChanged: (value) => setState(() {}),
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search group',
                        prefixIcon: Transform.scale(
                          scale: 0.4,
                          child: SvgPicture.asset(AppAssets.magnifying_glass,
                              color: gray, height: 16),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Gap.k16.height,
                  if (getStringAsync(AppConstant.TOKEN_KEY) != '') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: blueColor),
                          ),
                          child: Text(
                            '+ New Group',
                            style: primaryTextStyle(color: blueColor),
                            textAlign: TextAlign.center,
                          ),
                        ).onTap(() {
                          Navigator.pushNamed(context, '/create-group');
                        }).expand(),
                        // Gap.k16.width,
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(8),
                        //     border: Border.all(color: blueColor),
                        //   ),
                        //   child: Text(
                        //     'Join',
                        //     style: primaryTextStyle(
                        //       color: blueColor,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ).expand(),
                      ],
                    ),
                    Gap.k16.height,
                  ],
                  Text(
                      'Your Groups (${groups.where((gr) => gr.groupMembers!.any((mem) => mem.role == 'Owner' && mem.user!.id == UserRepo.user.id)).length})',
                      style: secondaryTextStyle()),
                  Gap.k8.height,
                  GroupsList(
                      groups: groups
                          .where((gr) => gr.groupMembers!.any((mem) =>
                              mem.role == 'Owner' &&
                              mem.user!.id == UserRepo.user.id))
                          .toList()),
                  Gap.k16.height,
                  Text('Joined Groups (${joinedGroups.length})',
                      style: secondaryTextStyle()),
                  Gap.k8.height,
                  GroupsList(groups: joinedGroups),
                  Gap.k16.height,
                  Text('Suggestion for you', style: secondaryTextStyle()),
                  Gap.k8.height,
                  GroupsList(
                      groups: groups
                          .where((gr) =>
                              !joinedGroups.contains(gr) &&
                              !groups
                                  .where((gr) => gr.groupMembers!.any((mem) =>
                                      mem.role == 'Owner' &&
                                      mem.user!.id == UserRepo.user.id))
                                  .contains(gr))
                          .toList()),
                  Gap.kSection.height,
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          );
        }
        return const SizedBox();
      }),
    );
  }
}
