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
