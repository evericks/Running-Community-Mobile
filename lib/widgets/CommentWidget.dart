import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/comment_react/comment_react_cubit.dart';
import 'package:running_community_mobile/cubit/comment_react/comment_react_state.dart';
import 'package:running_community_mobile/cubit/reply_comment/reply_comment_cubit.dart';
import 'package:running_community_mobile/cubit/reply_comment/reply_comment_state.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';

import '../domain/models/posts.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.postComment, required this.onReply,
  });

  final PostComment postComment;
  final VoidCallback onReply;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  // List<GlobalKey> replyCommentKeys = [];
  PostComment? comments;
  bool isReacted = false;

  @override
  void initState() {
    comments = widget.postComment;
    super.initState();
    // Khởi tạo GlobalKey cho mỗi reply comment
    // replyCommentKeys = List<GlobalKey>.generate(widget.postComment.replyComments!.length, (index) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    // print((replyCommentKeys.first.currentContext?.findRenderObject() as RenderBox?)!.localToGlobal(Offset.zero));
    isReacted = comments!.postCommentReacts!.any((rcreact) => rcreact.user!.id == UserRepo.user.id);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            widget.postComment.user!.avatarUrl != null ? ClipOval(
              child: FadeInImage.assetNetwork(placeholder: AppAssets.user_placeholder, image: widget.postComment.user!.avatarUrl!, width: 40, height: 40, fit: BoxFit.cover),
            ) : ClipOval(
              child: Image.asset(AppAssets.user_placeholder, width: 40, height: 40, fit: BoxFit.cover),
            ),
            // Gap.k8.height,
            // CustomPaint(
            //   size: const Size(40, 40),
            //   painter: CommentTreePainter(),
            // ),
          ],
        ),
        Gap.k8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: grey.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.postComment.user!.name!, style: boldTextStyle(size: 14)),
                    // Gap.k8.height,
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: context.width() * 0.7),
                      child: Text(
                        widget.postComment.content!,
                        style: primaryTextStyle(size: 16),
                        maxLines: null,
                      ),
                    ),
                  ],
                )),
            MultiBlocProvider(
              providers: [
                BlocProvider<PostCommentReactCubit>(
                  create: (context) => PostCommentReactCubit(),
                )
              ],
              child: Row(
                children: [
                  BlocConsumer<PostCommentReactCubit, PostCommentReactState>(
                    listener: (contextm, state) {
                      if (state is CreatePostCommentReactSuccessState) {
                        setState(() {
                          comments!.postCommentReacts!.add(PostCommentReacts(user: UserRepo.user));
                        });
                      }
                      if (state is DeletePostCommentReactSuccessState) {
                        setState(() {
                          comments!.postCommentReacts!.removeWhere((rcreact) => rcreact.user!.id == UserRepo.user.id);
                        });
                      }
                    },
                    builder: (context, state) => Row(
                      children: [
                        Text(
                          comments != null ? comments!.postCommentReacts!.length.toString() : widget.postComment.postCommentReacts!.length.toString(),
                          style: secondaryTextStyle(size: 12),
                        ),
                        Gap.k4.width,
                        Text(
                          'Like',
                          style: boldTextStyle(
                              size: 12,
                              color: comments != null
                                  ? (comments!.postCommentReacts!.any((rcreact) => rcreact.user!.id == UserRepo.user.id) ? primaryColor : null)
                                  : (widget.postComment.postCommentReacts!.any((rcreact) => rcreact.user!.id == UserRepo.user.id) ? primaryColor : null)),
                        ).onTap(() {
                          isReacted
                              ? context.read<PostCommentReactCubit>().deletePostCommentReact(commentId: comments != null ? comments!.id! : widget.postComment.id!)
                              : context.read<PostCommentReactCubit>().createPostCommentReact(commentId: comments != null ? comments!.id! : widget.postComment.id!);
                        }),
                      ],
                    ),
                  ),
                  Gap.k16.width,
                  Text(
                    'Reply',
                    style: boldTextStyle(
                      size: 12,
                    ),
                  ).onTap(widget.onReply),
                ],
              ),
            ),
            Gap.k8.height,
            widget.postComment.replyComments!.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.postComment.replyComments!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Gap.k8.height,
                    itemBuilder: (context, index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                          // key: replyCommentKeys[index],
                          child: widget.postComment.replyComments![index].user!.avatarUrl != null
                              ? FadeInImage.assetNetwork(
                                  placeholder: AppAssets.user_placeholder, image: widget.postComment.replyComments![index].user!.avatarUrl!, width: 20, height: 20, fit: BoxFit.cover)
                              : Image.asset(AppAssets.user_placeholder, width: 20, height: 20, fit: BoxFit.cover),
                        ),
                        Gap.k8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: grey.withOpacity(0.1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.postComment.replyComments![index].user!.name!, style: boldTextStyle(size: 14)),
                                  // Gap.k8.height,
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: context.width() * 0.6),
                                    child: Text(
                                      widget.postComment.replyComments![index].content!,
                                      style: primaryTextStyle(size: 16),
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocProvider<ReplyCommentReactCubit>(
                              create: (context) => ReplyCommentReactCubit(),
                              child: BlocConsumer<ReplyCommentReactCubit, ReplyCommentReactState>(
                                listener: (context, state) {
                                  if (state is CreateReplyCommentReactSuccessState) {
                                    setState(() {
                                      widget.postComment.replyComments![index].replyCommentReacts!.add(ReplyCommentReacts(userId: UserRepo.user.id));
                                    });
                                  }
                                  if (state is DeleteReplyCommentReactSuccessState) {
                                    setState(() {
                                      widget.postComment.replyComments![index].replyCommentReacts!.removeWhere((rcreact) => rcreact.userId == UserRepo.user.id);
                                    });
                                    
                                  }
                                },
                                builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.postComment.replyComments![index].replyCommentReacts!.length.toString(),
                                      style: secondaryTextStyle(size: 12),
                                    ),
                                    Gap.k4.width,
                                    Text(
                                      'Like',
                                      style: boldTextStyle(size: 12, color: widget.postComment.replyComments![index].replyCommentReacts!.any((rcreact) => rcreact.userId == UserRepo.user.id) ? primaryColor : null,)
                                    ).onTap((){
                                      widget.postComment.replyComments![index].replyCommentReacts!.any((rcreact) => rcreact.userId == UserRepo.user.id) ? context.read<ReplyCommentReactCubit>().deleteReplyCommentReact(replyCommentId: widget.postComment.replyComments![index].id!) :
                                      context.read<ReplyCommentReactCubit>().createReplyCommentReact(replyCommentId: widget.postComment.replyComments![index].id!);                                    
                                    }),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ).expand(),
      ],
    );
  }
}

// class CommentTreePainter extends CustomPainter {
//   final GlobalKey avatarKey;

//   CommentTreePainter({required this.avatarKey});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Paint setup
//     final paint = Paint()
//       ..color = Colors.grey.withOpacity(0.5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;

//     Offset avatarPosition = Offset(size.width / 2, size.height);
//     // Sử dụng GlobalKey để lấy RenderBox của avatar
//     final RenderBox? renderBox = avatarKey.currentContext?.findRenderObject() as RenderBox?;
//     // Lấy vị trí global của avatar
//     if (renderBox != null) {
//       avatarPosition = renderBox.localToGlobal(Offset.zero);
//       // Tính toán Offset tương đối so với vị trí của CustomPaint
//       final RenderBox? painterBox = avatarKey.currentContext?.findAncestorRenderObjectOfType<RenderBox>();
//       if (painterBox != null) {
//         avatarPosition = painterBox.globalToLocal(avatarPosition);
//       }
//     }

//     // Nếu không lấy được vị trí (do renderBox là null), sử dụng một giá trị mặc định
//     avatarPosition = avatarPosition ?? Offset(size.width / 2, size.height);

//     // Vẽ đường từ trên xuống dưới, rồi bo cong vào avatar
//     final Path path = Path();
//     path.moveTo(size.width / 2, 0); // Bắt đầu từ giữa trên cùng của CustomPaint
//     path.lineTo(size.width / 2, avatarPosition.dy - 20); // Đi thẳng xuống một chút trước avatar

//     // Tạo đường cong từ điểm hiện tại tới vị trí avatar
//     path.quadraticBezierTo(
//       size.width / 2, avatarPosition.dy, // Điểm control của Bezier curve
//       avatarPosition.dx, avatarPosition.dy, // Điểm kết thúc của Bezier curve
//     );

//     // Vẽ đường dẫn trên canvas
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class DotPainter extends CustomPainter {
//   final Offset dotPosition;
//   final double dotRadius;
//   final Color dotColor;

//   DotPainter({required this.dotPosition, this.dotRadius = 4.0, this.dotColor = Colors.red});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = dotColor
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(dotPosition, dotRadius, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }




// class CommentTreePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = gray.withOpacity(0.5) // Màu của đường
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2; // Độ rộng của đường

//     // Tạo một đường path
//     Path path = Path();
//     path.moveTo(size.width / 2, 0); // Điểm bắt đầu ở giữa đầu widget
//     path.lineTo(size.width / 2, size.height - 20); // Vẽ xuống dưới cùng trừ một khoảng để bo cong

//     // Bo cong về phải
//     path.quadraticBezierTo(size.width / 2, size.height, size.width / 2 + 20, size.height);

//     // Vẽ path trên canvas
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
