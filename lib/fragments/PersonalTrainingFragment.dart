import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/exercise/exercise_cubit.dart';
import 'package:running_community_mobile/cubit/exercise/exercise_state.dart';
import 'package:running_community_mobile/screens/ExerciseScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../domain/repositories/user_repo.dart';

class PersonalTrainingFragment extends StatelessWidget {
  const PersonalTrainingFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: 'Personal Training'),
      body: (UserRepo.user.status != 'Active' && UserRepo.user.id != null)
              ? Center(
                  child: Text(
                    'Your account has been blocked, you cannot access this function',
                    style: boldTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ).paddingSymmetric(horizontal: 16)
              : BlocProvider<ExerciseCubit>(
        create: (context) => ExerciseCubit()..getExercises(),
        child: BlocBuilder<ExerciseCubit, ExerciseState>(
          builder: (context, state) {
            if (state is ExercisesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExercisesSuccessState) {
              var exercises = state.exercises.exercises;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: exercises!.length,
                separatorBuilder: (context, index) => Gap.k16.height,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    
                    ),
                      width: context.width(),
                      height: context.width() * 3/5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: context.width(),
                          height: context.width() * 1/2,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: FadeInImage.assetNetwork(placeholder: AppAssets.placeholder, image: exercises[index].thumbnailUrl!, fit: BoxFit.cover,),
                          ),
                        ).onTap((){
                          Navigator.pushNamed(context, ExerciseScreen.routeName, arguments: exercises[index].id!);
                        }),
                        Gap.k8.height,
                        Text(exercises[index].name!, style: boldTextStyle()).paddingLeft(16),
                      ],
                    ),
                  );
                },
              );
            } else if (state is ExercisesFailedState) {
              return Center(child: Text(state.error.replaceFirst('Exception: ', '')));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
