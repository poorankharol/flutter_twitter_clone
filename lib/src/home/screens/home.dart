import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:flutter_twitter_clone/src/home/widget/tweet_item.dart';
import 'package:flutter_twitter_clone/src/home/cubit/feeds/feeds_cubit.dart';

import '../cubit/feeds/feeds_retweets_cubit.dart';
import '../cubit/feeds/feeds_user_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() {
    final cubit = context.read<FeedsCubit>();
    cubit.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        //Speed dial menu
        icon: Icons.add,
        //icon on Floating action button
        activeIcon: Icons.post_add,
        //icon when menu is expanded on button
        backgroundColor: AppColors.blue,
        //background color of button
        foregroundColor: Colors.white,
        //font color, icon color in button
        activeBackgroundColor: AppColors.blue,
        //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        // action when menu opens
        onClose: () {
          Navigator.pushNamed(context, "/newTweet");
        },
        //action when menu closes

        elevation: 8.0,
        //shadow elevation of button
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        spaceBetweenChildren: 10,

        //shape of button
        children: [
          SpeedDialChild(
            //speed dial child
            child: const Icon(
              Icons.gif_box_outlined,
              color: AppColors.blue,
            ),
            backgroundColor: Colors.white,
            label: 'Gif',
            onTap: () => print('FIRST CHILD'),
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.photo,
              color: AppColors.blue,
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            label: 'Photos',
            onTap: () => print('SECOND CHILD'),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.mic,
              color: AppColors.blue,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            label: 'Spacer',
            labelShadow: null,
            onTap: () => print('THIRD CHILD'),
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),

          //add more menu item childs here
        ],
      ),
      body: BlocBuilder<FeedsCubit, FeedsState>(
        builder: (context, state) {
          if (state is FeedsData) {
            var feeds = state.data;
            if (feeds.isEmpty) {
              return const Center(child: Text('User hasn\'t post any Tweet'));
            }
            return ListView.separated(
              itemCount: feeds.length,
              itemBuilder: (ctx, index) {
                if (feeds[index].isRetweeted) {
                  context
                      .read<FeedsRetweetsCubit>()
                      .getPostById(feeds[index].originalId);
                  return BlocBuilder<FeedsRetweetsCubit, FeedsRetweetsState>(
                    builder: (context, state) {
                      if (state is FeedsRetweetsData) {
                        var post = state.model;
                        return TweetItem(
                          model: post,
                          isRetweet: true,
                          currentUserRetweet: post.currentUserRetweet,
                        );
                      }
                      return const SizedBox();
                    },
                  );
                } else {
                  return TweetItem(
                    model: feeds[index],
                    isRetweet: false,
                    currentUserRetweet: false,
                  );
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  thickness: 0.5,
                );
              },
            );
          }
          if (state is FeedsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue,
              ),
            );
          }
          return const Center(child: Text('user hasn\'t post any Tweet'));
        },
      ),
    );
  }
}
