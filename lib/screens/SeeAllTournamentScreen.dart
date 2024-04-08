import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_cubit.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_state.dart';
import 'package:running_community_mobile/utils/constants.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../utils/app_assets.dart';
import '../utils/colors.dart';

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
              if (status == 'happenning') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.startTime!).isBefore(DateTime.now()) && DateTime.parse(t.endTime!).isAfter(DateTime.now())).toList();
              }
              if (status == 'finished') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.endTime!).isBefore(DateTime.now())).toList();
              }
              if (status == 'upcoming') {
                tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.startTime!).isAfter(DateTime.now())).toList();
              }
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                              padding: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(16), boxShadow: defaultBoxShadow()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.network(
                                      tournaments[index].thumbnailUrl!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                  Gap.k8.height,
                                  Text(
                                    tournaments[index].title!,
                                    style: primaryTextStyle(size: 16, weight: FontWeight.bold),
                                  ).paddingLeft(16),
                                  Gap.k8.height,
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
                                  if (status == 'upcoming') ...[
                                    Gap.k16.height,
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: primaryColor,
                                      ),
                                      child: Text(
                                        'Register',
                                        style: boldTextStyle(color: white, size: 14),
                                      ).paddingSymmetric(horizontal: 32, vertical: 4),
                                    ).paddingSymmetric(horizontal: 16).onTap((){
                                      if (getStringAsync(AppConstant.TOKEN_KEY) == '') {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login to register'), backgroundColor: tomato,));
                                      } else {
                                        // Navigator.pushNamed(context, RegisterTournamentScreen.routeName, arguments: tournaments[index]);
                                        
                                      }
                                    })
                                  ],
                                  if (status != 'upcoming') ...[
                                    Gap.k16.height,
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
                        separatorBuilder: (context, index) => Gap.k16.height,
                        itemCount: tournaments.length)
                  ],
                ).paddingSymmetric(horizontal: 16),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
