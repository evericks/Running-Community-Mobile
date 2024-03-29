import 'package:running_community_mobile/domain/models/reacts.dart';

class PostReactState {}

class GetPostReactsLoadingState extends PostReactState {}

class GetPostReactsSuccessState extends PostReactState {
  final Reacts reacts;
  GetPostReactsSuccessState(this.reacts);
}

class GetPostReactsFailedState extends PostReactState {
  final String error;
  GetPostReactsFailedState(this.error);
}

class CreatePostReactLoadingState extends PostReactState {}

class CreatePostReactSuccessState extends PostReactState {
  final Reacts react;
  CreatePostReactSuccessState(this.react);
}

class CreatePostReactFailedState extends PostReactState {
  final String error;
  CreatePostReactFailedState(this.error);
}

class DeletePostReactLoadingState extends PostReactState {}

class DeletePostReactSuccessState extends PostReactState {
  final Reacts react;
  DeletePostReactSuccessState(this.react);
}

class DeletePostReactFailedState extends PostReactState {
  final String error;
  DeletePostReactFailedState(this.error);
}
