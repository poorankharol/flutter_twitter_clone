import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:intl/intl.dart';

import '../../../core/widget/circular_image.dart';
import '../../home/cubit/feeds_cubit.dart';
import '../../home/cubit/feeds_user_cubit.dart';

class TweetItem extends StatefulWidget {
  const TweetItem({super.key, required this.model});

  final PostModel model;

  @override
  State<TweetItem> createState() => _TweetItemState();
}

class _TweetItemState extends State<TweetItem> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() {
    final cubit = context.read<FeedsUserCubit>();
    cubit.getUserInfo(widget.model.creator);
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

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

    return BlocBuilder<FeedsUserCubit, FeedsUserState>(
      builder: (context, state) {
        if (state is FeedsUserData) {
          var user = state.user;
          return Row(
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
                          Text(
                            "• ${getDateFormat(widget.model.timestamp.toDate())}",
                            maxLines: 1,
                            style: textTheme.titleMedium!.copyWith(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                          const Spacer(),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
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
                              child: Icon(
                                Icons.repeat_sharp,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(""),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(""),
                          ],
                        ),
                        Icon(
                          Icons.share,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
