import 'dart:collection';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/home/cubit/replies/replies_cubit.dart';
import 'package:flutter_twitter_clone/src/home/cubit/replies/replies_cubit.dart';
import 'package:flutter_twitter_clone/src/home/widget/tweet_item.dart';

import '../../../core/helper/utility.dart';
import '../../../core/widget/circular_image.dart';
import '../cubit/like/like_cubit.dart';
import '../cubit/retweet/retweet_cubit.dart';
import '../model/post_model.dart';
import '../widget/text_count_widget.dart';

class TweetDetails extends StatelessWidget {
  const TweetDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var iconList = [
      Icons.mode_comment_outlined,
      Icons.repeat_rounded,
      Icons.favorite_border_rounded,
      Icons.bookmark_border_rounded,
      Icons.share_outlined,
    ];

    var textTheme = Theme.of(context).textTheme;
    final map = ModalRoute.of(context)!.settings.arguments as dynamic;
    final post = map['post'] as PostModel;
    final currentUserRetweet = map['currentUserRetweet'];
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CircularImage(
                          path: post.user!.profileImage!.isEmpty
                              ? "https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26"
                              : post.user!.profileImage!,
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
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  post.user!.name!,
                                  maxLines: 1,
                                  style: textTheme.titleMedium!.copyWith(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "@${post.user!.username!}",
                            maxLines: 1,
                            style: textTheme.titleMedium!.copyWith(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    post.message,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Utility.getOriginalTimeStamp(post.timestamp),
                  style: const TextStyle(
                    color: Colors.grey,
                    //fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 0.2,
                  dashLength: 4.0,
                  dashColor: Colors.grey,
                  dashGapLength: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconCountWidget(
                      count: post.retweetsCount.toString(),
                      text: "Reposts",
                    ),
                    const IconCountWidget(
                      count: "",
                      text: "Quotes",
                    ),
                    IconCountWidget(
                      count: post.likesCount.toString(),
                      text: "Likes",
                    ),
                    const IconCountWidget(
                      count: "",
                      text: "Bookmarks",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 0.2,
                  dashLength: 4.0,
                  dashColor: Colors.grey,
                  dashGapLength: 0,
                ),
                _options(context, post),
                const DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 0.2,
                  dashLength: 4.0,
                  dashColor: Colors.grey,
                  dashGapLength: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocBuilder<RepliesCubit, RepliesState>(
                  builder: (context, state) {
                    context.read<RepliesCubit>().getReplies(post);
                    if (state is RepliesListData) {
                      var replies = state.replies;
                      return ListView.builder(
                        itemCount: replies.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return TweetItem(
                            model: replies[index],
                            isRetweet: false,
                            currentUserRetweet: false,
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _options(BuildContext context, PostModel post) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/replies', arguments: post);
          },
          icon: const Icon(
            Icons.mode_comment_outlined,
            color: Colors.grey,
          ),
        ),
        IconButton(
          onPressed: () {
            //final retweet = context.read<RetweetCubit>();
            //retweet.retweetPost(post, currentUserRetweet);
          },
          icon: const Icon(Icons.repeat_rounded, color: Colors.grey),
        ),
        IconButton(
          onPressed: () {
            final like = context.read<LikeCubit>();
            like.likePost(post, post.isLiked);
          },
          icon: BlocBuilder<LikeCubit, LikeState>(
            builder: (context, state) {
              final like = context.read<LikeCubit>();
              like.getCurrentUserLike(post);
              if (state is LikeSuccess) {
                var isLiked = state.isLiked;
                return Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                    color: post.isLiked ? Colors.red : Colors.grey);
              }
              return Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                  color: post.isLiked ? Colors.red : Colors.grey);
            },
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.bookmark_border_rounded, color: Colors.grey),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share_outlined, color: Colors.grey),
        ),
      ],
    );
  }
}
