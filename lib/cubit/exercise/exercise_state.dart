import 'package:running_community_mobile/domain/models/exercises.dart';

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
