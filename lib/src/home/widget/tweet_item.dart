import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';
import 'package:flutter_twitter_clone/src/home/cubit/like/like_cubit.dart';
import 'package:flutter_twitter_clone/src/home/cubit/retweet/retweet_cubit.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:intl/intl.dart';

import '../../../core/widget/circular_image.dart';
import '../cubit/feeds/feeds_user_cubit.dart';

class TweetItem extends StatefulWidget {
  const TweetItem({super.key, required this.model});

  final PostModel model;

  @override
  State<TweetItem> createState() => _TweetItemState();
}

class _TweetItemState extends State<TweetItem> {
  PostModel? retweetedPost;

  @override
  void initState() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fetchData();
    });
    super.initState();
  }

  void fetchData() async {
    await context.read<FeedsUserCubit>().getUserInfo(widget.model.creator);
  }

  String getDateFormat(DateTime toCheck) {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
      //now.hour,
      //now.minute,
      //now.second,
    );
    final yesterday = DateTime(
      now.year,
      now.month,
      now.day - 1,
    );

    final dateToCheck = toCheck;
    final aDate = DateTime(
      dateToCheck.year,
      dateToCheck.month,
      dateToCheck.day,
      //dateToCheck.hour,
      //dateToCheck.minute,
      //dateToCheck.second,
    );
    if (aDate == now) {
      return "now";
    } else if (aDate == today) {
      var diffDt = now.difference(dateToCheck);
      if (diffDt.inHours > 0) {
        return "${diffDt.inHours} h";
      } else {
        return "${diffDt.inMinutes} m";
      }
      //return "${DateFormat('m').format(toCheck)} m";
      //return "today";
      // String totalMinutes = "";
      // var minutes = aDate.minute;
      // print(minutes);
      // var hours = aDate.hour;
      // print(hours);
      // totalMinutes += hours > 0 ? "$hours h " : "";
      // totalMinutes += minutes > 0 ? "$minutes m" : "";
      // return totalMinutes;
    } else if (aDate == yesterday) {
      return "yesterday";
    } else {
      return DateFormat('dd MMM').format(toCheck);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedsUserCubit, FeedsUserState>(
      builder: (context, state) {
        if (state is FeedsUserData) {
          var user = state.user;
          return mainTweet(user);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget tweetsOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          children: [
            Icon(
              Icons.mode_comment_outlined,
              color: Colors.grey,
              size: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(""),
          ],
        ),
        Row(
          children: [
            RotatedBox(
              quarterTurns: 1,
              child: IconButton(
                icon: Icon(
                  Icons.repeat_rounded,
                  color: widget.model.isRetweeted ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                onPressed: () {
                  final retweet = context.read<RetweetCubit>();
                  retweet.retweetPost(widget.model, widget.model.isRetweeted);
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(""),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                widget.model.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: widget.model.isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                final like = context.read<LikeCubit>();
                like.likePost(widget.model, widget.model.isLiked);
              },
            ),
            const SizedBox(
              width: 10,
            ),
            widget.model.likesCount == 0 ? const SizedBox():Text("${widget.model.likesCount}"),
          ],
        ),
        const Icon(
          Icons.share,
          color: Colors.grey,
          size: 20,
        ),
      ],
    );
  }

  Widget mainTweet(UserModel user) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.model.isRetweeted
            ? const Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Icon(
                    Icons.repeat_rounded,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("You reposted"),
                ],
              )
            : const SizedBox(),
        const SizedBox(
          height: 5,
        ),
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
                child: CircularImage(
                  path: user.profileImage!.isEmpty
                      ? "https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26"
                      : user.profileImage!,
                  height: 80,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 8,
                      top: 2,
                      bottom: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          user.name!,
                          maxLines: 1,
                          style: textTheme.titleMedium!.copyWith(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "@${user.username!}",
                          maxLines: 1,
                          style: textTheme.titleMedium!.copyWith(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "• ${getDateFormat(widget.model.timestamp.toDate())}",
                            maxLines: 1,
                            style: textTheme.titleMedium!.copyWith(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.model.message,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  tweetsOption(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
