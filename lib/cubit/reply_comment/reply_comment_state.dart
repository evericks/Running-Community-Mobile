class ReplyCommentReactState{}

class CreateReplyCommentReactLoadingState extends ReplyCommentReactState{}

class CreateReplyCommentReactSuccessState extends ReplyCommentReactState{}

class CreateReplyCommentReactFailedState extends ReplyCommentReactState{
  final String error;
  CreateReplyCommentReactFailedState(this.error);
}

class DeleteReplyCommentReactLoadingState extends ReplyCommentReactState{}

class DeleteReplyCommentReactSuccessState extends ReplyCommentReactState{}

class DeleteReplyCommentReactFailedState extends ReplyCommentReactState{
  final String error;
  DeleteReplyCommentReactFailedState(this.error);
}