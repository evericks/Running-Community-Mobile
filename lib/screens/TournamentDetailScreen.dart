import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_state.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/tournament/tournament_cubit.dart';
import '../utils/app_assets.dart';
import '../widgets/TimeCard.dart';

class TournamentDetailScreen extends StatefulWidget {
  const TournamentDetailScreen({super.key, required this.id});
  static const String routeName = '/tournament-detail';
  final String id;

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  late Duration duration = const Duration(); // Thay đổi giá trị này tùy theo yêu cầu
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration.inSeconds == 0) {
        timer?.cancel();
      } else {
        setState(() {
          duration -= const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration.inDays);
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Scaffold(
      appBar: const MyAppBar(
        title: 'Tournament Detail',
      ),
      body: BlocProvider<TournamentCubit>(
        create: (context) => TournamentCubit()..getTournamentById(widget.id),
        child: BlocConsumer<TournamentCubit, TournamentState>(
          listener: (context, state) {
            if (state is TournamentDetailSuccessState) {
              var tournament = state.tournament;
              var endTime = DateTime.parse(tournament.endTime!);
              duration = endTime.difference(DateTime.now());
            }
          },
          builder: (context, state) {
            if (state is TournamentDetailLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TournamentDetailSuccessState) {
              var tournament = state.tournament;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInImage.assetNetwork(
                      placeholder: AppAssets.placeholder,
                      image: tournament.thumbnailUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                    Gap.k16.height,
                    Text(tournament.title!, style: boldTextStyle(size: 20)).paddingLeft(16),
                    Gap.k16.height,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.calendar,
                          width: 16,
                          height: 16,
                          color: gray,
                        ),
                        4.width,
                        Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(tournament.startTime!)), style: secondaryTextStyle()),
                      ],
                    ).paddingLeft(16),
                    Gap.k16.height,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.ruler,
                          width: 16,
                          height: 16,
                          color: gray,
                        ),
                        4.width,
                        Text('${tournament.distance} km', style: secondaryTextStyle()),
                      ],
                    ).paddingLeft(16),
                    Gap.k16.height,
                    const Divider(),
                    if (DateTime.now().isBefore(DateTime.parse(tournament.registerDuration!))) ...[
                      Gap.k16.height,
                      Text('Registration time remaining', style: boldTextStyle(size: 16)).paddingLeft(16),
                      Gap.k8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTimeCard(time: days, header: 'Ngày'),
                          Spacer(),
                          buildTimeCard(time: hours, header: 'Giờ'),
                          Spacer(),
                          buildTimeCard(time: minutes, header: 'Phút'),
                          Spacer(),
                          buildTimeCard(time: seconds, header: 'Giây'),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      Gap.k16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: primaryColor,
                                  ),
                                  child: Text(
                                    'Register now',
                                    style: boldTextStyle(color: white, size: 14),
                                    textAlign: TextAlign.center,
                                  ).paddingSymmetric(horizontal: 32, vertical: 8))
                              .expand(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ],
                    Gap.k16.height,
                    Text(tournament.description!, style: secondaryTextStyle()).paddingLeft(16),
                  ],
                ).paddingBottom(16),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
