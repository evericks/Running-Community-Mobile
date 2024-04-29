import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/group/group_cubit.dart';
import 'package:running_community_mobile/cubit/group/group_state.dart';
import 'package:running_community_mobile/cubit/post/post_state.dart';
import 'package:running_community_mobile/cubit/postReact/postReact_cubit.dart';
import 'package:running_community_mobile/domain/models/groups.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/screens/CreatePostScreen.dart';
import 'package:running_community_mobile/screens/GroupDetailScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../cubit/post/post_cubit.dart';
import '../delegates/react_action_delegate.dart';
import '../widgets/ReactWidget.dart';
import 'PostDetailScreen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, required this.groupId});
  static const String routeName = '/posts';
  final String groupId;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  String? time = null;
  Group? group;
  String? role;
  bool isLiked = false;
  int likeCount = 0;
  String? memStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Posts',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info,
              color: textPrimaryColor,
            ),
            onPressed: () {
              Navigator.pushNamed(context, GroupDetailScreen.routeName, arguments: widget.groupId);
            },
          ),
        ],
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider<GroupCubit>(create: (context) => GroupCubit()..getGroupById(widget.groupId)),
            BlocProvider<PostCubit>(create: (context) => PostCubit()..getPosts(groupId: widget.groupId)),
            BlocProvider<PostReactCubit>(create: (context) => PostReactCubit())
          ],
          // child: BlocListener<GroupCubit, GroupState>(
          //   listener: (context, state) {
          //     if (state is GetGroupSuccessState) {
          //       setState(() {
          //         group = state.group;
          //         role = group!.groupMembers!.firstWhere((mem) => mem.user!.id == UserRepo.user.id).role;
          //       });
          //     }
          //   },
          child: BlocBuilder<GroupCubit, GroupState>(builder: (context, state) {
            if (state is GetGroupSuccessState) {
              group = state.group;
              role = group!.groupMembers!.firstWhere((mem) => mem.user!.id == UserRepo.user.id).role;
              memStatus = group!.groupMembers!.firstWhere((mem) => mem.user!.id == UserRepo.user.id).status;
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostCubit>().getPosts(groupId: widget.groupId);
              },
              child: memStatus == 'Active' ? SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    role == 'Owner'
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  UserRepo.user.avatarUrl != null ? ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      placeholder: AppAssets.user_placeholder,
                                      image: UserRepo.user.avatarUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ) : Image.asset(
                                    AppAssets.user_placeholder,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  Gap.k16.width,
                                  Text('Write something on your group',
                                      style: secondaryTextStyle(
                                        size: 16,
                                      )),
                                  // const Spacer(),
                                  // SvgPicture.asset(
                                  //   AppAssets.ellipsis,
                                  //   width: 20,
                                  //   height: 20,
                                  // ).onTap(() {
                                  //   showModalBottomSheet(
                                  //       context: context,
                                  //       builder: (context) => Wrap(children: [
                                  //             Row(
                                  //               children: [
                                  //                 SvgPicture.asset(AppAssets.location_dot, width: 20, height: 20, color: tomato,),
                                  //                 Gap.k8.width,
                                  //                 Text('Location'),
                                  //               ],
                                  //             ).onTap((){}),
                                  //             Divider(),
                                  //             Row(
                                  //               children: [
                                  //                 SvgPicture.asset(AppAssets.calendar, width: 20, height: 20, color: seaGreen,),
                                  //                 Gap.k8.width,
                                  //                 Text('Time'),
                                  //               ],
                                  //             ).onTap((){
                                  //               showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)), initialDate: DateTime.now()).then((value) {
                                  //                 if (value != null) {
                                  //                       setState(() {
                                  //                         time = DateFormat('dd/MM/yyyy').format(value).toString();
                                  //                       });
                                  //                 }
                                  //               });
                                  //             }),
                                  //           ]).paddingSymmetric(horizontal: 16, vertical: 32));
                                  // }),
                                ],
                              ).paddingSymmetric(horizontal: 16).onTap(
                                    () => Navigator.pushNamed(context, CreatePostScreen.routeName, arguments: widget.groupId),
                                  ),
                              const Divider(),
                            ],
                          )
                        : const SizedBox.shrink(),
                    BlocBuilder<PostCubit, PostState>(builder: (context, state) {
                      if (state is GetPostsLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetPostsSuccessState) {
                        var posts = state.posts.posts;
                        isLiked = posts!.any((post) => post.postReacts!.any((react) => react.user!.id == UserRepo.user.id));
                        return posts.isNotEmpty ? Column(
                          children: [
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          ClipOval(
                                            child: posts[index].creator!.avatarUrl != null
                                                ? FadeInImage.assetNetwork(
                                                    placeholder: AppAssets.user_placeholder,
                                                    image: posts[index].creator!.avatarUrl!,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    AppAssets.user_placeholder,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          Gap.k16.width,
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(posts[index].creator!.name!, style: boldTextStyle(size: 16)),
                                              Text(
                                                DateTime.now().difference(DateTime.parse(posts[index].createAt!)).inMinutes < 60
                                                    ? 'Recently'
                                                    : DateTime.now().difference(DateTime.parse(posts[index].createAt!)).inHours < 24
                                                        ? '${DateTime.now().difference(DateTime.parse(posts[index].createAt!)).inHours} hours'
                                                        : DateFormat('dd-MM-yyyy').format(DateTime.parse(posts[index].createAt!)),
                                                style: secondaryTextStyle(size: 14),
                                              )
                                            ],
                                          ),
                                        ]),
                                        Gap.k16.height,
                                        Text(posts[index].content!, style: primaryTextStyle(size: 16)),
                                        Gap.k8.height,
                                        posts[index].thumbnailUrl != null
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: FadeInImage.assetNetwork(
                                                    placeholder: AppAssets.placeholder, image: posts[index].thumbnailUrl!, width: context.width(), height: context.width(), fit: BoxFit.cover))
                                            : const SizedBox.shrink(),
                                        Gap.k16.height,
                                        Row(
                                          children: [
                                            ReactWidget(
                                              delegate: PostReactActionDelegate(context.read<PostReactCubit>(), posts[index].id!),
                                              isReacted: posts[index].postReacts!.any((react) => react.user!.id == UserRepo.user.id),
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
                                            Text(posts[index].postComments!.length.toString(), style: secondaryTextStyle(size: 16)),
                                          ],
                                        ),
                                      ],
                                    ).paddingSymmetric(horizontal: 16).onTap(() async {
                                      var result = await Navigator.pushNamed(context, PostDetailScreen.routeName, arguments: posts[index].id);
                                      if (result == true) {
                                        // ignore: use_build_context_synchronously
                                        context.read<PostCubit>().getPosts(groupId: widget.groupId);
                                      }
                                    }),
                                separatorBuilder: (context, index) => const Divider(
                                      thickness: 4,
                                    ),
                                itemCount: posts.length),
                          ],
                        ) : Center(child: Text('No posts yet', style: secondaryTextStyle(),));
                      }
                      return const SizedBox.shrink();
                    })
                  ],
                ),
              ) : Center(
                child: Text('You currently cannot access this group', style: boldTextStyle(size: 16)),
              ),
            );
          })),
    );
  }
}
