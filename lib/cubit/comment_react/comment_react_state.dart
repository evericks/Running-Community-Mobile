import '../../domain/models/reacts.dart';

class CommentReactState {}

class CommentReactLoadingState extends CommentReactState {}

class CommentReactSuccessState extends CommentReactState {
  final Reacts react;
  CommentReactSuccessState(this.react);
}

class CommentReactFailedState extends CommentReactState {
  final String error;
  CommentReactFailedState(this.error);
}
