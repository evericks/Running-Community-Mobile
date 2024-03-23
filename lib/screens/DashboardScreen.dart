import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/fragments/PersonalTrainingFragment.dart';
import 'package:running_community_mobile/fragments/SearchFragment.dart';
import 'package:running_community_mobile/fragments/TournamentFragment.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../fragments/GroupFragment.dart';
import '../fragments/ProfileFragment.dart';
import '../utils/constants.dart';

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
    const SearchFragment(),
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
        onPressed: () {onTabSelection(2);},
        child: SvgPicture.asset(AppAssets.run, height: 24, color: white),
        backgroundColor: primaryColor,
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
              IconButton(onPressed: (){onTabSelection(0);}, icon: SvgPicture.asset(AppAssets.globe, height: 24, color: primaryColor,)),
              IconButton(onPressed: (){onTabSelection(1);}, icon: SvgPicture.asset(AppAssets.group, height: 24, color: primaryColor,)),
              const SizedBox(width: 24,),
              IconButton(onPressed: (){onTabSelection(3);}, icon: SvgPicture.asset(AppAssets.award, height: 24, color: primaryColor,)),
              IconButton(onPressed: (){onTabSelection(4);}, icon: SvgPicture.asset(AppAssets.user, height: 24, color: primaryColor,)),],
          ),),
        ),
      ),
      body: _fragments.elementAt(selectedIndex),
    );
  }
}