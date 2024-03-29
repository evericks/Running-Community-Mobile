import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/models/reacts.dart';

import '../../domain/repositories/postReact_repo.dart';
import '../../utils/get_it.dart';
import 'postReact_state.dart';

class PostReactCubit extends Cubit<PostReactState> {
  PostReactCubit() : super(PostReactState());
  final PostReactRepo postReactRepo = getIt.get<PostReactRepo>();

  Future<Reacts?> getPostReacts({String? postId, int? pageSize, int? pageNumber}) async {
    emit(GetPostReactsLoadingState());
    try {
      var reacts = await postReactRepo.getPostReacts(postId: postId, pageSize: pageSize, pageNumber: pageNumber);
      emit(GetPostReactsSuccessState(reacts));
      return reacts;
    } catch (e) {
      emit(GetPostReactsFailedState(e.toString()));
    }
  }

  Future<void> createPostReact({required String postId}) async {
    // emit(CreatePostReactLoadingState());
    try {
      var react = await PostReactRepo().createPostReact(postId: postId);
      emit(CreatePostReactSuccessState(react));
    } catch (e) {
      emit(CreatePostReactFailedState(e.toString()));
    }
  }

  Future<void> deletePostReact({required String postId}) async {
    // emit(DeletePostReactLoadingState());
    try {
      var react = await PostReactRepo().deletePostReact(postId: postId);
      emit(DeletePostReactSuccessState(react));
    } catch (e) {
      emit(DeletePostReactFailedState(e.toString()));
    }
  }
}
