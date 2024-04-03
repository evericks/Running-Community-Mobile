import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/post_repo.dart';
import '../../utils/get_it.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState>{
  PostCubit() : super(PostState());
  final PostRepo _postRepo = getIt.get<PostRepo>();

  Future<void> getPosts({String? content, String? creatorId, String? groupId, int? pageSize, int? pageNumber}) async {
    emit(GetPostsLoadingState());
    try {
      final posts = await _postRepo.getPosts(content: content, creatorId: creatorId, groupId: groupId, pageSize: pageSize, pageNumber: pageNumber);
      emit(GetPostsSuccessState(posts));
    } catch (e) {
      emit(GetPostsFailedState(e.toString()));
    }
  }

  Future<void> getPostById({required String id}) async {
    emit(GetPostByIdLoadingState());
    try {
      final post = await _postRepo.getPostById(postId: id);
      emit(GetPostByIdSuccessState(post));
    } catch (e) {
      emit(GetPostByIdFailedState(e.toString()));
    }
  }

  Future<void> createPost({required String groupId, String? content, XFile? image }) async {
    emit(CreatePostLoadingState());
    try {
      await _postRepo.createPost(groupId: groupId, content: content, image: image);
      emit(CreatePostSuccessState());
    } catch (e) {
      emit(CreatePostFailedState(e.toString()));
    }
  }
}