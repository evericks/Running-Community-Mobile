import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../utils/constants.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment>{
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      super.dispose();
    }

    List<Widget> _widgetOptions = <Widget>[
      Text('Index 0: Information'),
      Text('Index 1: Archivement'),
    ];

    return Scaffold(
      appBar: MyAppBar(
        title: 'Profile',
      ),
      body: BlocProvider<UserCubit>(
        create: (context) => UserCubit()..getUserProfile(),
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if (state is UserProfileLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserProfileSuccessState) {
            var userProfile = state.user;
            return Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                          placeholder: AppAssets.placeholder,
                          image: state.user.avatarUrl!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap.k16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userProfile.phone!, style: primaryTextStyle(weight: FontWeight.bold),),
                          Text(userProfile.status!, style: secondaryTextStyle(),),
                        ],
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 32),
                Gap.k16.height,
                SizedBox(
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        // top: 100,
                        child: Card(
                          elevation: _selectedIndex == 0 ? 0 : 10,
                          child: Container(
                            // width: context.width() * 0.2,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            child: SvgPicture.asset(AppAssets.info, width: 24, color: _selectedIndex == 0 ? primaryColor : textSecondaryColor,),
                          ),
                        ).onTap(() => setState(() => _selectedIndex = 0)),
                      ),
                      Positioned(
                        left: 90,
                        child: Card(
                          elevation: _selectedIndex == 1 ? 0 : 10,
                          child: Container(
                            // width: context.width() * 0.2,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            child: SvgPicture.asset(AppAssets.trophy, width: 24, color: _selectedIndex == 1 ? primaryColor : textSecondaryColor,),
                          ),
                        ).onTap(() => setState(() => _selectedIndex = 1),)
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 32),
                Container(
                  color: white,
                  width: context.width(),
                  height: 200,
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),  
                
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await setValue(AppConstant.TOKEN_KEY, '');
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 32);
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
