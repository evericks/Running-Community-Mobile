import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/group/group_cubit.dart';
import 'package:running_community_mobile/cubit/group/group_state.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key, required this.id});
  static const String routeName = '/group-detail';
  final String id;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(
          title: 'Group Info',
        ),
        body: SafeArea(
          child: BlocProvider<GroupCubit>(
            create: (context) => GroupCubit()..getGroupById(widget.id),
            child: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
              if (state is GetGroupLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetGroupSuccessState) {
                var group = state.group;
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
                            UserRepo.user.id == group.groupMembers!.firstWhere((mem) => mem.role == 'Owner').user!.id ? const SizedBox.shrink() : Positioned(
                              right: 16,
                              bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                              child: Text('Join', style: boldTextStyle(color: white),),
                            )),
                          ],
                        ),
                      ),
                      Gap.kSection.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(group.name!, style: boldTextStyle(size: 24),),
                          Gap.k8.height,
                          Text(group.description!, style: primaryTextStyle(size: 16),),
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
                                  text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Members', style: secondaryTextStyle(size: 14)),
                                    TextSpan(text: '  ${group.groupMembers!.length}', style: boldTextStyle(size: 16)),
                                  ]
                                )),
                              ).expand(),
                              Gap.k16.width,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                  children: [
                                    TextSpan(text: 'Leader', style: secondaryTextStyle(size: 14)),
                                    TextSpan(text: '  ${group.groupMembers!.firstWhere((mem) => mem.role == 'Owner').user!.name}', style: boldTextStyle(size: 16)),
                                  ]
                                )),
                              ).expand()
                            ],
                          ),
                          Gap.kSection.height,
                          ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Row(children: [
                            ClipOval(
                              child: FadeInImage.assetNetwork(placeholder: AppAssets.placeholder, image: group.groupMembers![index].user!.avatarUrl!, height: 40, width: 40, fit: BoxFit.cover),
                            ),
                            Gap.k8.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(group.groupMembers![index].user!.name!, style: boldTextStyle(size: 16),),
                                Text(group.groupMembers![index].role!, style: secondaryTextStyle(size: 14),),
                              ],
                            ).expand()
                          
                          ],), separatorBuilder:  (context, index) => const Divider(), itemCount: group.groupMembers!.length)
                        ],
                      ).paddingSymmetric(horizontal: 16)
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ));
  }
}
