import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/model/user.dart';
import '../../../core/widget/cache_image.dart';
import '../cubit/image/user_image_cubit.dart';
import '../cubit/user_profile_cubit.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _dateController = TextEditingController();

  final bool _isNameEntered = true;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late UserModel user;

  Widget banner(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          child: BlocBuilder<UserImageCubit, UserImageState>(
            builder: (context, state) {
              if (state is UserImageBannerData) {
                var url = state.url;
                return CacheImage(
                  path: url,
                  fit: BoxFit.fitWidth,
                );
              }

              return CacheImage(
                path: user.bannerImage ??
                    'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                fit: BoxFit.fitWidth,
              );
            },
          ),
        ),
        InkWell(
          onTap: () {
            _pickImage(context, true);
          },
          child: Container(
            height: 150,
            color: Colors.grey.withAlpha(80),
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: BlocBuilder<UserImageCubit, UserImageState>(
            builder: (context, state) {
              if (state is UserImageBannerLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  _pickImage(context, true);
                },
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget circleImage(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 38,
            child: BlocBuilder<UserImageCubit, UserImageState>(
              builder: (context, state) {
                if (state is UserImageData) {
                  var url = state.url;
                  return CircleAvatar(
                    radius: 37,
                    backgroundImage: NetworkImage(url),
                  );
                }
                return CircleAvatar(
                  radius: 37,
                  backgroundImage: NetworkImage(user.profileImage!),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _pickImage(context, false);
          },
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.withAlpha(80),
          ),
        ),
        BlocBuilder<UserImageCubit, UserImageState>(
          builder: (context, state) {
            if (state is UserImageLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            return InkWell(
              onTap: () {
                _pickImage(context, false);
              },
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }

  TextStyle hintStyle() {
    return const TextStyle(
      fontSize: 16,
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.black.withAlpha(120)),
      contentPadding: const EdgeInsets.all(0),
      hintText: hint,
      hintStyle: hintStyle(),
    );
  }

  Future _pickImage(BuildContext context, bool isBanner) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      if (!mounted) return;
      uploadImage(context, imageTemp, isBanner);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void uploadImage(BuildContext context, File file, bool isBanner) {
    final cubit = context.read<UserImageCubit>();
    isBanner ? cubit.uploadBanner(file) : cubit.uploadProfilePicture(file);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _save() {
    if (formKey.currentState!.validate()) {
      final cubit = context.read<UserProfileCubit>();
      var model = UserModel(
        name: _nameController.text,
        bio: _bioController.text,
        location: _locationController.text,
        website: _websiteController.text,
        dob: _dateController.text,
      );
      cubit.updateProfile(model);
    }
  }

  Widget _main(BuildContext context) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UpdateUserProfileData) {
          Navigator.pop(context, "true");
        }
      },
      child: SingleChildScrollView(
        child: SizedBox(
          height: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    banner(context),
                    Positioned(
                      top: 110,
                      left: 25,
                      child: circleImage(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                          "Name",
                          "Name cannot be blank",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name cannot be blank";
                          }
                          return null;
                        },
                        // onChanged: (value) {
                        //   setState(() {
                        //     _isNameEntered = value.isNotEmpty;
                        //   });
                        // },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _bioController,
                        //maxLines: null,
                        maxLength: 80,
                        // Set this
                        //expands: true,
                        // and this
                        keyboardType: TextInputType.text,
                        decoration: _inputDecoration(
                          "Bio",
                          "",
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _locationController,
                        decoration: _inputDecoration(
                          "Location",
                          "",
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _websiteController,
                        decoration: _inputDecoration(
                          "Website",
                          "",
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              _dateController.text = DateFormat('dd MMMM yyyy')
                                  .format(selectedDate);
                            }
                          });
                        },
                        decoration: _inputDecoration(
                          "Date of birth",
                          "Add your date of birth",
                        ),
                        keyboardType: TextInputType.none,
                        textInputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as UserModel;
    _nameController.text = user.name!;
    _bioController.text = user.bio!;
    _locationController.text = user.location!;
    _websiteController.text = user.website!;
    _dateController.text = user.dob!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _save,
        ),
        actions: [
          InkWell(
            onTap: _save,
            child: Text(
              "Save",
              style:
                  TextStyle(color: _isNameEntered ? Colors.black : Colors.grey),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: _main(context),
    );
  }
}
