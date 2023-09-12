import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/widget/cache_image.dart';
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
  File? bannerImage;
  File? profileImage;
  bool _isNameEntered = false;
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget banner(String url) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          child: bannerImage != null
              ? Image.file(
                  bannerImage!,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                )
              : CacheImage(
                  path: url ??
                      'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                  fit: BoxFit.fitWidth,
                ),
        ),
        InkWell(
          onTap: () {
            _pickImage(true);
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
          child: InkWell(
            onTap: () {
              _pickImage(true);
            },
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  Widget circleImage(String url) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 38,
            backgroundColor: Colors.black12,
            child: CircleAvatar(
              radius: 37,
              backgroundImage: profileImage != null
                  ? Image.file(profileImage!).image
                  : NetworkImage(url),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _pickImage(false);
          },
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.withAlpha(80),
          ),
        ),
        InkWell(
          onTap: () {
            _pickImage(false);
          },
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
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

  Future _pickImage(bool isBanner) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      if (isBanner) {
        setState(() {
          bannerImage = imageTemp;
        });
      } else {
        setState(() {
          profileImage = imageTemp;
        });
      }
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void uploadImage(File file) {
    //final cubit = context.read<UserImageCubit>();
    //cubit.uploadProfilePicture(file);
    //cubit.uploadBanner(file);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() {
    final cubit = context.read<UserProfileCubit>();
    cubit.fetchData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: [
          InkWell(
            onTap: () {
              if (formKey.currentState!.validate()) {}
            },
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
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileData) {
            var user = state.data;
            _nameController.text = user.name;
            _bioController.text = user.bio!;
            _locationController.text = user.location!;
            _websiteController.text = user.website!;
            _dateController.text = user.dob!;
            return SingleChildScrollView(
              child: SizedBox(
                height: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          banner(user.bannerImage!),
                          Positioned(
                            top: 110,
                            left: 25,
                            child: circleImage(user.profileImage),
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
                              onChanged: (value) {
                                setState(() {
                                  _isNameEntered = value.isNotEmpty;
                                });
                              },
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
                                    _dateController.text =
                                        DateFormat('dd MMMM yyyy')
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
            );
          }
          if (state is UserProfileLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
