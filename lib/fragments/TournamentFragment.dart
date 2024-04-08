import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/domain/models/tournaments.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/tournament/tournament_cubit.dart';
import '../cubit/tournament/tournament_state.dart';
import '../screens/SeeAllTournamentScreen.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/gap.dart';

class TournamentFragment extends StatelessWidget {
  const TournamentFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Tournament'),
      body: BlocProvider<TournamentCubit>(
          create: (context) => TournamentCubit()..getTournaments(),
          child: BlocBuilder<TournamentCubit, TournamentState>(builder: (context, state) {
            if (state is TournamentLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TournamentSuccessState) {
              var tournaments = state.tournaments.tournaments!;
              var upcoming = tournaments.where((t) => DateTime.parse(t.startTime!).isAfter(DateTime.now())).toList();
              var happenning = tournaments.where((t) => DateTime.parse(t.startTime!).isBefore(DateTime.now()) && DateTime.parse(t.endTime!).isAfter(DateTime.now())).toList();
              var finished = tournaments.where((t) => DateTime.parse(t.endTime!).isBefore(DateTime.now())).toList();
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TournamentCubit>().getTournaments();
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Upcoming (${upcoming.length})',
                              style: primaryTextStyle(),
                            ),
                            const Spacer(),
                            Text('See All', style: primaryTextStyle(color: primaryColor)).paddingRight(16).onTap(() {
                              Navigator.pushNamed(context, SeeAllTournamentScreen.routeName, arguments: 'upcoming');
                            }),
                          ],
                        ),
                        Gap.k8.height,
                        upcoming.isNotEmpty
                            ? TournamentsList(
                                tournaments: upcoming,
                                isShowRegisterButton: true,
                              )
                            : const SizedBox.shrink(),
                        Gap.k16.height,
                        Row(
                          children: [
                            Text(
                              'Happenning Now (${happenning.length})',
                              style: primaryTextStyle(),
                            ),
                            const Spacer(),
                            Text('See All', style: primaryTextStyle(color: primaryColor)).paddingRight(16).onTap(() {
                              Navigator.pushNamed(context, SeeAllTournamentScreen.routeName, arguments: 'happenning');
                            }),
                          ],
                        ),
                        Gap.k8.height,
                        happenning.isNotEmpty
                            ? TournamentsList(
                                tournaments: happenning,
                                isShowRegisterButton: false,
                              )
                            : const SizedBox.shrink(),
                        Gap.k16.height,
                        Row(
                          children: [
                            Text(
                              'Finished (${finished.length})',
                              style: primaryTextStyle(),
                            ),
                            const Spacer(),
                            Text('See All', style: primaryTextStyle(color: primaryColor)).paddingRight(16).onTap(() {
                              Navigator.pushNamed(context, SeeAllTournamentScreen.routeName, arguments: 'finished');
                            }),
                          ],
                        ),
                        Gap.k8.height,
                        finished.isNotEmpty
                            ? TournamentsList(
                                tournaments: finished,
                                isShowRegisterButton: false,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ).paddingLeft(16)),
              );
            }
            return const SizedBox.shrink();
          })),
    );
  }
}

class TournamentsList extends StatelessWidget {
  TournamentsList({
    super.key,
    required this.tournaments,
    required this.isShowRegisterButton,
  });

  final List<Tournament> tournaments;
  final bool isShowRegisterButton;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            width: context.width(),
            child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                      padding: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: white,
                        boxShadow: defaultBoxShadow(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: FadeInImage.assetNetwork(
                                placeholder: AppAssets.placeholder,
                                image: tournaments[index].thumbnailUrl!,
                                height: 150,
                                width: context.width() * 0.8,
                                fit: BoxFit.cover,
                              )),
                          Gap.k8.height,
                          SizedBox(
                              width: context.width() * 0.8,
                              child: Text(
                                tournaments[index].title!,
                                style: boldTextStyle(size: 20),
                                overflow: TextOverflow.ellipsis,
                              ).paddingLeft(16)),
                          const Spacer(),
                          Row(
                            children: [
                              SvgPicture.asset(AppAssets.calendar, height: 16, width: 16, color: gray),
                              Gap.k4.width,
                              Text(
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(tournaments[index].startTime!))} to ${DateFormat('dd/MM/yyyy').format(DateTime.parse(tournaments[index].endTime!))}',
                                style: primaryTextStyle(),
                              )
                            ],
                          ).paddingLeft(16),
                          if (isShowRegisterButton) ...[
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: primaryColor,
                              ),
                              child: Text(
                                'Register',
                                style: boldTextStyle(color: white, size: 14),
                              ).paddingSymmetric(horizontal: 32, vertical: 4),
                            ).paddingSymmetric(horizontal: 16).onTap(() {
                              if (getStringAsync(AppConstant.TOKEN_KEY) == '') {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Please login to register'),
                                  backgroundColor: tomato,
                                ));
                              } else {
                                // Navigator.pushNamed(context, RegisterTournamentScreen.routeName, arguments: tournaments[index]);
                              }
                            })
                          ],
                          if (!isShowRegisterButton) ...[
                            const Spacer(),
                            Row(
                              children: [
                                SvgPicture.asset(AppAssets.calendar_xmark, height: 16, width: 16, color: gray),
                                Gap.k8.width,
                                Text(
                                  'Expired registration',
                                  style: boldTextStyle(color: gray, size: 14),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 16)
                          ]
                        ],
                      ),
                    ),
                separatorBuilder: (context, index) => Gap.k16.width,
                itemCount: tournaments.length),
          ),
        ],
      ),
    );
  }
}
