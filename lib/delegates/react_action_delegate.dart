import 'package:running_community_mobile/cubit/postReact/postReact_cubit.dart';

import '../interfaces/react_action_interface.dart';

class PostReactActionDelegate implements ReactActionInterface{
  final PostReactCubit postReactCubit;
  final String postId;

  PostReactActionDelegate(this.postReactCubit, this.postId);
  
  // @override
  // Stream<int> getReactsCount() {
  //   return postReactCubit.getReactsCount(postId: postId);
  // }

    @override
  Future<int?> getReactsCount() {
    return postReactCubit.getPostReacts(postId: postId);
  }
  
  
  @override
  Future<void> onReact() async {
    postReactCubit.createPostReact(postId: postId);
  }
  
  @override
  Future<void> onUnReact() async {
    postReactCubit.deletePostReact(postId: postId);
  }
}

// class CommentReactActionDelegate implements ReactActionInterface{
//   final CommentReactCubit commentReactCubit;
//   final String commentId;

//   CommentReactActionDelegate({required this.commentReactCubit, required this.commentId});
//   @override
//   Stream<int> getReactsCount() {
//     // TODO: implement getReactsCount
//     throw UnimplementedError();
//   }

//   @override
//   void onReact() {
//     // TODO: implement onReact
//   }

//   @override
//   void onUnReact() {
//     // TODO: implement onUnReact
//   }
  
// }