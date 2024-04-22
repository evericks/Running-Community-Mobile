import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/components/TournamentComponent.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_cubit.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_state.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import 'TournamentDetailScreen.dart';

class SeeAllTournamentScreen extends StatelessWidget {
  const SeeAllTournamentScreen({super.key, required this.status});
  static const String routeName = '/see-all-tournament';
  final String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'See All Tournament'),
      body: BlocProvider<TournamentCubit>(
        create: (context) => TournamentCubit()..getTournaments(),
        child: BlocBuilder<TournamentCubit, TournamentState>(
          builder: (context, state) {
            if (state is TournamentLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TournamentSuccessState) {
              var tournaments = state.tournaments.tournaments!;
              if (status == 'happening') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.startTime!).isBefore(DateTime.now()) && DateTime.parse(t.endTime!).isAfter(DateTime.now())).toList();
              }
              if (status == 'finished') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.endTime!).isBefore(DateTime.now())).toList();
              }
              if (status == 'upcoming') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.startTime!).isAfter(DateTime.now())).toList();
              }
              if (status == 'open') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.registerDuration!).isAfter(DateTime.now())).toList();
              }
              return tournaments.isNotEmpty ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) => SizedBox(
                          height: context.width() * 0.7,
                          child: LayoutBuilder(
                            builder: (BuildContext context, BoxConstraints constraints) {
                              return TournamentComponent(tournaments: tournaments[index]).onTap(() {
                                    Navigator.pushNamed(context, TournamentDetailScreen.routeName, arguments: tournaments[index].id);
                                  });
                            }
                          ),
                        ),
                        separatorBuilder: (context, index) => Gap.k16.height,
                        itemCount: tournaments.length)
                  ],
                ).paddingSymmetric(horizontal: 16),
              ) : const Center(child: Text('No tournament found'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
