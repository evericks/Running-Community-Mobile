import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/group/group_state.dart';
import '../cubit/archivement/archivement_cubit.dart';
import '../cubit/group/group_cubit.dart';
import '../cubit/user/user_cubit.dart';
import '../cubit/user/user_state.dart';
import '../fragments/GroupFragment.dart';
import '../fragments/PersonalTrainingFragment.dart';
import '../fragments/ProfileFragment.dart';
import '../fragments/HomeFragment.dart';
import '../fragments/TournamentFragment.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.tabIndex});
  static const String routeName = '/dashboard';
  final int? tabIndex;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    if (widget.tabIndex != null) {
      selectedIndex = widget.tabIndex!;
    }
    super.initState();
  }

  void onTabSelection(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _fragments = [
    const HomeFragment(),
    const GroupFragment(),
    const PersonalTrainingFragment(),
    const TournamentFragment(),
    const ProfileFragment(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          onTabSelection(2);
        },
        backgroundColor: selectedIndex == 2 ? primaryColor : primaryColor.withOpacity(0.2),
        elevation: 0,
        child: SvgPicture.asset(AppAssets.run, height: 24, color: selectedIndex == 2 ? white : primaryColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Container(
          decoration: BoxDecoration(color: white.withOpacity(0.8)),
          child: BottomAppBar(
            notchMargin: 10.0,
            clipBehavior: Clip.antiAlias,
            shape: const CircularNotchedRectangle(),
            color: primaryColor.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      onTabSelection(0);
                    },
                    icon: SvgPicture.asset(
                      AppAssets.globe,
                      height: 24,
                      color: selectedIndex == 0 ? primaryColor : gray,
                    )),
                IconButton(
                    onPressed: () {
                      onTabSelection(1);
                    },
                    icon: SvgPicture.asset(
                      AppAssets.group,
                      height: 24,
                      color: selectedIndex == 1 ? primaryColor : gray,
                    )),
                const SizedBox(
                  width: 24,
                ),
                IconButton(
                    onPressed: () {
                      onTabSelection(3);
                    },
                    icon: SvgPicture.asset(
                      AppAssets.award,
                      height: 24,
                      color: selectedIndex == 3 ? primaryColor : gray,
                    )),
                IconButton(
                    onPressed: () {
                      onTabSelection(4);
                    },
                    icon: SvgPicture.asset(
                      AppAssets.user,
                      height: 24, 
                      color: selectedIndex == 4 ? primaryColor : gray,
                    )),
              ],
            ),
          ),
        ),
      ),
      body: MultiBlocProvider(providers: [
        BlocProvider<UserCubit>(create: (context) => UserCubit()..getUserProfile()),
        BlocProvider<ArchivementCubit>(create: (context) => ArchivementCubit()..getArchivements()),
        BlocProvider<GroupCubit>(
          create: (context) => GroupCubit()..getGroups(),
        )
      ], child: MultiBlocListener(listeners: [BlocListener<UserCubit, UserState>(listener: (context, state) {}), BlocListener<GroupCubit, GroupState>(listener: (context, state){})], child: _fragments.elementAt(selectedIndex))),
    );
  }
}
