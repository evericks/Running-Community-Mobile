import 'package:running_community_mobile/domain/models/exercises.dart';

import '../../domain/models/user_exercise_item.dart';

class ExerciseState {}

class ExercisesLoadingState extends ExerciseState {}

class ExercisesSuccessState extends ExerciseState {
  final Exercises exercises;
  ExercisesSuccessState(this.exercises);
}

class ExercisesFailedState extends ExerciseState {
  final String error;
  ExercisesFailedState(this.error);
}

class GetExerciseByIdLoadingState extends ExerciseState {}

class GetExerciseByIdSuccessState extends ExerciseState {
  final Exercise exercise;
  GetExerciseByIdSuccessState(this.exercise);
}

class GetExerciseByIdFailedState extends ExerciseState {
  final String error;
  GetExerciseByIdFailedState(this.error);
}

class GetExerciseItemByIdLoadingState extends ExerciseState {}

class GetExerciseItemByIdSuccessState extends ExerciseState {
  final ExerciseItems exerciseItems;
  GetExerciseItemByIdSuccessState(this.exerciseItems);
}

class GetExerciseItemByIdFailedState extends ExerciseState {
  final String error;
  GetExerciseItemByIdFailedState(this.error);
}

class MarkExerciseAsDoneLoadingState extends ExerciseState {}

class MarkExerciseAsDoneSuccessState extends ExerciseState {}

class MarkExerciseAsDoneFailedState extends ExerciseState {
  final String error;
  MarkExerciseAsDoneFailedState(this.error);
}

class GetUserExerciseItemLoadingState extends ExerciseState {}

class GetUserExerciseItemSuccessState extends ExerciseState {
  final List<UserExerciseItem> userExerciseItems;
  GetUserExerciseItemSuccessState(this.userExerciseItems);
}

class GetUserExerciseItemFailedState extends ExerciseState {
  final String error;
  GetUserExerciseItemFailedState(this.error);
}
