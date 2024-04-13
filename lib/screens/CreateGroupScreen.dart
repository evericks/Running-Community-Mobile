import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/screens/DashboardScreen.dart';
import 'package:running_community_mobile/utils/app_assets.dart';
import 'package:running_community_mobile/utils/colors.dart';

import '../cubit/group/group_cubit.dart';
import '../cubit/group/group_state.dart';
import '../utils/gap.dart';
import '../widgets/AppBar.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  static const routeName = '/create-group';

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  XFile? imageFile;
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController groupRuleController = TextEditingController();

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
    return Scaffold(
      appBar: const MyAppBar(title: 'New groups'),
      body: BlocProvider<GroupCubit>(
        create: (context) => GroupCubit(),
        child: BlocConsumer<GroupCubit, GroupState>(
          listener: (context, state) {
            if (state is GroupCreateLoadingState) {
              showLoader(context);
            }
            if (state is GroupCreateSuccessState) {
              if (state.status) {
                hideLoader(context);
                Fluttertoast.showToast(msg: 'Group created successfully');
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, DashboardScreen.routeName, arguments: 1);
              }
            }
          },
          builder: (context, state) => SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: context.width() * 9 / 16,
                    width: context.width(),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                    child: Center(
                      child: Stack(
                        children: [
                          imageFile == null
                              ? Image.asset(AppAssets.placeholder)
                              : Image.file(
                                  File(imageFile!.path),
                                  fit: BoxFit.cover,
                                  width: context.width(),
                                ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [const Icon(Icons.camera_alt, color: Colors.grey), Gap.k4.width, Text('Add photo', style: primaryTextStyle(color: Colors.grey))],
                            ),
                          )
                        ],
                      ),
                    ).onTap(() {
                      _settingModalBottomSheet(context);
                    })),
                Gap.k16.height,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                  child: TextField(
                    controller: groupNameController,
                    decoration: const InputDecoration(hintText: 'Group name', border: InputBorder.none),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Gap.k16.height,
                Container(
                  height: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                  child: TextField(
                    maxLines: null,
                    controller: groupDescriptionController,
                    decoration: const InputDecoration(hintText: 'Description', border: InputBorder.none),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Gap.k16.height,
                Container(
                  height: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                  child: TextField(
                    maxLines: null,
                    controller: groupRuleController,
                    decoration: const InputDecoration(hintText: 'Rule', border: InputBorder.none),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Gap.kSection.height,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: (groupNameController.text != '' && groupDescriptionController.text != '' && groupRuleController.text != '' && imageFile != null) ? primaryColor : white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: defaultBoxShadow()),
                  child: Text(
                    'Save group',
                    style: primaryTextStyle(color: (groupNameController.text != '' && groupDescriptionController.text != '' && groupRuleController.text != '' && imageFile != null) ? white : grey),
                  ),
                ).onTap(() async {
                  if (groupNameController.text != '' && groupDescriptionController.text != '' && groupRuleController.text != '' && imageFile != null) {
                    final GroupCubit groupCubit = context.read<GroupCubit>();
                    groupCubit.createGroup(
                      name: groupNameController.text,
                      description: groupDescriptionController.text,
                      rule: groupRuleController.text,
                      thumbnail: imageFile!,
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'Please login to join the tournament');
                  }
                }),
              ],
            ).paddingAll(32),
          ),
        ),
      ),
    );
  }
}
