import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
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
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: groups.length,
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
                                Text(
                                  groups[index].description!,
                                  style: secondaryTextStyle(),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 8, vertical: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 32, vertical: 16);
          }
          return const SizedBox();
        }),
      ),
    );
  }
}
