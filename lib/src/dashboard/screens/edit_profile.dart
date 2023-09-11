import 'package:flutter/material.dart';

import '../../../core/widget/cache_image.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        actions: const [
          Text("Save"),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: InkWell(
                      onTap: () {},
                      child: const CacheImage(
                        path:
                            'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    color: Colors.grey.withAlpha(80),
                  ),
                  const Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 110,
            left: 25,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.black12,
                    child: CircleAvatar(
                      radius: 37,
                      backgroundColor: Colors.yellow,
                      backgroundImage:
                          ExactAssetImage('assets/images/users.jpg'),
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.withAlpha(80),
                ),
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
