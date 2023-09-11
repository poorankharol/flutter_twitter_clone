import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/user_profile_cubit.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<UserProfileCubit>();
      cubit.fetchData(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserProfileData) {
          var data = state.data;
          return Scaffold(
            // appBar: AppBar(
            //   title: const Text("Profile"),
            // ),
            body: SafeArea(
              // child: ListView.separated(
              //     itemBuilder: (ctx, index) {
              //       return TweetItem(
              //         model: data[index],
              //       );
              //     },
              //     separatorBuilder: (ctx, index) {
              //       return const Divider();
              //     },
              //     itemCount: data.length),
              child: Stack(
                children: [
                  // this is the land image
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image(image: ExactAssetImage("assets/images/land.jpeg")),
                    ],
                  ),
                  const Positioned(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black38,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.black38,
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.black38,
                                child: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // profile pitcure
                  const Positioned(
                    top: 100,
                    left: 25,
                    child: CircleAvatar(
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
                  ),
                  // follow button
                  Positioned(
                    top: 140,
                    left: 280,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 6,
                          bottom: 6,
                        ),
                        child: Text(
                          "Edit profile",
                          maxLines: 1,
                          style: textTheme.titleMedium!.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  // title and text above the tweets
                  Positioned(
                    top: 190,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pooran Kharol',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const Text(
                          '@pooranpkharol',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: const Text(
                            'Android Developer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.indeterminate_check_box_outlined,
                                color: Colors.black54,
                                size: 18,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: const Text(
                                  'Mobile Application',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.black54,
                                size: 18,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: const Text(
                                  'Iraq',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_link_rounded,
                                color: Colors.black54,
                                size: 18,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: const Text(
                                  'poorankharol.com',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.black54,
                                size: 18,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: const Text(
                                  'Joined December ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              const Text(
                                '127 ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const Text(
                                'Following ',
                                style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: const Text(
                                  '49 ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const Text(
                                'Followers ',
                                style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Positioned(
                  //   top: 400,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 8.0),
                  //         child: Row(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 8.0),
                  //               child: Column(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceEvenly,
                  //                 children: [
                  //                   const Text(
                  //                     'Posts',
                  //                     style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                   Container(
                  //                     margin: const EdgeInsets.only(top: 16),
                  //                     height: 3,
                  //                     width: 45,
                  //                     color: Colors.blue,
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 24.0),
                  //               child: Column(
                  //                 children: [
                  //                   const Text(
                  //                     'Replies ',
                  //                     style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black54),
                  //                   ),
                  //                   Container(
                  //                     margin: const EdgeInsets.only(top: 16),
                  //                     height: 3,
                  //                     width: 45,
                  //                     color: Colors.white,
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 24.0),
                  //               child: Column(
                  //                 children: [
                  //                   const Text(
                  //                     'Highlights ',
                  //                     style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black54),
                  //                   ),
                  //                   Container(
                  //                     margin: const EdgeInsets.only(top: 16),
                  //                     height: 3,
                  //                     width: 45,
                  //                     color: Colors.white,
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 24.0),
                  //               child: Column(
                  //                 children: [
                  //                   const Text(
                  //                     'Media ',
                  //                     style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black54),
                  //                   ),
                  //                   Container(
                  //                     margin: const EdgeInsets.only(top: 16),
                  //                     height: 3,
                  //                     width: 45,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: const EdgeInsets.only(left: 24.0),
                  //               child: Column(
                  //                 children: [
                  //                   const Text(
                  //                     'Likes ',
                  //                     style: TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.black54),
                  //                   ),
                  //                   Container(
                  //                     margin: const EdgeInsets.only(top: 16),
                  //                     height: 3,
                  //                     width: 45,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
