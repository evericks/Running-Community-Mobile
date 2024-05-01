// ignore_for_file: deprecated_member_use

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
import 'package:running_community_mobile/domain/models/tournaments.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/screens/DashboardScreen.dart';
import 'package:running_community_mobile/screens/LoginScreen.dart';
import 'package:running_community_mobile/screens/SeeAllTournamentScreen.dart';
import 'package:running_community_mobile/screens/TournamentDetailScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/archivement/archivement_cubit.dart';
import '../domain/models/user.dart';
import '../utils/constants.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  int _selectedIndex = 0;
  List<Tournament> completedTournament = [];
  @override
  Widget build(BuildContext context) {
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
                      height: 38,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            // top: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                // width: context.width() * 0.2,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                  height: 20,
                                  width: 20,
                                  color: _selectedIndex == 0 ? primaryColor : textSecondaryColor,
                                ),
                              ).onTap(() => setState(() => _selectedIndex = 0)),
                            ),
                          ),
                          Positioned(
                              left: 55,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: SvgPicture.asset(
                                    AppAssets.trophy,
                                    height: 20,
                                    width: 20,
                                    color: _selectedIndex == 1 ? primaryColor : textSecondaryColor,
                                  ),
                                ),
                              ).onTap(
                                () => setState(() => _selectedIndex = 1),
                              )),
                          Positioned(
                              left: 110,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: SvgPicture.asset(
                                    AppAssets.signature,
                                    height: 20,
                                    width: 20,
                                    color: _selectedIndex == 2 ? primaryColor : textSecondaryColor,
                                  ),
                                ),
                              ).onTap(
                                () => setState(() => _selectedIndex = 2),
                              )),
                          // Positioned(
                          //     left: 167,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //           color: _selectedIndex == 3 ? white : context.scaffoldBackgroundColor,
                          //           borderRadius: BorderRadius.circular(8),
                          //           boxShadow: [
                          //             BoxShadow(
                          //               color: Colors.grey.withOpacity(0.5),
                          //               spreadRadius: 1,
                          //               blurRadius: 7,
                          //               offset: const Offset(0, 3), // changes position of shadow
                          //             )
                          //           ],
                          //         ),
                          //         // width: context.width() * 0.2,
                          //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          //         child: SvgPicture.asset(
                          //           AppAssets.flag,
                          //           height: 20,
                          //           width: 20,
                          //           color: _selectedIndex == 3 ? primaryColor : textSecondaryColor,
                          //         ),
                          //       ),
                          //     ).onTap(
                          //       () => setState(() => _selectedIndex = 3),
                          //     )),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      color: white,
                      width: context.width(),
                      child: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address: ${userProfile.address}',
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
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
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
                              if (state is GetTournamentAttendedLoadingState) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (state is GetTournamentAttendedSuccessState) {
                                var tournaments = state.tournaments.tournaments!;
                                // setState(() {
                                //   completedTournament = tournaments.where((t) => t.);
                                // });
                                if (tournaments.isNotEmpty) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return TournamentWidget(tournaments: tournaments[index]).onTap(() {
                                              Navigator.pushNamed(context, TournamentDetailScreen.routeName, arguments: tournaments[index].id);
                                            });
                                          },
                                          separatorBuilder: (context, index) => Gap.k8.height,
                                          itemCount: tournaments.length)
                                    ],
                                  );
                                } else {
                                  return (UserRepo.user.status != 'Active' && UserRepo.user.id != null)
                                      ? Center(
                                          child: Text(
                                            'Your account has been blocked, you cannot access this function',
                                            style: boldTextStyle(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ).paddingSymmetric(horizontal: 16)
                                      : Wrap(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      'Join now',
                                                      style: primaryTextStyle(color: white),
                                                    ),
                                                  ).onTap(() {
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
                        ),
                      ].elementAt(_selectedIndex),
                    ).expand(),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await setValue(AppConstant.TOKEN_KEY, '');
                          UserRepo.user = User();
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, DashboardScreen.routeName, arguments: 0);
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ).paddingOnly(bottom: 96);
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

class TournamentWidget extends StatelessWidget {
  const TournamentWidget({
    super.key,
    required this.tournaments,
  });

  final Tournament tournaments;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
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
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: FadeInImage.assetNetwork(
                placeholder: AppAssets.placeholder,
                image: tournaments.thumbnailUrl!,
                // height: 60,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Gap.k16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tournaments.title!,
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
                    '${DateFormat('dd-MM-yyyy').format(DateTime.parse(tournaments.startTime!))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(tournaments.endTime!))}',
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
                    '${tournaments.distance} km',
                    style: secondaryTextStyle(),
                  ),
                ],
              ),
              // Text('Rank: ${tournaments.rank!}', style: secondaryTextStyle(),),
            ],
          ).paddingAll(8).expand(),
        ],
      ),
    );
  }
}
