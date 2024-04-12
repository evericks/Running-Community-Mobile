import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/archivement/archivement_state.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_cubit.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_state.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';
import 'package:running_community_mobile/screens/DashboardScreen.dart';
import 'package:running_community_mobile/screens/LoginScreen.dart';
import 'package:running_community_mobile/screens/SeeAllTournamentScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/archivement/archivement_cubit.dart';
import '../utils/constants.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
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

    return Scaffold(
      appBar: const MyAppBar(
        title: 'Profile',
      ),
      body: getStringAsync(AppConstant.TOKEN_KEY).isNotEmpty
          ? BlocBuilder<UserCubit, UserState>(builder: (context, state) {
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
                            child: state.user.avatarUrl != null
                                ? FadeInImage.assetNetwork(
                                    placeholder: AppAssets.placeholder,
                                    image: state.user.avatarUrl!,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    AppAssets.user_placeholder,
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Gap.k16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProfile.name!,
                                style: primaryTextStyle(weight: FontWeight.bold),
                              ),
                              Text(
                                userProfile.status!,
                                style: secondaryTextStyle(),
                              ),
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // width: context.width() * 0.2,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                decoration: BoxDecoration(
                                  color: _selectedIndex == 0 ? white : context.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    )
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  AppAssets.info,
                                  width: 24,
                                  color: _selectedIndex == 0 ? primaryColor : textSecondaryColor,
                                ),
                              ).onTap(() => setState(() => _selectedIndex = 0)),
                            ),
                          ),
                          Positioned(
                              left: 90,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                  color: _selectedIndex == 1 ? white : context.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    )
                                  ],
                                ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  child: SvgPicture.asset(
                                    AppAssets.trophy,
                                    width: 24,
                                    color: _selectedIndex == 1 ? primaryColor : textSecondaryColor,
                                  ),
                                ),
                              ).onTap(
                                () => setState(() => _selectedIndex = 1),
                              )),
                          Positioned(
                              left: 180,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                  color: _selectedIndex == 2 ? white : context.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    )
                                  ],
                                ),
                                  // width: context.width() * 0.2,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  child: SvgPicture.asset(
                                    AppAssets.signature,
                                    width: 24,
                                    color: _selectedIndex == 2 ? primaryColor : textSecondaryColor,
                                  ),
                                ),
                              ).onTap(
                                () => setState(() => _selectedIndex = 2),
                              )),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      color: white,
                      width: context.width(),
                      child: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email: ${userProfile.address}',
                              style: secondaryTextStyle(),
                            ),
                            Text(
                              'Phone: ${userProfile.phone}',
                              style: secondaryTextStyle(),
                            ),
                          ],
                        ),
                        BlocBuilder<ArchivementCubit, ArchivementState>(builder: (context, state) {
                          if (state is ArchivementLoadingState) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (state is ArchivementSuccessState) {
                            var archivements = state.archivements.archivements!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3), // changes position of shadow
                                            )
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            FractionallySizedBox(
                                              heightFactor: 1,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: AppAssets.placeholder,
                                                  image: archivements[index].thumbnailUrl!,
                                                  // height: 60,
                                                  width: 80,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Gap.k16.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  archivements[index].tournament!.title!,
                                                  style: primaryTextStyle(),
                                                ),
                                                Text(
                                                  archivements[index].name!,
                                                  style: secondaryTextStyle(),
                                                ),
                                                Text(
                                                  'Rank: ${archivements[index].rank!}',
                                                  style: secondaryTextStyle(),
                                                ),
                                              ],
                                            ).paddingAll(8),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => const Divider(),
                                    itemCount: archivements.length)
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                        BlocProvider<TournamentCubit>(
                          create: (context) => TournamentCubit()..getTournamentsAttended(),
                          child: BlocBuilder<TournamentCubit, TournamentState>(
                            builder: (context, state) {
                              if (state is TournamentAttendedLoadingState) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (state is TournamentAttendedSuccessState) {
                                var tournaments = state.tournaments.tournaments!;
                                if (tournaments.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Container(
                                              height: 110,
                                              decoration: BoxDecoration(
                                                color: white,
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 3), // changes position of shadow
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  FractionallySizedBox(
                                                    heightFactor: 1,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                                      child: FadeInImage.assetNetwork(
                                                        placeholder: AppAssets.placeholder,
                                                        image: tournaments[index].thumbnailUrl!,
                                                        // height: 60,
                                                        width: 110,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Gap.k16.width,
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        tournaments[index].title!,
                                                        style: primaryTextStyle(),
                                                        maxLines: 2,
                                                      ),
                                                      Gap.k4.height,
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            AppAssets.calendar,
                                                            width: 16,
                                                            color: textSecondaryColor,
                                                          ),
                                                          Gap.k8.width,
                                                          Text(
                                                            '${DateFormat('dd-MM-yyyy').format(DateTime.parse(tournaments[index].startTime!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(tournaments[index].endTime!))}',
                                                            style: secondaryTextStyle(),
                                                          ),
                                                        ],
                                                      ),
                                                      Gap.k4.height,
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                            AppAssets.ruler,
                                                            width: 16,
                                                            color: textSecondaryColor,
                                                          ),
                                                          Gap.k8.width,
                                                          Text(
                                                            tournaments[index].distance.toString() + ' km',
                                                            style: secondaryTextStyle(),
                                                          ),
                                                        ],
                                                      ),
                                                      // Text('Rank: ${tournaments[index].rank!}', style: secondaryTextStyle(),),
                                                    ],
                                                  ).paddingAll(8).expand(),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) => const Divider(),
                                          itemCount: tournaments.length)
                                    ],
                                  );
                                } else {
                                  return Wrap(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        width: context.width(),
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: defaultBoxShadow(),
                                        ),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              AppAssets.login_background,
                                              height: 100,
                                              width: 100,
                                            ),
                                            Gap.k16.height,
                                            Text(
                                              "Let's join the first tournament",
                                              style: primaryTextStyle(size: 14),
                                              textAlign: TextAlign.center,
                                            ),
                                            Gap.k16.height,
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Join now',
                                                style: primaryTextStyle(color: white),
                                              ),
                                            ).onTap((){
                                              Navigator.pushNamed(context, SeeAllTournamentScreen.routeName, arguments: 'open');
                                            
                                            })
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        )
                      ].elementAt(_selectedIndex),
                    ).expand(),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await setValue(AppConstant.TOKEN_KEY, '');
                          Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ).paddingSymmetric(vertical: 32);
              }
              return const SizedBox.shrink();
            })
          : Center(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(text: 'You are not logged in, please ', style: primaryTextStyle()),
                  TextSpan(
                      text: 'log in',
                      style: primaryTextStyle(color: primaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        })
                ]),
              ),
            ),
    );
  }
}
