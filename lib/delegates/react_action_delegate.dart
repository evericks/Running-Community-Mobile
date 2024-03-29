import 'package:running_community_mobile/cubit/postReact/postReact_cubit.dart';

import '../interfaces/react_action_interface.dart';

class PostReactActionDelegate implements ReactActionDelegate {
  final PostReactCubit postReactCubit;
  final String postId;

  PostReactActionDelegate(this.postReactCubit, this.postId);
  
  @override
  Stream<int> getReactsCount() {
    return Stream.fromFuture(postReactCubit.getPostReacts(postId: postId)).map((reacts) => reacts!.reacts!.length);
  }
  
  @override
  void onReact() {
    postReactCubit.createPostReact(postId: postId);
  }
  
  @override
  void onUnReact() {
    postReactCubit.deletePostReact(postId: postId);
  }
}