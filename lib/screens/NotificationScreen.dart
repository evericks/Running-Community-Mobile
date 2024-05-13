import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/notification/notification_cubit.dart';
import 'package:running_community_mobile/cubit/notification/notification_state.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/notification';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, String> notificationIcon = {
    'Post': AppAssets.interact_post,
    'Tournament': AppAssets.tournament,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(fontSize: 20),
        ),
        leading: Icon(Icons.arrow_back),
        centerTitle: true,
      ),
      body: BlocProvider<NotificationCubit>(
        create: (context) => NotificationCubit()..getNotifications(),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotificationSuccessState) {
              var notifications = state.notifications.notifications;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications!.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                      color: primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          notificationIcon[notifications[index].type!]!,
                          width: 50,
                          height: 50,
                        ),
                        Gap.k16.width,
                        Column(
                          children: [
                            Text(notifications[index].title!, style: boldTextStyle(),),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
