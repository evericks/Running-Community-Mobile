import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
  Position? _currentPosition;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied (actual value: $permission).');
      }
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    Position postion = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = postion;
    });
  }

  @override
  Widget build(BuildContext context) {
    var attendTournament = [];
    return Scaffold(
      appBar: const MyAppBar(title: 'Tournament'),
      body: (UserRepo.user.status != 'Active' && UserRepo.user.id != null)
          ? Center(
              child: Text(
                'Your account has been blocked, you cannot access this function',
                style: boldTextStyle(),
                textAlign: TextAlign.center,
              ),
            ).paddingSymmetric(horizontal: 16)
          : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
                children: [
                  _currentPosition == null
                      ? const SizedBox.shrink()
                      : BlocProvider<TournamentCubit>(
                          create: (context) => TournamentCubit()..getTournaments(pageSize: 100, latitude: _currentPosition!.latitude, longitude: _currentPosition!.longitude),
                          child: BlocBuilder<TournamentCubit, TournamentState>(
                            builder: (context, state) {
                              if (state is TournamentSuccessState) {
                                var nearbyTournament = state.tournaments.tournaments!;
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Nearby (${nearbyTournament.length})',
                                          style: primaryTextStyle(),
                                        ).paddingLeft(16),
                                        // const Spacer(),
                                        // Text('See All', style: primaryTextStyle(color: primaryColor)).paddingRight(16).onTap(() {
                                        //   Navigator.pushNamed(context, SeeAllTournamentScreen.routeName, arguments: 'nearby');
                                        // }),
                                      ],
                                    ),
                                    Gap.k8.height,
                                    nearbyTournament.isNotEmpty
                                        ? TournamentsList(
                                            tournaments: nearbyTournament,
                                          )
                                        : const SizedBox.shrink(),
                                    Gap.k16.height,
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                  BlocProvider<TournamentCubit>(
                      create: (context) => TournamentCubit()..getTournaments(pageSize: 100),
                      child: BlocBuilder<TournamentCubit, TournamentState>(builder: (context, state) {
                        if (state is TournamentLoadingState) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is TournamentSuccessState) {
                          var tournaments = state.tournaments.tournaments!;
                          tournaments.removeWhere((t) => attendTournament.contains(t.id));
                          var upcoming = tournaments.where((t) => DateTime.parse(t.registerDuration!).isAfter(DateTime.now())).toList();
                          var happenning = tournaments.where((t) => DateTime.parse(t.startTime!).isBefore(DateTime.now()) && DateTime.parse(t.endTime!).isAfter(DateTime.now())).toList();
                          var finished = tournaments.where((t) => DateTime.parse(t.endTime!).isBefore(DateTime.now())).toList();
                          return Column(
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
                          ).paddingOnly(bottom: 96);
                        }
                        return const SizedBox.shrink();
                      })),
                ],
              ),
          ),
    );
  }
}
