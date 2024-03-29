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
      final posts = await _postRepo.getPosts();
      emit(GetPostsSuccessState(posts));
    } catch (e) {
      emit(GetPostsFailedState(e.toString()));
    }
  }
}