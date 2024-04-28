import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/post/post_cubit.dart';
import 'package:running_community_mobile/cubit/post/post_state.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/screens/PostsScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key, required this.groupId});
  static const String routeName = '/create-post';
  final String groupId;

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  XFile? imageFile;
  TextEditingController contentController = TextEditingController();
  Future imageSelector(BuildContext context, String pickerType) async {
    final ImagePicker picker = ImagePicker();
    switch (pickerType) {
      case "gallery":

        /// GALLERY IMAGE PICKER
        imageFile = (await picker.pickImage(source: ImageSource.gallery, imageQuality: 90))!;
        break;

      case "camera": // CAMERA CAPTURE CODE
        imageFile = (await picker.pickImage(source: ImageSource.camera, imageQuality: 90))!;
        break;
    }

    if (imageFile != null) {
      print("You selected  image : ${imageFile!.path}");
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

  // Image picker
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  title: const Text('Gallery'),
                  onTap: () => {
                        imageSelector(context, "gallery"),
                        Navigator.pop(context),
                      }),
              ListTile(
                title: const Text('Camera'),
                onTap: () => {imageSelector(context, "camera"), Navigator.pop(context)},
              ),
            ],
          );
        });
  }

  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => PostCubit(),
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is CreatePostLoadingState) {
            showLoader(context);
            
          } else if (state is CreatePostSuccessState) {
            hideLoader(context);
            Fluttertoast.showToast(msg: 'Post success');
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, PostsScreen.routeName, arguments: widget.groupId);
          } else if (state is CreatePostFailedState) {
            hideLoader(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.replaceFirst('Exception: ', ''), style: primaryTextStyle(color: white),), backgroundColor: tomato,));
          }
        },
          builder:(context, state) => Scaffold(
            appBar: MyAppBar(
              title: 'Create Post',
              actions: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: contentController.text.isEmpty && imageFile == null ? gray.withOpacity(0.1) : primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Post', style: boldTextStyle(color: contentController.text.isEmpty && imageFile == null ? gray.withOpacity(0.5) : white),),
                ).onTap(() {
                  context.read<PostCubit>().createPost(groupId: widget.groupId, content: contentController.text, image: imageFile);
                }),
                Gap.k16.width,
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      UserRepo.user.avatarUrl != null ? ClipOval(
                        child: FadeInImage.assetNetwork(placeholder: AppAssets.user_placeholder, image: UserRepo.user.avatarUrl!, width: 40, height: 40, fit: BoxFit.cover,),
                      ) : Image.asset(AppAssets.user_placeholder, width: 40, height: 40, fit: BoxFit.cover),
                      Gap.k16.width,
                      Text(UserRepo.user.name!, style: boldTextStyle(size: 16)),
                    ],
                  ),
                  Gap.k16.height,
                  TextFormField(
                    onChanged: (value) => setState(() {}),
                    controller: contentController,
                    decoration: InputDecoration(
                      hintText: 'Write something here...',
                      hintStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: gray.withOpacity(0.1),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    maxLines: null,
                  ),
                  Gap.k16.height,
                  imageFile != null ? SizedBox(
                    width: context.width(),
                    height: context.width(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imageFile!.path),
                        width: context.width(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).onTap(() {
                    _settingModalBottomSheet(context);
                  }):
                  Stack(
                    children: [
                      Container(
                        width: context.width(),
                        height: context.width(),
                        decoration: BoxDecoration(
                          color: gray.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        )
                      ),
                      Positioned(
                        top: context.width() * 0.5 - 24,
                        right: context.width() * 0.5 - 36,
                        child: SvgPicture.asset(AppAssets.iamge, width: 48, height: 48, color: gray, fit: BoxFit.cover,),
                      ),
                    ],
                  ).onTap(() {
                    _settingModalBottomSheet(context);
                  }),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
            ),
          )
      ),
    );
  }
}