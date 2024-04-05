import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/exercise_repo.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepo _exerciseRepository = getIt.get<ExerciseRepo>();
  ExerciseCubit() : super(ExerciseState());

  Future<void> getExercises({String? name, int? pageSize, int? pageNumber}) async {
    try {
      emit(ExercisesLoadingState());
      final exercises = await _exerciseRepository.getExercises(
          name: name, pageSize: pageSize, pageNumber: pageNumber);
      emit(ExercisesSuccessState(exercises));
    } catch (e) {
      emit(ExercisesFailedState(e.toString()));
    }
  }

  Future<void> getExerciseById(String id) async {
    try {
      emit(GetExerciseByIdLoadingState());
      final exercise = await _exerciseRepository.getExerciseById(id);
      emit(GetExerciseByIdSuccessState(exercise));
    } catch (e) {
      emit(GetExerciseByIdFailedState(e.toString()));
    }
  }

  Future<void> getExerciseItemById(String id) async {
    try {
      emit(GetExerciseItemByIdLoadingState());
      final exerciseItems = await _exerciseRepository.getExerciseItemById(id);
      emit(GetExerciseItemByIdSuccessState(exerciseItems));
    } catch (e) {
      emit(GetExerciseItemByIdFailedState(e.toString()));
    }
  }
}