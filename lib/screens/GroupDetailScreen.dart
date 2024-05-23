import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/group/group_cubit.dart';
import 'package:running_community_mobile/cubit/group/group_state.dart';
import 'package:running_community_mobile/domain/models/groups.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/screens/PostsScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';
import 'package:running_community_mobile/utils/constants.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key, required this.id});
  static const String routeName = '/group-detail';
  final String id;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: 'Group Info',
        ),
        body: SafeArea(
          child: BlocProvider<GroupCubit>(
            create: (context) => GroupCubit()..getGroupById(widget.id),
            child: BlocConsumer<GroupCubit, GroupState>(
              listener: (context, state) {
                if (state is JoinGroupLoadingState) {
                  showLoader(context);
                }
                if (state is JoinGroupSuccessState) {
                  hideLoader(context);
                  Fluttertoast.showToast(msg: 'Your request has been sent to the group owner. Please wait for approval.');
                  // context.read<GroupCubit>().getGroupById(widget.id);
                  Navigator.pushReplacementNamed(context, PostsScreen.routeName, arguments: widget.id);
                }
                if (state is JoinGroupFailedState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error.replaceAll('Exception: ', '')),
                    backgroundColor: tomato,
                  ));
                  hideLoader(context);
                  // Navigator.pop(context);
                  context.read<GroupCubit>().getGroupById(widget.id);
                }
              },
              builder: (context, state) => BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
                if (state is GetGroupLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetGroupSuccessState) {
                  var group = state.group;
                  group.groupMembers!.sort((a, b) {
                    // Đầu tiên sắp xếp theo vai trò
                    int roleComparison = b.role!.compareTo(a.role!);
                    if (roleComparison != 0) {
                      return roleComparison;
                    }

                    // Nếu vai trò giống nhau, sắp xếp theo trạng thái
                    const statusOrder = {'Requested': 1, 'Active': 2, 'Rejected': 3};
                    return statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
                  });
                  bool isUserOwner = UserRepo.user.id == group.groupMembers!.firstWhere((mem) => mem.role == 'Owner').user!.id;
                  bool isUserInGroup = group.groupMembers!.any((mem) => mem.user!.id == UserRepo.user.id);
                  bool isActive = isUserInGroup && group.groupMembers!.firstWhere((mem) => mem.user!.id == UserRepo.user.id).status == 'Active';
                  bool isRequested = isUserInGroup && group.groupMembers!.firstWhere((mem) => mem.user!.id == UserRepo.user.id).status == 'Requested';
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 170,
                          child: Stack(
                            children: [
                              // Positioned(top: 16, left: 16, child: Icon(Icons.arrow_back, color: textPrimaryColor, size: 20,),),
                              Positioned(
                                child: Image.asset(
                                  AppAssets.cover,
                                  height: 120,
                                  width: context.width(),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Positioned(
                                top: 70,
                                left: 16,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: FadeInImage.assetNetwork(placeholder: AppAssets.placeholder, image: group.thumbnailUrl!, height: 100, width: 100, fit: BoxFit.cover)),
                              ),
                              if (isUserOwner) ...[
                                const SizedBox.shrink()
                              ] else if (isUserInGroup) ...[
                                Positioned(
                                  right: 16,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: gray),
                                      color: isActive || isRequested ? white : primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isActive
                                          ? 'Out'
                                          : isRequested
                                              ? 'Requested'
                                              : 'Join',
                                      style: boldTextStyle(color: isActive || isRequested ? grey : white),
                                    ),
                                  ).onTap(() {
                                    if (!isUserInGroup) {
                                      context.read<GroupCubit>().joinGroup(userId: UserRepo.user.id!, groupId: group.id!);
                                    }
                                  }),
                                )
                              ] else ...[
                                Positioned(
                                  right: 16,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor),
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Join',
                                      style: boldTextStyle(color: white),
                                    ),
                                  ).onTap(() {
                                    if (getStringAsync(AppConstant.TOKEN_KEY) == '') {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text('Please login to join the tournament'),
                                        backgroundColor: tomato,
                                      ));
                                    } else {
                                      context.read<GroupCubit>().joinGroup(userId: UserRepo.user.id!, groupId: group.id!);
                                    }
                                  }),
                                )
                              ]
                            ],
                          ),
                        ),
                        Gap.kSection.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name!,
                              style: boldTextStyle(size: 24),
                            ),
                            Gap.k8.height,
                            Text(
                              group.description!,
                              style: primaryTextStyle(size: 16),
                            ),
                            Gap.k16.height,
                            Text('Rule', style: boldTextStyle(size: 16)),
                            Gap.k8.height,
                            Row(
                              children: [
                                Text(
                                  'Age from ${group.minAge}',
                                  style: secondaryTextStyle(size: 14),
                                ).visible(group.minAge != null),
                                Text(" - ${group.maxAge}", style: secondaryTextStyle(size: 14)).visible(group.maxAge != null),
                                Gap.k16.width,
                                Text('Gender: ${group.gender}', style: secondaryTextStyle(size: 14)).visible(group.gender != null),
                              ],
                            ),
                            Gap.k16.height,
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(text: 'Members', style: secondaryTextStyle(size: 14)),
                                        TextSpan(text: '  ${group.groupMembers!.length}', style: boldTextStyle(size: 14)),
                                      ])),
                                ).expand(),
                                Gap.k16.width,
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: [
                                        TextSpan(text: 'Leader', style: secondaryTextStyle(size: 14)),
                                        TextSpan(text: '  ${group.groupMembers!.firstWhere((mem) => mem.role == 'Owner').user!.name}', style: boldTextStyle(size: 14)),
                                      ])),
                                ).expand()
                              ],
                            ),
                            Gap.kSection.height,
                            isUserInGroup && isActive
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => MemberWidget(member: group.groupMembers![index]),
                                    separatorBuilder: (context, index) => const Divider(),
                                    itemCount: group.groupMembers!.length)
                                : Text('You are not a member of this group. Please join to see the members list.', style: primaryTextStyle(size: 16))
                          ],
                        ).paddingSymmetric(horizontal: 16)
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
        ));
  }
}

class MemberWidget extends StatefulWidget {
  const MemberWidget({
    super.key,
    required this.member,
  });

  final GroupMembers member;

  @override
  State<MemberWidget> createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: widget.member.user!.avatarUrl == null
              ? Image.asset(AppAssets.user_placeholder, height: 40, width: 40, fit: BoxFit.cover)
              : FadeInImage.assetNetwork(placeholder: AppAssets.user_placeholder, image: widget.member.user!.avatarUrl!, height: 40, width: 40, fit: BoxFit.cover),
        ),
        Gap.k8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.member.user!.name!,
              style: boldTextStyle(size: 16),
            ),
            Text(
              widget.member.role!,
              style: secondaryTextStyle(size: 14),
            ),
          ],
        ).expand(),
        if (widget.member.status == 'Requested') ...[
          BlocProvider<GroupCubit>(
            create: (context) => GroupCubit(),
            child: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
              if (state is JoinRequestProcessLoadingState) {
                return const CircularProgressIndicator();
              }
              if (state is JoinRequestProcessSuccessState) {
                if (isActive) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: forestGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Active',
                      style: boldTextStyle(color: forestGreen, size: 14),
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rejected',
                      style: boldTextStyle(color: grey, size: 14),
                    ),
                  );
                }
              }
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Accept',
                      style: boldTextStyle(color: white, size: 14),
                    ),
                  ).onTap(() {
                    context.read<GroupCubit>().joinRequestProcess(memId: widget.member.id!, status: 'Active');
                    setState(() {
                      isActive = true;
                    });
                  }),
                  Gap.k8.width,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tomato.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Reject',
                      style: boldTextStyle(color: tomato, size: 14),
                    ),
                  ).onTap(() {
                    context.read<GroupCubit>().joinRequestProcess(memId: widget.member.id!, status: 'Rejected');
                  }),
                ],
              );
            }),
          ),
        ] else if (widget.member.status == 'Active') ...[
          if (widget.member.role != 'Owner')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: forestGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Active',
                style: boldTextStyle(color: forestGreen, size: 14),
              ),
            )
          else
            const SizedBox.shrink()
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Rejected',
              style: boldTextStyle(color: grey, size: 14),
            ),
          ),
        ]
      ],
    );
  }
}
