import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../components/TournamentListComponent.dart';
import '../cubit/tournament/tournament_cubit.dart';
import '../cubit/tournament/tournament_state.dart';
import '../domain/repositories/user_repo.dart';
import '../screens/SeeAllTournamentScreen.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';

class TournamentFragment extends StatefulWidget {
  const TournamentFragment({super.key});

  @override
  State<TournamentFragment> createState() => _TournamentFragmentState();
}

class _TournamentFragmentState extends State<TournamentFragment> {
  @override
  Widget build(BuildContext context) {
    var attendTournament = [];
    return Scaffold(
      appBar: const MyAppBar(title: 'Tournament'),
      body: UserRepo.user.status != 'Active'
              ? Center(
                  child: Text(
                    'Your account has been blocked, you cannot access this function',
                    style: boldTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ).paddingSymmetric(horizontal: 16)
              : BlocProvider<TournamentCubit>(
          create: (context) => TournamentCubit()
            ..getTournaments(pageSize: 100),
          child: BlocBuilder<TournamentCubit, TournamentState>( builder: (context, state) {
            if (state is TournamentLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TournamentSuccessState) {
              var tournaments = state.tournaments.tournaments!;
              tournaments.removeWhere((t) => attendTournament.contains(t.id));
              var upcoming = tournaments.where((t) => DateTime.parse(t.registerDuration!).isAfter(DateTime.now())).toList();
              var happenning = tournaments.where((t) => DateTime.parse(t.startTime!).isBefore(DateTime.now()) && DateTime.parse(t.endTime!).isAfter(DateTime.now())).toList();
              var finished = tournaments.where((t) => DateTime.parse(t.endTime!).isBefore(DateTime.now())).toList();
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TournamentCubit>().getTournaments(pageSize: 100);
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
                            ).paddingLeft(16),
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
                              )
                            : const SizedBox.shrink(),
                        Gap.k16.height,
                        Row(
                          children: [
                            Text(
                              'Happening Now (${happenning.length})',
                              style: primaryTextStyle(),
                            ).paddingLeft(16),
                            const Spacer(),
                            Text('See All', style: primaryTextStyle(color: primaryColor)).paddingRight(16).onTap(() {
                              Navigator.pushNamed(context, SeeAllTournamentScreen.routeName, arguments: 'happening');
                            }),
                          ],
                        ),
                        Gap.k8.height,
                        happenning.isNotEmpty
                            ? TournamentsList(
                                tournaments: happenning,
                              )
                            : const SizedBox.shrink(),
                        Gap.k16.height,
                        Row(
                          children: [
                            Text(
                              'Finished (${finished.length})',
                              style: primaryTextStyle(),
                            ).paddingLeft(16),
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
                              )
                            : const SizedBox.shrink(),
                      ],
                    ).paddingOnly(bottom: 96)),
              );
            }
            return const SizedBox.shrink();
          })),
    );
  }
}
