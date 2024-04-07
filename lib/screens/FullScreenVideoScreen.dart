import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

import '../utils/app_assets.dart';
import '../utils/colors.dart';

class FullScreenVideoScreen extends StatefulWidget {
  const FullScreenVideoScreen({super.key, required this.videoPlayerController});
  static const String routeName = '/full-screen-video';
  final VideoPlayerController videoPlayerController;

  @override
  State<FullScreenVideoScreen> createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  bool _isControllerVisible = false;
  VideoPlayerController get videoPlayerController => widget.videoPlayerController;
  // ignore: unused_field
  Timer? _timer;

  @override
  void initState() {
    videoPlayerController.play().then((_) {
      setState(() {});
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      _startTimer();
    });
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          ),
          if (_isControllerVisible) ...[
            SvgPicture.asset(
              videoPlayerController.value.isPlaying ? AppAssets.pause : AppAssets.play,
              width: 50,
              height: 50,
              color: white.withOpacity(0.5),
            ).onTap(() {
              if (videoPlayerController.value.isPlaying) {
                videoPlayerController.pause();
                setState(() {
                  _isControllerVisible = true;
                });
              } else {
                videoPlayerController.play();
                setState(() {});
                Future.delayed(const Duration(seconds: 3), () {
                  if (videoPlayerController.value.isPlaying) {
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
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                Navigator.pop(context);
              }),
            ),
            Positioned(
              left: 0,
              bottom: 16,
              child: Text(
                '${_printDuration(videoPlayerController.value.position)} / ${_printDuration(videoPlayerController.value.duration)}',
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
                    value: videoPlayerController.value.position.inSeconds.toDouble(),
                    max: videoPlayerController.value.duration.inSeconds.toDouble(),
                    onChanged: (value) => setState(() {
                          videoPlayerController.seekTo(Duration(seconds: value.toInt()));
                        })))
          ]
        ],
      ).onTap(() {
        setState(() {
          _isControllerVisible = !_isControllerVisible;
        });
        Future.delayed(const Duration(seconds: 3), () {
          if (videoPlayerController.value.isPlaying) {
            setState(() {
              _isControllerVisible = false;
            });
          }
        });
      })),
    );
  }
}
