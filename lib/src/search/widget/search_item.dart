import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';

import '../../../core/widget/circular_image.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/profile",arguments: user);
      },
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          CircularImage(
            path: user.profileImage!.isEmpty
                ? "https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26"
                : user.profileImage!,
            height: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    user.name!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  // const SizedBox(height: 0,),
                  // Text(
                  //   "",
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  // ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
