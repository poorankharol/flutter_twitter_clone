import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:intl/intl.dart';

class TweetItem extends StatelessWidget {
  const TweetItem({super.key, required this.model});

  final PostModel model;

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
                      "Pooran Kharol",
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
                      "@pooranpkharol",
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
                      "• ${getDateFormat(model.timestamp.toDate())}",
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
                model.message,
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
                      Text("1"),
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
                      Text("1"),
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
                      Text("1"),
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
}
