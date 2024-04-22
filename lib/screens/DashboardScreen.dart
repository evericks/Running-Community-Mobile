import 'dart:async';

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
import '../widgets/MyNotchRectangle.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.tabIndex});
  static const String routeName = '/dashboard';
  final int? tabIndex;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    if (widget.tabIndex != null) {
      selectedIndex = widget.tabIndex!;
    }
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Độ dài của mỗi hiệu ứng nháy
    );

    _animation = Tween(begin: 0.0, end: 8.0).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });

    // Tạo một Timer để trigger animation mỗi giây
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      extendBody: true,
      floatingActionButton: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 60 + _animation.value, height: 60 + _animation.value, decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor.withOpacity(_animation.value / 100)),),
                FloatingActionButton(
                  shape: const CircleBorder(),
                  isExtended: true,
                  onPressed: () {
                    onTabSelection(2);
                  },
                  backgroundColor: selectedIndex == 2 ? primaryColor : primaryColor.withOpacity(0.2),
                  elevation: 0,
                  child: SvgPicture.asset(AppAssets.run, height: 24, color: selectedIndex == 2 ? white : primaryColor),
                ),
              ],
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomAppBar(
          elevation: 0,
          notchMargin: 8.0,
          clipBehavior: Clip.antiAlias,
          shape: MyNotchedRectangle(),
          color: white,
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
                    color: selectedIndex == 0 ? primaryColor : gray.withOpacity(0.7),
                  )),
              IconButton(
                  onPressed: () {
                    onTabSelection(1);
                  },
                  icon: SvgPicture.asset(
                    AppAssets.group,
                    height: 24,
                    color: selectedIndex == 1 ? primaryColor : gray.withOpacity(0.7),
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
                    color: selectedIndex == 3 ? primaryColor : gray.withOpacity(0.7),
                  )),
              IconButton(
                  onPressed: () {
                    onTabSelection(4);
                  },
                  icon: SvgPicture.asset(
                    AppAssets.user,
                    height: 24,
                    color: selectedIndex == 4 ? primaryColor : gray.withOpacity(0.7),
                  )),
            ],
          ),
        ),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider<UserCubit>(create: (context) => UserCubit()..getUserProfile()),
            BlocProvider<ArchivementCubit>(create: (context) => ArchivementCubit()..getArchivements(pageSize: 100)),
            BlocProvider<GroupCubit>(
              create: (context) => GroupCubit()..getGroups(pageSize: 100),
            )
          ],
          child: MultiBlocListener(
              listeners: [BlocListener<UserCubit, UserState>(listener: (context, state) {}), BlocListener<GroupCubit, GroupState>(listener: (context, state) {})],
              child: _fragments.elementAt(selectedIndex))),
    );
  }
}
