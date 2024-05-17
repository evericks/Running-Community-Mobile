import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/exercise/exercise_cubit.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/widgets/custom_sliver_app_bar_delegate.dart';

import '../cubit/exercise/exercise_state.dart';
import '../domain/models/user_exercise_item.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';
import 'ExerciseItemScreen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key, required this.id});
  static const String routeName = '/exercise';
  final String id;

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  bool isExpanded = false;
  bool canExpand = false;
  List<UserExerciseItem> userExerciseItems = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExerciseCubit>(
      create: (context) => ExerciseCubit()..fetchUserDataAndExercise(id: widget.id),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: const MyAppBar(
            title: '',
          ),
          body: BlocConsumer<ExerciseCubit, ExerciseState>(
            listener: (context, state) {
              if (state is GetUserExerciseItemSuccessState) {
                setState(() {
                  userExerciseItems = state.userExerciseItems;
                });
              }
            },
            builder: (context, state) {
              if (state is GetExerciseByIdLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GetExerciseByIdSuccessState) {
                var exercise = state.exercise;
                canExpand = exercise.description!.length > 200;
                var exerciseItems = exercise.exerciseItems;
                exerciseItems!.sort((a, b) => a.priority!.compareTo(b.priority!));
                return CustomScrollView(
                  slivers: [
                    // SliverAppBar(
                    //   expandedHeight: 400.0,
                    //   floating: false,
                    //   pinned: true,
                    //   flexibleSpace: FlexibleSpaceBar(
                    //     // title: Text(exercise.name!),
                    //     background: FadeInImage.assetNetwork(placeholder: AppAssets.placeholder, image: exercise.thumbnailUrl!, fit: BoxFit.cover,),
                    //   ),
                    // ),
                    SliverPersistentHeader(
                      delegate: CustomSliverAppBarDelegate(thumbnailUrl: exercise.thumbnailUrl!, expandedHeight: 400.0, context: context),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name!,
                              style: boldTextStyle(size: 40),
                            ),
                            Gap.k8.height,
                            Text('Description', style: boldTextStyle(size: 20)),
                            if (canExpand)
                              if (!isExpanded)
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: exercise.description!.substring(0, 200), style: secondaryTextStyle()),
                                  TextSpan(text: '... ', style: secondaryTextStyle()),
                                  TextSpan(
                                      text: 'Read more',
                                      style: secondaryTextStyle(color: primaryColor),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            isExpanded = true;
                                          });
                                        }),
                                ]))
                              else
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(text: exercise.description!, style: secondaryTextStyle()),
                                    TextSpan(
                                        text: ' Read less',
                                        style: secondaryTextStyle(color: primaryColor),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            setState(() {
                                              isExpanded = false;
                                            });
                                          }),
                                  ]),
                                )
                            else
                              Text(
                                exercise.description!,
                                style: secondaryTextStyle(),
                              ),
                            Gap.kSection.height,
                            Text('Steps', style: boldTextStyle(size: 20)),
                            Gap.k8.height,
                            exerciseItems.isNotEmpty
                                ? ListView.separated(
                                    padding: EdgeInsets.only(top: 0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        // height: 70,
                                        decoration: BoxDecoration(
                                          color: gray.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          children: [
                                            exerciseItems[index].thumbnailUrl != null
                                                ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: FadeInImage.assetNetwork(
                                                        placeholder: AppAssets.placeholder, image: exerciseItems[index].thumbnailUrl!, width: 80, height: 80 * 9 / 16, fit: BoxFit.cover))
                                                : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(AppAssets.placeholder, width: 80, height: 80 * 9 / 16, fit: BoxFit.cover)),
                                            Gap.k16.width,
                                            Text(exerciseItems[index].title!, style: boldTextStyle()),
                                            const Spacer(),
                                            SvgPicture.asset(userExerciseItems.any((i) => i.exerciseItemId == exerciseItems[index].id) ? AppAssets.circle_check : AppAssets.circle_play,
                                                width: 24, height: 24, color: primaryColor)
                                          ],
                                        ),
                                      ).onTap(() async {
                                        var isRefresh = await Navigator.pushNamed(context, ExerciseItemScreen.routeName, arguments: exerciseItems[index].id!);
                                        if (isRefresh == true) {

                                          context.read<ExerciseCubit>().fetchUserDataAndExercise(id: widget.id);
                                        }
                                      });
                                    },
                                    separatorBuilder: (context, index) => Gap.k8.height,
                                    itemCount: exerciseItems.length)
                                : Text('No steps', style: secondaryTextStyle()),
                            Gap.k8.height,
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          )),
    );
  }
}
