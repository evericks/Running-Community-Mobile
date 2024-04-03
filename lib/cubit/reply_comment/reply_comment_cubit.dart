import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/comment_repo.dart';

import '../../utils/get_it.dart';
import 'reply_comment_state.dart';

class ReplyCommentReactCubit extends Cubit<ReplyCommentReactState>{
  ReplyCommentReactCubit() : super(ReplyCommentReactState());
  final PostCommentRepo _postCommentRepo = getIt.get<PostCommentRepo>();

  Future<void> createReplyCommentReact({required String replyCommentId}) async {
    try {
      emit(CreateReplyCommentReactLoadingState());
      await _postCommentRepo.createReplyCommentReact(replyCommentId: replyCommentId);
      emit(CreateReplyCommentReactSuccessState());
    } catch (e) {
      emit(CreateReplyCommentReactFailedState(e.toString()));
    }
  }

  Future<void> deleteReplyCommentReact({required String replyCommentId}) async {
    try {
      emit(DeleteReplyCommentReactLoadingState());
      await _postCommentRepo.deleteReplyCommentReact(replyCommentId: replyCommentId);
      emit(DeleteReplyCommentReactSuccessState());
    } catch (e) {
      emit(DeleteReplyCommentReactFailedState(e.toString()));
    }
  }
}