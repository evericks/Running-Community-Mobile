import 'package:running_community_mobile/domain/models/posts.dart';

class PostCommentState {}

class GetPostCommentLoadingState extends PostCommentState {}

class GetPostCommentSuccessState extends PostCommentState {
  final PostComment postComments;
  GetPostCommentSuccessState(this.postComments);
}

class GetPostCommentFailedState extends PostCommentState {
  final String error;
  GetPostCommentFailedState(this.error);
}

class CreatePostCommentLoadingState extends PostCommentState {}

class CreatePostCommentSuccessState extends PostCommentState {}

class CreatePostCommentFailedState extends PostCommentState {
  final String error;
  CreatePostCommentFailedState(this.error);
}
