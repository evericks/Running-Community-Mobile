

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String thumbnailUrl;
  final VoidCallback? onPressed;
  final String? textButton;
  final BuildContext context;


  const CustomSliverAppBarDelegate({required this.thumbnailUrl, this.onPressed, this.textButton, required this.context,
    required this.expandedHeight,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        buildBackground(shrinkOffset),
        // if (UserRole.Traveler.compareWithString(UserRepo.profile!.role))
          // Positioned(
          //   top: top,
          //   left: 0,
          //   right: 0,
          //   child: buildFloating(context, shrinkOffset),
          // ),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        // ignore: unnecessary_null_comparison
        child: thumbnailUrl != null
            ? Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: FadeInImage.assetNetwork(
                    placeholder: AppAssets.placeholder,
                    image: thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                     borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                  ),
                ),
                // Positioned(top: 32, left: 0,child: SvgPicture.asset(AppAssets.arrow_left, color: textPrimaryColor, height: 24, width: 24).paddingAll(16),),
              ],
            )
            : const SizedBox.shrink(),
      );

  Widget buildFloating(BuildContext context, double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: primaryColor,
                ),
                onPressed: onPressed,
                child: Text(textButton!, style: boldTextStyle(color: white),),
              ),
            ),
          ),
        
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
