import 'package:running_community_mobile/domain/models/posts.dart';

class PostState {}

class GetPostsLoadingState extends PostState {}

class GetPostsSuccessState extends PostState {
  final Posts posts;
  GetPostsSuccessState(this.posts);
}

class GetPostsFailedState extends PostState {
  final String error;
  GetPostsFailedState(this.error);
}

class GetPostByIdLoadingState extends PostState {}

class GetPostByIdSuccessState extends PostState {
  final Post post;
  GetPostByIdSuccessState(this.post);
}

class GetPostByIdFailedState extends PostState {
  final String error;
  GetPostByIdFailedState(this.error);
}

class CreatePostLoadingState extends PostState {}

class CreatePostSuccessState extends PostState {}

class CreatePostFailedState extends PostState {
  final String error;
  CreatePostFailedState(this.error);
}