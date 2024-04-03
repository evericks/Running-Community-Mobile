import '../../domain/models/reacts.dart';

class PostCommentReactState {}

class CommentReactLoadingState extends PostCommentReactState {}

class CommentReactSuccessState extends PostCommentReactState {
  final Reacts react;
  CommentReactSuccessState(this.react);
}

class CommentReactFailedState extends PostCommentReactState {
  final String error;
  CommentReactFailedState(this.error);
}

class CreatePostCommentReactLoadingState extends PostCommentReactState {}
  
class CreatePostCommentReactSuccessState extends PostCommentReactState {}

class CreatePostCommentReactFailedState extends PostCommentReactState {
  final String error;
  CreatePostCommentReactFailedState(this.error);
}

class DeletePostCommentReactLoadingState extends PostCommentReactState {}

class DeletePostCommentReactSuccessState extends PostCommentReactState {}

class DeletePostCommentReactFailedState extends PostCommentReactState {
  final String error;
  DeletePostCommentReactFailedState(this.error);
}