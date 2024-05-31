import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/domain/models/posts.dart';
import '../cubit/comment/comment_cubit.dart';
import '../cubit/comment/comment_state.dart';
import '../cubit/post/post_cubit.dart';
import '../cubit/post/post_state.dart';
import '../cubit/postReact/postReact_cubit.dart';
import '../delegates/react_action_delegate.dart';
import '../domain/repositories/user_repo.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';
import '../widgets/CommentWidget.dart';
import '../widgets/ReactWidget.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.postId});
  static const String routeName = '/post-detail';
  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  TextEditingController commentController = TextEditingController();
  PostComment? postCommentReply;
  @override
  Widget build(BuildContext context) {
    bool isReacted = false;
    return MultiBlocProvider(
       providers: [
            BlocProvider<PostCubit>(create: (context) => PostCubit()..getPostById(id: widget.postId)),
            BlocProvider<PostReactCubit>(create: (context) => PostReactCubit()),
            BlocProvider<PostCommentCubit>(create: (context) => PostCommentCubit()),
          ],
      child: Scaffold(
        appBar: const MyAppBar(
          title: '',
          leadingIcon: AppAssets.arrow_left,
          isRefresh: true,
        ),
        bottomNavigationBar: BlocProvider<PostCommentCubit>(
          create: (context) => PostCommentCubit(),
          child: BlocConsumer<PostCommentCubit, PostCommentState>(
            listener: (context, state) {
              if (state is CreatePostCommentLoadingState) {
                showBottomSheet(context: context, builder: ((context) => const CircularProgressIndicator()));
              }
              if (state is CreatePostCommentSuccessState) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(msg: 'Comment success');
                context.read<PostCubit>().getPostById(id: widget.postId);
                setState(() {});
              }
              if (state is CreateReplyCommentLoadingState) {
                showBottomSheet(context: context, builder: ((context) => const CircularProgressIndicator()));
              }
              if (state is CreateReplyCommentSuccessState) {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                Fluttertoast.showToast(msg: 'Reply comment success');
                context.read<PostCubit>().getPostById(id: widget.postId);
                setState(() {});
              }
            },
            builder: (context, state) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 8, // Thêm vào để tránh bàn phím
                left: 16.0,
                right: 16.0,
                top: 8.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: gray.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() {}),
                        controller: commentController,
                        decoration: InputDecoration(hintText: postCommentReply == null ? 'Write a comment...' : 'Write your answer to ${postCommentReply!.user!.name}', border: InputBorder.none, hintStyle: secondaryTextStyle()),
                      ),
                    ),
                    SvgPicture.asset(AppAssets.send, width: 24, height: 24, color: commentController.text != '' ? primaryColor : textPrimaryColor).onTap(() {
                      if (postCommentReply == null && commentController.text.isNotEmpty) {
                        context.read<PostCommentCubit>().createPostComment(postId: widget.postId, content: commentController.text);
                        commentController.clear();
                      } else if (postCommentReply != null && commentController.text.isNotEmpty) {
                        context.read<PostCommentCubit>().createReplyComment(commentId: postCommentReply!.id!, content: commentController.text);
                        commentController.clear();
                        setState(() {
                          postCommentReply = null;
                        });
                      }
                    }),
                  ],
                ).paddingRight(8),
              ),
            ),
          ),
        ),
        body: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          if (state is GetPostByIdLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetPostByIdSuccessState) {
            var post = state.post;
            isReacted = post.postReacts!.any((react) => react.user!.id == UserRepo.user.id);
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostCubit>().getPostById(id: widget.postId);
              },
              child: SingleChildScrollView(
                physics:  const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.content!, style: primaryTextStyle(size: 16)),
                    Gap.k8.height,
                    post.thumbnailUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage.assetNetwork(placeholder: AppAssets.placeholder, image: post.thumbnailUrl!, width: context.width(), height: context.width(), fit: BoxFit.cover))
                        : const SizedBox.shrink(),
                    Gap.k16.height,
                    Row(
                      children: [
                        ReactWidget(
                          delegate: PostReactActionDelegate(context.read<PostReactCubit>(), post.id!),
                          isReacted: isReacted,
                          ctt: context,
                        ),
                        Gap.k16.width,
                        SvgPicture.asset(
                          AppAssets.comment,
                          width: 20,
                          height: 20,
                          color: textPrimaryColor,
                        ),
                        Gap.k8.width,
                        Text(post.postComments!.length.toString(), style: secondaryTextStyle(size: 16)),
                      ],
                    ),
                    Gap.k16.height,
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: post.postComments!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Gap.k8.height,
                      itemBuilder: (context, index) => CommentWidget(postComment: post.postComments![index], onReply: () {
                        setState(() {
                          postCommentReply = post.postComments![index];
                        });
                      },),
                    )
                  ],
                ).paddingSymmetric(horizontal: 16, vertical: 8),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
