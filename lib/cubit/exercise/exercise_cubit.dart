import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/exercise_repo.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import 'exercise_state.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepo _exerciseRepository = getIt.get<ExerciseRepo>();
  ExerciseCubit() : super(ExerciseState());

  void fetchUserDataAndExercise({required String id}) {
    emit(GetExerciseByIdLoadingState());
    _exerciseRepository.getUserExerciseItem().then((userExerciseItem) {
      emit(GetUserExerciseItemSuccessState(userExerciseItem));
      return _exerciseRepository.getExerciseById(id);
    }).then((exerciseItem) {
      emit(GetExerciseByIdSuccessState(exerciseItem));
    }).catchError((error) {
      emit(GetExerciseByIdFailedState(error.toString()));
    });
  }

  Future<void> getExercises({String? name, int? pageSize, int? pageNumber}) async {
    try {
      emit(ExercisesLoadingState());
      final exercises = await _exerciseRepository.getExercises(name: name, pageSize: pageSize, pageNumber: pageNumber);
      emit(ExercisesSuccessState(exercises));
    } catch (e) {
      emit(ExercisesFailedState(e.toString()));
    }
  }

  Future<void> getExerciseById({required String id}) async {
    try {
      emit(GetExerciseByIdLoadingState());
      final exercise = await _exerciseRepository.getExerciseById(id);
      emit(GetExerciseByIdSuccessState(exercise));
    } catch (e) {
      emit(GetExerciseByIdFailedState(e.toString()));
    }
  }

  Future<void> getExerciseItemById({required String id}) async {
    try {
      emit(GetExerciseItemByIdLoadingState());
      final exerciseItems = await _exerciseRepository.getExerciseItemById(id);
      emit(GetExerciseItemByIdSuccessState(exerciseItems));
    } catch (e) {
      emit(GetExerciseItemByIdFailedState(e.toString()));
    }

    try {
      await _exerciseRepository.markExerciseAsDone(id: id);
    } catch (e) {
      // Không làm gì nếu hàm phụ bị lỗi
      print('Error in marking exercise as done: $e');
    }
  }

  Future<void> markExerciseAsDone({required String id}) async {
    try {
      emit(MarkExerciseAsDoneLoadingState());
      final isMarked = await _exerciseRepository.markExerciseAsDone(id: id);
      if (isMarked) {
        emit(MarkExerciseAsDoneSuccessState());
      }
    } catch (e) {
      emit(MarkExerciseAsDoneFailedState(e.toString()));
    }
  }

  Future<void> getUserExerciseItem() async {
    try {
      emit(GetUserExerciseItemLoadingState());
      final userExerciseItems = await _exerciseRepository.getUserExerciseItem();
      emit(GetUserExerciseItemSuccessState(userExerciseItems));
    } catch (e) {
      emit(GetUserExerciseItemFailedState(e.toString()));
    }
  }
}
