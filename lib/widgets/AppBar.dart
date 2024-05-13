import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:badges/badges.dart' as badges;
import 'package:running_community_mobile/utils/app_shared.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? centerTitle;
  final double? elevation;
  final String? leadingIcon;
  final Color? leadingIconColor;
  final PreferredSize? bottom;
  final String? routeName;
  final Object? arguments;
  final bool isRefresh;
  const MyAppBar({
    super.key,
    required this.title,
    this.actions, this.automaticallyImplyLeading, this.backgroundColor, this.titleColor, this.centerTitle, this.elevation = 0, this.leadingIcon, this.leadingIconColor, this.bottom, this.routeName, this.arguments, this.isRefresh = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> defaultActions = [
      GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/notification'),
        child: badges.Badge(
          position: badges.BadgePosition.topEnd(top: -10, end: 10),
          badgeContent: StreamBuilder<int>(
            stream: watchCountNotify(),
            builder: (context, snapshot) {
              int value = snapshot.data ?? 0;
              if (value > 0) {
              return Text(value.toString(), style: secondaryTextStyle(size: 10, color: white),);
                
              }
              else{
        
                return const SizedBox.shrink();
              }
            }
          ),
          child: SvgPicture.asset(AppAssets.bell, color: gray, width: 16,).paddingSymmetric(horizontal: 16),
        ),
      ),
    ];

    // Kiểm tra nếu có actions được truyền vào từ ngoài
    if (actions != null) {
      // Thêm các actions truyền vào vào cuối danh sách các actions mặc định
      defaultActions.addAll(actions!);
    }
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      title: Text(title, style: const TextStyle(fontSize: 20),),
      actions: defaultActions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      titleTextStyle: TextStyle(color: titleColor ?? textPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold,),
      centerTitle: centerTitle ?? true,
      elevation: elevation,
      bottom: bottom,
      leading: leadingIcon != null ? SvgPicture.asset(leadingIcon!, color: leadingIconColor ?? textPrimaryColor).onTap(() {
        Navigator.pop(context, isRefresh);
      },).paddingSymmetric(vertical: 18).paddingLeft(16) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
