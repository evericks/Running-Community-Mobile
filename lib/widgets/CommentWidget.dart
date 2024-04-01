import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../domain/models/posts.dart';
import '../utils/app_assets.dart';
import '../utils/gap.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.postComment,
  });

  final PostComment postComment;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  List<GlobalKey> replyCommentKeys = [];

  @override
  void initState() {
    super.initState();
    // Khởi tạo GlobalKey cho mỗi reply comment
    replyCommentKeys = List<GlobalKey>.generate(widget.postComment.replyComments!.length, (index) => GlobalKey());
  }

  @override
  Widget build(BuildContext context) {
    // print((replyCommentKeys.first.currentContext?.findRenderObject() as RenderBox?)!.localToGlobal(Offset.zero));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            ClipOval(
              child: FadeInImage.assetNetwork(placeholder: AppAssets.user_placeholder, image: widget.postComment.user!.avatarUrl!, width: 40, height: 40, fit: BoxFit.cover),
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
                    Text(widget.postComment.content!, style: primaryTextStyle(size: 16), maxLines: null,),
                  ],
                )),
            Row(children: [
              Text('Like', style: boldTextStyle(size: 12),),
              Gap.k8.width,
              Text('Reply', style: boldTextStyle(size: 12),),
            ],),
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
                          key: replyCommentKeys[index],
                          child: widget.postComment.replyComments![index].user!.avatarUrl != null
                              ? FadeInImage.assetNetwork(
                                  placeholder: AppAssets.user_placeholder, image: widget.postComment.replyComments![index].user!.avatarUrl!, width: 20, height: 20, fit: BoxFit.cover)
                              : Image.asset(AppAssets.user_placeholder, width: 20, height: 20, fit: BoxFit.cover),
                        ),
                        Gap.k8.width,
                        Column(
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
                                  Text(widget.postComment.replyComments![index].content!, style: primaryTextStyle(size: 16), maxLines: null,),
                                ],
                              ),
                            ),
                            Text('Like', style: boldTextStyle(size: 12),),
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
