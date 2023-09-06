import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/add/cubit/add_post_cubit.dart';

import '../../core/constants/appcolors.dart';

class NewTweet extends StatefulWidget {
  const NewTweet({super.key});

  @override
  State<NewTweet> createState() => _NewTweetState();
}

class _NewTweetState extends State<NewTweet> {
  var authService = FirebaseAuth.instance;
  final textController = TextEditingController();
  var textCount = 280;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _setCounter(String value) {
    // print("textCount"+ value.length.toString());
    // setState(() {
    //   textCount -= value.length;
    // });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        switch (state) {
          case PostState.success:
            Navigator.pop(context);
            break;
          case PostState.failed:
            break;
          case PostState.initial:
            break;
        }
      },
      builder: (context, state) {
        if (state == PostState.failed) {
          return const Scaffold(
              body: Center(
                  child: Text('Oops something went wrong!\nTry again later.')));
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    context
                        .read<PostCubit>()
                        .postTweet(message: textController.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  minimumSize: Size.zero, // Set this
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                ), // and this
                child: Text(
                  "Post",
                  style: textTheme.titleMedium!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          body: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset(
                        "assets/images/users.jpg",
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 85,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blue,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 8,
                            top: 2,
                            bottom: 2,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Public",
                                maxLines: 1,
                                style: textTheme.titleMedium!.copyWith(
                                    fontSize: 12,
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        height: 250,
                        child: TextField(
                          maxLength: 280,
                          controller: textController,
                          maxLines: null,
                          // Set this
                          expands: true,
                          // and this
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "What's happening?",
                            hintStyle: textTheme.titleMedium!.copyWith(
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                          ),
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                          onChanged: _setCounter,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.black.withAlpha(60),
                      ),
                      Container(
                        //height: 50,
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 5, right: 10, top: 10),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.image_outlined,
                              color: AppColors.blue,
                              size: 25,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.gif_box_outlined,
                              color: AppColors.blue,
                              size: 25,
                            ),
                            Spacer(),
                            //Text(textCount.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
