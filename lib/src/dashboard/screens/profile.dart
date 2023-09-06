import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/user_profile_cubit.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';

import '../widget/tweet_item.dart';

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
      cubit.fetchTweetsData(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserProfileData) {
          var data = state.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
            ),
            body: ListView.separated(
                itemBuilder: (ctx, index) {
                  return TweetItem(
                    model: data[index],
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider();
                },
                itemCount: data.length),
          );
        }
        return const SizedBox();
      },
    );
  }
}
