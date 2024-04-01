import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/postReact_repo.dart';
import '../../utils/get_it.dart';
import 'postReact_state.dart';

class PostReactCubit extends Cubit<PostReactState> {
  PostReactCubit() : super(PostReactState());
  final PostReactRepo postReactRepo = getIt.get<PostReactRepo>();
  final StreamController<int> _reactsCountController = StreamController<int>();
  Stream<int> getReactsCount({required String postId}) {
    getPostReacts(postId: postId);
    return _reactsCountController.stream;
  }

  Future<int?> getPostReacts({String? postId, int? pageSize, int? pageNumber}) async {
    emit(GetPostReactsLoadingState());
    try {
      var reacts = await postReactRepo.getPostReacts(postId: postId, pageSize: pageSize, pageNumber: pageNumber);
      _reactsCountController.add(reacts.reacts!.length);
      emit(GetPostReactsSuccessState(reacts));
      return reacts.reacts!.length;
    } catch (e) {
      emit(GetPostReactsFailedState(e.toString()));
    }
    return null;
  }

  Future<void> createPostReact({required String postId}) async {
    // emit(CreatePostReactLoadingState());
    try {
      var react = await PostReactRepo().createPostReact(postId: postId);
      emit(CreatePostReactSuccessState(react));
      getPostReacts(postId: postId);
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
