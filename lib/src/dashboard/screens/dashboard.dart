import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:flutter_twitter_clone/src/dashboard/widget/drawer.dart';
import 'package:flutter_twitter_clone/src/home/home.dart';

import '../../../core/helper/sharedprefs.dart';
import '../cubit/profile/user_profile_cubit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    super.initState();
  }

  void fetchData() {
    final cubit = context.read<UserProfileCubit>();
    cubit.fetchData(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    var textTheme = Theme.of(context).textTheme;
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: state is UserProfileData
                      ? CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          imageUrl: state.data.profileImage!.isEmpty
                              ? 'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'
                              : state.data.profileImage!,
                        )
                      : CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'),
                ),
              ),
            ),
            title: const Text("X"),
            centerTitle: true,
          ),
          body: const Home(),
          drawer: const DrawerWidget(),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: AppColors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.email_outlined), label: ""),
            ],
          ),
        );
      },
    );
  }
}
