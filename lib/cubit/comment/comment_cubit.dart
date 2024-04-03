import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/comment_repo.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import 'comment_state.dart';

class PostCommentCubit extends Cubit<PostCommentState>{
  PostCommentCubit() : super(PostCommentState());
  final PostCommentRepo postCommentRepo = getIt.get<PostCommentRepo>();

  Future<void> getPostComments({String? postId, int? pageSize, int? pageNumber}) async {
    emit(GetPostCommentLoadingState());
    try {
      var postComments = await postCommentRepo.getPostCommentById(postId: postId, pageSize: pageSize, pageNumber: pageNumber);
      emit(GetPostCommentSuccessState(postComments));
    } catch (e) {
      emit(GetPostCommentFailedState(e.toString()));
    }
  }

  Future<void> createPostComment({required String postId, required String content}) async {
    emit(CreatePostCommentLoadingState());
    try {
      await postCommentRepo.createPostComment(postId: postId, content: content);
      emit(CreatePostCommentSuccessState());
    } catch (e) {
      emit(CreatePostCommentFailedState(e.toString()));
    }
  }

  Future<void> createReplyComment({required String commentId, required String content}) async {
    emit(CreateReplyCommentLoadingState());
    try {
      await postCommentRepo.createReplyComment(commentId: commentId, content: content);
      emit(CreateReplyCommentSuccessState());
    } catch (e) {
      emit(CreateReplyCommentFailedState(e.toString()));
    }
  }
}