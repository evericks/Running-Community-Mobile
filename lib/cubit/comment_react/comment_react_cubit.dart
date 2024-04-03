import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/comment_repo.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import 'comment_react_state.dart';

class PostCommentReactCubit extends Cubit<PostCommentReactState>{
  PostCommentReactCubit() : super(PostCommentReactState());
  final PostCommentRepo _postCommentRepo = getIt.get<PostCommentRepo>();

  Future<void> createPostCommentReact({required String commentId}) async {
    emit(CreatePostCommentReactLoadingState());
    try {
      await _postCommentRepo.createPostCommentReact(commentId: commentId);
      emit(CreatePostCommentReactSuccessState());
    } catch (e) {
      emit(CreatePostCommentReactFailedState(e.toString()));
    }
  }

  Future<void> deletePostCommentReact({required String commentId}) async {
    emit(DeletePostCommentReactLoadingState());
    try {
      await _postCommentRepo.deletePostCommentReact(commentId: commentId);
      emit(DeletePostCommentReactSuccessState());
    } catch (e) {
      emit(DeletePostCommentReactFailedState(e.toString()));
    }
  }
}