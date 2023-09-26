import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';

import '../../../core/constants/appcolors.dart';
import '../cubit/replies/replies_cubit.dart';

class Replies extends StatefulWidget {
  const Replies({super.key});

  @override
  State<Replies> createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
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

  void _setCounter(String value) {}

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final post = ModalRoute.of(context)!.settings.arguments as PostModel;
    return BlocConsumer<RepliesCubit, RepliesState>(
      listener: (context, state) {
        switch (state) {
          case RepliesSuccess():
            Navigator.pop(context);
            break;
          case RepliesError():
            break;
          case RepliesInitial():
            break;
        }
      },
      builder: (context, state) {
        if (state == RepliesError()) {
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
                    context.read<RepliesCubit>().postReply(
                          post: post,
                          message: textController.text.trim(),
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  minimumSize: Size.zero, // Set this
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                ), // and this
                child: Text(
                  "Reply",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            post.user!.profileImage!,
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.user!.name!,
                                style: textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text("@${post.user!.username!}"),
                            ],
                          ),
                          Text(post.message),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: DottedLine(
                      direction: Axis.vertical,
                      alignment: WrapAlignment.center,
                      lineLength: 50,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Colors.grey,
                      dashGapLength: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            post.user!.profileImage!,
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
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
                              hintText: "post your reply",
                              hintStyle: textTheme.titleMedium!
                                  .copyWith(fontSize: 18, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 5)),
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: 18,
                          ),
                          onChanged: _setCounter,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
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
