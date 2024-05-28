import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:running_community_mobile/cubit/user/user_cubit.dart';
import 'package:running_community_mobile/cubit/user/user_state.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';
import 'package:running_community_mobile/utils/gap.dart';
import 'package:running_community_mobile/widgets/AppBar.dart';

import '../utils/app_assets.dart';
import '../widgets/Button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String routeName = '/edit_profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _selectedGender;
  XFile? _imageFile;
  DateTime? _selectedDate;

  Future imageSelector(BuildContext context, String pickerType) async {
    final ImagePicker picker = ImagePicker();
    switch (pickerType) {
      case "gallery":

        /// GALLERY IMAGE PICKER
        _imageFile = (await picker.pickImage(source: ImageSource.gallery, imageQuality: 90))!;
        break;

      case "camera": // CAMERA CAPTURE CODE
        _imageFile = (await picker.pickImage(source: ImageSource.camera, imageQuality: 90))!;
        break;
    }

    if (_imageFile != null) {
      print("You selected  image : ${_imageFile!.path}");
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $_imageFile");
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
      appBar: const MyAppBar(title: 'Edit Profile'),
      body: BlocProvider<UserCubit>(
        create: (context) => UserCubit(),
        child: BlocConsumer<UserCubit, UserState>(listener: (context, state) {
          if (state is UpdateProfileLoadingState) {
            showLoader(context);
          } else if (state is UpdateProfileSuccessState) {
            hideLoader(context);
            toast('Update profile successfully');
            context.pop(true);
          } else if (state is UpdateProfileFailedState) {
            hideLoader(context);
            toast(state.error.replaceAll('Exception: ', ''));
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: _imageFile != null
                          ? Image.file(
                              File(_imageFile!.path),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : UserRepo.user.avatarUrl != null
                              ? FadeInImage.assetNetwork(placeholder: AppAssets.user_placeholder, image: UserRepo.user.avatarUrl!, width: 150, height: 150, fit: BoxFit.cover)
                              : Image.asset(AppAssets.user_placeholder, width: 150, height: 150, fit: BoxFit.cover),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                            onTap: () {
                              _settingModalBottomSheet(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: white),
                                width: 40,
                                height: 40,
                                child: Transform.scale(
                                  scale: 0.5,
                                  child: SvgPicture.asset(AppAssets.camera, color: gray),
                                )))),
                  ],
                ),
                Gap.k16.height,
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _nameController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                        hintText: UserRepo.user.name ?? 'Name',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintStyle: secondaryTextStyle()),
                  ).paddingOnly(left: 16),
                ),
                Gap.k16.height,
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _addressController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                        hintText: UserRepo.user.address ?? 'Address',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintStyle: secondaryTextStyle()),
                  ).paddingOnly(left: 16),
                ),
                Gap.k16.height,
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Text(
                              _selectedDate != null
                                  ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                                  : UserRepo.user.dateOfBirth != null
                                      ? DateFormat('dd/MM/yyyy').format(DateTime.parse(UserRepo.user.dateOfBirth!))
                                      : 'Date of birth (*)',
                              style: secondaryTextStyle())
                          .paddingOnly(left: 16),
                      const Spacer(),
                      SvgPicture.asset(
                        AppAssets.calendar,
                        width: 24,
                        height: 24,
                        color: gray,
                      ).paddingOnly(right: 16),
                    ],
                  ),
                ).onTap(() {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((value) => setState(() {
                        _selectedDate = value;
                      }));
                }),
                Gap.k16.height,
                Container(
                  width: context.width(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    items: ['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    value: _selectedGender,
                    hint: Text(
                      'Gender',
                      style: primaryTextStyle(color: gray),
                    ),
                  )),
                ),
                Gap.k16.height,
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _newPasswordController,
                    onChanged: (value) => setState(() {}),
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'New Password',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintStyle: secondaryTextStyle()),
                  ).paddingOnly(left: 16),
                ),
                Gap.k16.height,
                Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    onChanged: (value) => setState(() {}),
                    obscureText: true,
                    readOnly: _newPasswordController.text.isEmpty,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        // contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintStyle: secondaryTextStyle()),
                  ).paddingOnly(left: 16),
                ),
                Gap.k4.height,
                Text('Confirm passwords do not match', style: secondaryTextStyle(size: 12, color: redColor))
                    .visible(_confirmPasswordController.text.isNotEmpty && _newPasswordController.text.isNotEmpty && _newPasswordController.text != _confirmPasswordController.text),
                Gap.k16.height,
                Text('Fill in any information you want to update', style: secondaryTextStyle(size: 12)),
                Gap.k16.height,
                Button(
                    title: 'Save',
                    isActive: true,
                    onPressed: () {
                      if (_newPasswordController.text.isNotEmpty && _newPasswordController.text != _confirmPasswordController.text) {
                        toast('Confirm passwords do not match');
                        return;
                      } else {
                        context.read<UserCubit>().updateProfile(
                            id: UserRepo.user.id!, name: _nameController.text, address: _addressController.text, avatar: _imageFile, dob: _selectedDate, password: _newPasswordController.text, gender: _selectedGender);
                      }
                    }).paddingSymmetric(horizontal: 32),
              ],
            ).paddingSymmetric(horizontal: 16),
          );
        }),
      ),
    );
  }
}
