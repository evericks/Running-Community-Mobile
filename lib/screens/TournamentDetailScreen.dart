import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:running_community_mobile/cubit/tournament/tournament_state.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/tournament/tournament_cubit.dart';
import '../utils/app_assets.dart';
import '../widgets/TimeCard.dart';
import 'QRCodeScreen.dart';

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
  bool isAttended = false;
  File? qrCodeImage;

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

  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }

  Future<void> _showQRCode(String tournamentId, String userId) async {
    try {
      final qrCodePath = await generateAndCacheQRCode(tournamentId, userId);
      setState(() {
        qrCodeImage = File(qrCodePath);
      });
      print('QR code generated: $qrCodePath');
    } catch (e) {
      print('Failed to generate QR code: $e');
    }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isAttended
          ? FloatingActionButton(
              onPressed: () async {
                // await _showQRCode(widget.id, UserRepo.user.id!);
                var qrCodeData = await generateQRCode(widget.id, UserRepo.user.id!);
                Navigator.pushNamed(context, QRCodeScreen.routeName, arguments: qrCodeData);
              },
              child: SvgPicture.asset(
                AppAssets.qr,
                color: white,
                width: 32,
              ),
              backgroundColor: primaryColor,
            )
          : null,
      body: BlocProvider<TournamentCubit>(
        create: (context) {
          var cubit = TournamentCubit();
          if (UserRepo.user.id != null) {
            cubit.getTournamentsAttended();
          } else {
            cubit.getTournamentById(widget.id);
          }
          return cubit;
        },
        child: BlocConsumer<TournamentCubit, TournamentState>(
          listener: (context, state) async {
            if (state is TournamentDetailSuccessState) {
              var tournament = state.tournament;
              var endTime = DateTime.parse(tournament.endTime!);
              duration = endTime.difference(DateTime.now());
              // context.read<TournamentCubit>().getTournamentsAttended();
            }
            if (state is GetTournamentAttendedSuccessState) {
              context.read<TournamentCubit>().getTournamentById(widget.id);
              if (state.tournaments.tournaments!.any((element) => element.id == widget.id)) {
                setState(() {
                  isAttended = true;
                });
              }
            }
            if (state is TournamentAttendedLoadingState) {
              showLoader(context);
            } else if (state is TournamentAttendedSuccessState) {
              hideLoader(context);
              Fluttertoast.showToast(msg: 'Register successfully');
              await context.read<TournamentCubit>().getTournamentsAttended();
              context.read<TournamentCubit>().getTournamentById(widget.id);
            } else if (state is TournamentAttendedFailedState) {
              hideLoader(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.replaceAll('Exception: ', '')), backgroundColor: tomato));
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
                    if (DateTime.now().isBefore(DateTime.parse(tournament.registerDuration!)) && !isAttended) ...[
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
                              .onTap(() {
                            if (UserRepo.user.id != null) {
                              showConfirmDialog(context, 'Do you want to register this tournament?').then((value) => value ? context.read<TournamentCubit>().attendTournament(tournament.id!) : null);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Please login to register'), backgroundColor: tomato));
                            }
                          }).expand(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ],
                    if (isAttended) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You have registered this tournament',
                            style: boldTextStyle(color: gray, size: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                    Gap.k16.height,
                    Text(tournament.description!, style: secondaryTextStyle()).paddingLeft(16),
                  ],
                ).paddingBottom(16),
              );
            }
            return const SizedBox.shrink();
            // return Center(child: Text(state.toString()),);
          },
        ),
      ),
    );
  }
}

Future<Uint8List> generateQRCode(String tournamentId, String userId) async {
  ui.PictureRecorder recorder = ui.PictureRecorder();
  final qrValidationResult = QrValidator.validate(data: 'tournamentId=$tournamentId&userId=$userId', version: QrVersions.auto, errorCorrectionLevel: QrErrorCorrectLevel.L);

  if (!qrValidationResult.isValid) {
    throw Exception('Failed to generate QR code');
  }

  final qrCode = qrValidationResult.qrCode;

  final canvas = Canvas(recorder);
  final painter = QrPainter.withQr(
    qr: qrCode!,
    color: black,
    gapless: true,
    emptyColor: Colors.white,
  );
  painter.paint(canvas, const Size(200, 200));
  final picture = recorder.endRecording();
  final img = await picture.toImage(200, 200);

  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  return pngBytes;
}

Future<String> generateAndCacheQRCode(String tournamentId, String userId) async {
  final cacheManager = DefaultCacheManager();
  ui.PictureRecorder recorder = ui.PictureRecorder();
  FileInfo? cachedFile = await cacheManager.getFileFromCache('qr-$tournamentId');
  if (cachedFile != null) {
    return cachedFile.file.path;
  } else {
    final qrValidationResult = QrValidator.validate(data: 'tournamentId=$tournamentId&userId=$userId', version: QrVersions.auto, errorCorrectionLevel: QrErrorCorrectLevel.L);

    if (!qrValidationResult.isValid) {
      throw Exception('Failed to generate QR code');
    }

    final qrCode = qrValidationResult.qrCode;

    final qrImage = QrImageView(
      data: '$tournamentId$userId',
      version: QrVersions.auto,
      size: 200.0,
      gapless: true,
    );

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/qr-$tournamentId.png';

    final canvas = Canvas(recorder);
    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: black,
      gapless: true,
      emptyColor: Colors.white,
    );
    painter.paint(canvas, const Size(200, 200));
    final picture = recorder.endRecording();
    final img = await picture.toImage(200, 200);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    final buffer = pngBytes!.buffer.asUint8List();

    File file = File(tempPath);
    await file.writeAsBytes(buffer);

    await cacheManager.putFile('qr-$tournamentId', file.readAsBytesSync(), fileExtension: 'png');
    return tempPath;
  }
}
