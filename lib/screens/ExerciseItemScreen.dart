import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/exercise/exercise_cubit.dart';
import 'package:running_community_mobile/cubit/exercise/exercise_state.dart';
import 'package:running_community_mobile/screens/FullScreenVideoScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:video_player/video_player.dart';

import '../widgets/AppBar.dart';

class ExerciseItemScreen extends StatefulWidget {
  const ExerciseItemScreen({super.key, required this.id});
  static const String routeName = '/exerciseItem';
  final String id;

  @override
  State<ExerciseItemScreen> createState() => _ExerciseItemScreenState();
}

class _ExerciseItemScreenState extends State<ExerciseItemScreen> {
  late VideoPlayerController _controller;
  bool _isControllerVisible = true;
  // ignore: unused_field
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(widget.id)
    //   ..initialize().then((_) {
    //     setState(() {});
    //     // _controller.play();
    //     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); //ẩn các thanh trạng thái và điều hướng
    //   });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void loadVideo(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        // _controller.play();
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); //ẩn các thanh trạng thái và điều hướng
        _startTimer();
      });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _controller.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExerciseCubit>(
      create: (context) => ExerciseCubit()..getExerciseItemById(widget.id),
      child: Scaffold(
        appBar: const MyAppBar(title: 'Exercise Item'),
        body: BlocListener<ExerciseCubit, ExerciseState>(
          listener: (context, state) {
            if (state is GetExerciseItemByIdFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
            if (state is GetExerciseItemByIdSuccessState) {
              var exerciseItems = state.exerciseItems;
              loadVideo(exerciseItems.videoUrl!);
            }
          },
          child: BlocBuilder<ExerciseCubit, ExerciseState>(builder: (context, state) {
            if (state is GetExerciseItemByIdLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetExerciseItemByIdSuccessState) {
              var exerciseItems = state.exerciseItems;
              // loadVideo(exerciseItems.videoUrl!);
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.width(),
                      height: context.width() * 9 / 16,
                      child: _controller.value.isInitialized
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                if (_isControllerVisible) ...[
                                  SvgPicture.asset(
                                    _controller.value.isPlaying ? AppAssets.pause : AppAssets.play,
                                    width: 50,
                                    height: 50,
                                    color: white.withOpacity(0.5),
                                  ).onTap(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                      setState(() {
                                        _isControllerVisible = true;
                                      });
                                    } else {
                                      _controller.play();
                                      setState(() {});
                                      Future.delayed(const Duration(seconds: 3), () {
                                        if (_controller.value.isPlaying) {
                                          setState(() {
                                            _isControllerVisible = false;
                                          });
                                        }
                                      });
                                      // setState(() {
                                      //   _isControllerVisible = true;
                                      // });
                                    }
                                  }),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: SvgPicture.asset(AppAssets.expand, width: 20, height: 20, color: white.withOpacity(0.5)).paddingAll(16).onTap(() {
                                      // _controller.pause();
                                      Navigator.pushNamed(context, FullScreenVideoScreen.routeName, arguments: _controller);
                                    }),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 16,
                                    child: Text(
                                      '${_printDuration(_controller.value.position)} / ${_printDuration(_controller.value.duration)}',
                                      style: primaryTextStyle(color: white),
                                    ).paddingAll(16),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 32,
                                      child: Slider(
                                        activeColor: primaryColor,
                                          thumbColor: primaryColor,
                                          value: _controller.value.position.inSeconds.toDouble(),
                                          max: _controller.value.duration.inSeconds.toDouble(),
                                          onChanged: (value) => setState(() {
                                                _controller.seekTo(Duration(seconds: value.toInt()));
                                              })))
                                ],
                              ],
                            ).onTap(() {
                              setState(() {
                                _isControllerVisible = !_isControllerVisible;
                              });
                              Future.delayed(const Duration(seconds: 5), () {
                                if (_controller.value.isPlaying) {
                                  setState(() {
                                    _isControllerVisible = false;
                                  });
                                }
                              });
                            })
                          : const Center(child: CircularProgressIndicator()),
                    ),
                    Gap.kSection.height,
                    Text(exerciseItems.title!, style: boldTextStyle(size: 30)).paddingSymmetric(horizontal: 16),
                    Gap.k16.height,
                    Text(exerciseItems.content!, style: primaryTextStyle()).paddingSymmetric(horizontal: 16),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ),
      ),
    );
  }
}
