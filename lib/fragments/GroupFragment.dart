import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/GroupsComponent.dart';
import '../cubit/group/group_cubit.dart';
import '../cubit/group/group_state.dart';
import '../domain/repositories/user_repo.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';

class GroupFragment extends StatelessWidget {
  const GroupFragment({super.key});

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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: blueColor),
                      ),
                      child: Text(
                        'Join',
                        style: primaryTextStyle(
                          color: blueColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ).expand(),
                  ],
                ),
                Gap.k16.height,
                Text('Joined Groups (${joinedGroups.length})', style: secondaryTextStyle()),
                Gap.k8.height,
                GroupsList(groups: joinedGroups),
                Gap.k16.height,
                Text('Suggestion for you', style: secondaryTextStyle()),
                Gap.k8.height,
                GroupsList(groups: groups.where((gr) => !joinedGroups.contains(gr)).toList()),
              ],
            ).paddingSymmetric(horizontal: 16),
          );
        }
        return const SizedBox();
      }),
    );
  }
}

