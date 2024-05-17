import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';

import '../cubit/tournament/tournament_cubit.dart';
import '../cubit/tournament/tournament_state.dart';
import '../screens/TournamentDetailScreen.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  final PageController _pageController = PageController();
  // late Timer _timer;
  int _currentPage = 0;
  int? pageSize;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < pageSize!; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBar(title: 'Home'),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<TournamentCubit>(
              create: (context) => TournamentCubit()..getTournaments(pageSize: 1000),
            ),
          ],
          child: (UserRepo.user.status != 'Active' && UserRepo.user.id != null)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocConsumer<TournamentCubit, TournamentState>(listener: (context, state) {
                        if (state is TournamentSuccessState) {
                          setState(() {
                            pageSize = state.tournaments.tournaments!.where((t) => DateTime.parse(t.registerDuration!).isAfter(DateTime.now())).toList().length;
                          });
                          Timer.periodic(const Duration(seconds: 3), (Timer timer) {
                            if (_currentPage < pageSize! - 1) {
                              _currentPage++;
                            } else {
                              _currentPage = 0;
                            }

                            _pageController.animateToPage(
                              _currentPage,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          });
                        }
                      }, builder: (context, state) {
                        if (state is TournamentSuccessState) {
                          var tournaments = state.tournaments.tournaments!.where((t) => DateTime.parse(t.registerDuration!).isAfter(DateTime.now())).toList();
                          return tournaments.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Open Tournaments',
                                      style: boldTextStyle(),
                                    ).paddingLeft(16),
                                    Gap.k16.height,
                                    SizedBox(
                                      height: 350,
                                      child: PageView.builder(
                                        controller: _pageController,
                                        itemCount: tournaments.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
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
                                                      width: context.width(),
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
                                                const Spacer(),
                                                SizedBox(
                                                  height: 50,
                                                  child: Text(
                                                    tournaments[index].description!,
                                                    style: primaryTextStyle(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ).paddingSymmetric(horizontal: 16),
                                                ),
                                                const Spacer(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Gap.k16.width,
                                                    Text(tournaments[index].fee == 0 ? 'Free' : '${NumberFormat('#,##0', 'en_US').format(tournaments[index].fee)} đ',
                                                        style: boldTextStyle(color: primaryColor, size: 16)),
                                                    const Spacer(),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        color: primaryColor,
                                                      ),
                                                      child: Text(
                                                        'View detail',
                                                        style: boldTextStyle(color: white, size: 14),
                                                      ).paddingSymmetric(horizontal: 32, vertical: 4),
                                                    ).paddingSymmetric(horizontal: 16).onTap(() {
                                                      Navigator.pushNamed(context, TournamentDetailScreen.routeName, arguments: tournaments[index].id);
                                                    }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: _buildPageIndicator(),
                                    ),
                                  ],
                                )
                              : const Center(child: Text('No open tournament'));
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
        ));
  }
}
