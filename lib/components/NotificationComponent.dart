import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/group/group_cubit.dart';
import '../cubit/notification/notification_cubit.dart';
import '../domain/models/notifications.dart';
import '../screens/GroupDetailScreen.dart';
import '../screens/PostDetailScreen.dart';
import '../utils/app_assets.dart';
import '../utils/colors.dart';
import '../utils/gap.dart';

class NotificationComponent extends StatefulWidget {
  const NotificationComponent({
    super.key,
    required this.notification,
  });

  final NotificationItem notification;

  @override
  State<NotificationComponent> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  Map<String, String> notificationIcon = {
    'POST': AppAssets.interact_post,
    'GROUP': AppAssets.join,
    'TOURNAMENT': AppAssets.tournament,
  };
  String? memId;
  NotificationItem? notification;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    notification = widget.notification;
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupCubit>(
          create: (context) => GroupCubit()..getGroupById(widget.notification.link!),
        ),
        BlocProvider<MarkAsReadNotificationCubit>(
          create: (context) => MarkAsReadNotificationCubit(),
        ),
        BlocProvider<NotificationCubit>(create: (context) => NotificationCubit()),
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: notification!.isRead! ? white : primaryColor.withOpacity(0.1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              notificationIcon[notification!.type!]!,
              width: 50,
              height: 50,
            ),
            Gap.k16.width,
            SizedBox(
                width: context.width() * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification!.title!,
                      style: primaryTextStyle(size: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap.k4.height,
                    Text(
                      notification!.message!,
                      style: secondaryTextStyle(size: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
          ],
        ),
      ).onTap(() async {
        await context.read<MarkAsReadNotificationCubit>().markAsRead(notificationId: notification!.id!);
        setState(() {
          notification!.isRead = true;
        });
        if (notification!.type == 'POST') {
          Navigator.pushNamed(context, PostDetailScreen.routeName, arguments: notification!.link);
        } else if (notification!.type == 'TOURNAMENT') {
          // Navigator.pushNamed(context, TournamentDetailScreen.routeName, arguments: notification!.tournamentId);
        } else if (notification!.type == 'GROUP') {
          Navigator.pushNamed(context, GroupDetailScreen.routeName, arguments: notification!.link);
        }
      }),
    );
  }
}
