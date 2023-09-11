import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:flutter_twitter_clone/core/widget/ripple_button.dart';
import 'package:flutter_twitter_clone/src/dashboard/widget/tweet_item.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';

import '../../../core/helper/utility.dart';
import '../../../core/widget/cache_image.dart';
import '../../../core/widget/circular_image.dart';
import '../../../core/widget/customLoader.dart';
import '../../../core/widget/customWidgets.dart';
import '../../../core/widget/emptyList.dart';
import '../../../core/widget/url_text/customUrlText.dart';
import '../cubit/user_profile_cubit.dart';

class ProfileNew extends StatefulWidget {
  const ProfileNew({super.key});

  @override
  State<ProfileNew> createState() => _ProfileNewState();
}

class _ProfileNewState extends State<ProfileNew>
    with SingleTickerProviderStateMixin {
  bool isMyProfile = true;
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var authState = Provider.of<ProfileState>(context, listen: false);
    //
    //   isMyProfile = authState.isMyProfile;
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<UserProfileCubit>();
      cubit.fetchTweetsData(FirebaseAuth.instance.currentUser!.uid);
    });
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// This method called when user pressed back button
  /// When profile page is about to close
  /// Maintain minimum user's profile in profile page list
  Future<bool> _onWillPop() async {
    return true;
  }

  Widget _tweetList(
    BuildContext context,
    //ProfileState authState,
    List<PostModel> tweetsList,
    bool isReply,
    bool isMedia,
  ) {
    List<PostModel> list = tweetsList;

    /// If user hasn't tweeted yet
    // if (tweetsList == null) {
    //   // cprint('No Tweet available');
    // } else if (isMedia) {
    //   /// Display all Tweets with media file
    //
    //   list = tweetsList.where((x) => x.imagePath != null).toList();
    // } else if (!isReply) {
    //   /// Display all independent Tweets
    //   /// No comments Tweet will display
    //
    //   list = tweetsList
    //       .where((x) => x.parentkey == null || x.childRetwetkey != null)
    //       .toList();
    // } else {
    //   /// Display all reply Tweets
    //   /// No independent tweet will display
    //   list = tweetsList
    //       .where((x) => x.parentkey != null && x.childRetwetkey == null)
    //       .toList();
    // }

    /// if [authState.isbusy] is true then an loading indicator will be displayed on screen.
    return
        // authState.isbusy
        //   ? SizedBox(
        //       height: MediaQuery.of(context).size.height - 180,
        //       child: const CustomScreenLoader(
        //         height: double.infinity,
        //         width: double.infinity,
        //         backgroundColor: Colors.white,
        //       ),
        //     )
        //
        //   /// if tweet list is empty or null then need to show user a message
        //   :
        list.isEmpty
            ? Container(
                padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                child: NotifyText(
                  title: isMyProfile
                      ? 'You haven\'t ${isReply ? 'reply to any Tweet' : isMedia ? 'post any media Tweet yet' : 'post any Tweet yet'}'
                      : '${"user"} hasn\'t ${isReply ? 'reply to any Tweet' : isMedia ? 'post any media Tweet yet' : 'post any Tweet yet'}',
                  subTitle: isMyProfile
                      ? 'Tap tweet button to add new'
                      : 'Once he\'ll do, they will be shown up here',
                ),
              )

            /// If tweets available then tweet list will displayed
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemCount: list.length,
                itemBuilder: (context, index) => Container(
                  color: AppColors.white,
                  child: TweetItem(
                    model: list[index],
                    // isDisplayOnProfile: true,
                    // trailing: TweetBottomSheet().tweetOptionIcon(
                    //   context,
                    //   model: list[index],
                    //   type: TweetType.Tweet,
                    //   scaffoldKey: scaffoldKey,
                    // ),
                    // scaffoldKey: scaffoldKey,
                  ),
                ),
              );
  }

  SliverAppBar getAppbar() {
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 200,
      elevation: 0,
      stretch: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: [
        PopupMenuButton<Choice>(
          onSelected: (d) {
            if (d.title == "Share") {
              //shareProfile(context);
            } else if (d.title == "QR code") {
              //Navigator.push(context,ScanScreen.getRoute(authState.profileUserModel));
            }
          },
          itemBuilder: (BuildContext context) {
            return choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(
                  choice.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: choice.isEnable ? AppColors.blue : Colors.grey),
                ),
              );
            }).toList();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox.expand(
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                height: 30,
                color: Colors.white,
              ),
            ),
            Container(
              height: 180,
              padding: const EdgeInsets.only(top: 28),
              child: const CacheImage(
                //authState.profileUserModel.bannerImage ??
                path:
                    'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                        shape: BoxShape.circle),
                    child: RippleButton(
                      borderRadius: BorderRadius.circular(50),
                      onPressed: () {},
                      child: const CircularImage(
                        path:
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
                        height: 80,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 90, right: 30),
                    child: Row(
                      children: [
                        isMyProfile
                            ? Container(
                                height: 40,
                              )
                            : RippleButton(
                                splashColor: AppColors.blue.withAlpha(100),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                onPressed: () {
                                  if (!isMyProfile) {}
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  padding: const EdgeInsets.only(
                                      bottom: 0, top: 0, right: 0, left: 0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: isMyProfile
                                              ? Colors.black87.withAlpha(180)
                                              : Colors.blue,
                                          width: 1),
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.call,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                              ),
                        const SizedBox(width: 10),
                        RippleButton(
                          splashColor: AppColors.blue.withAlpha(100),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(60)),
                          onPressed: () {
                            if (isMyProfile) {
                            } else {}
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isMyProfile
                                  ? AppColors.white
                                  : isFollower()
                                      ? AppColors.blue
                                      : AppColors.white,
                              border: Border.all(
                                  color: isMyProfile
                                      ? Colors.black87.withAlpha(180)
                                      : Colors.blue,
                                  width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isMyProfile
                                  ? 'Edit Profile'
                                  : isFollower()
                                      ? 'Following'
                                      : 'Follow',
                              style: TextStyle(
                                color: isMyProfile
                                    ? Colors.black87.withAlpha(180)
                                    : isFollower()
                                        ? AppColors.white
                                        : Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isFollower() {
    // var authState = Provider.of<ProfileState>(context, listen: false);
    // if (authState.profileUserModel.followersList != null &&
    //     authState.profileUserModel.followersList!.isNotEmpty) {
    //   return (authState.profileUserModel.followersList!
    //       .any((x) => x == authState.userId));
    // } else {
    //   return false;
    // }
    return false;
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: "kArtwork"),
    const Tab(text: "kPastJobs")
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              getAppbar(),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: UserNameRowWidget(
                    isMyProfile: isMyProfile,
                  ),
                ),
              ),
            ];
          },
          body: BlocConsumer<UserProfileCubit, UserProfileState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is UserProfileData) {
                var data = state.data;
                return DefaultTabController(
                  length: 5,
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      bottom: TabBar(
                        indicatorColor: AppColors.blue,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: _tabController,
                        isScrollable: true,
                        unselectedLabelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        labelStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          Tab(
                            child: Text(
                              "Posts",
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Replies",
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Highlights",
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Media",
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Likes",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          /// Display all independent tweets list
                          _tweetList(context, data, false, false),

                          /// Display all reply tweet list
                          _tweetList(context, data, true, false),

                          /// Display all reply and comments tweet list
                          _tweetList(context, data, false, true),
                          _tweetList(context, data, false, true),
                          _tweetList(context, data, false, true)
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class UserNameRowWidget extends StatelessWidget {
  const UserNameRowWidget({
    Key? key,
    required this.isMyProfile,
  }) : super(key: key);

  final bool isMyProfile;

  //final UserModel user;

  String getBio(String bio) {
    if (isMyProfile) {
      return bio;
    } else if (bio == "Edit profile to update bio") {
      return "No bio available";
    } else {
      return bio;
    }
  }

  Widget _textButton(
    BuildContext context,
    String count,
    String text,
    Function onPressed,
  ) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Row(
        children: <Widget>[
          customText(
            '$count ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          customText(
            text,
            style: const TextStyle(color: Colors.grey, fontSize: 17),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: <Widget>[
              const Text(
                'Pooran Kharol',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              true
                  ? customIcon(context,
                      icon: Icons.check,
                      isTwitterIcon: true,
                      iconColor: AppColors.blue,
                      size: 13,
                      paddingIcon: 3)
                  : const SizedBox(width: 0),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: customText(
            '@pooranrkharol',
            style: textTheme.titleMedium!.copyWith(fontSize: 13),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              customText(
                getBio('Android Developer'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.location_on_outlined,
                color: Colors.black54,
                size: 18,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: const Text(
                  'Valsad',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              const Icon(
                Icons.insert_link_rounded,
                color: Colors.black54,
                size: 18,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: const UrlText(
                  text: 'poorankharol.com',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.calendar_month_rounded,
                color: Colors.black54,
                size: 18,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: const Text(
                  'Joined December ',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5,),
        Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              _textButton(context, "1", ' Followers', () {
                // var state = context.read<ProfileState>();
                // Navigator.push(
                //   context,
                //   FollowerListPage.getRoute(
                //     profile: state.profileUserModel,
                //     userList: state.profileUserModel.followersList!,
                //   ),
                // );
              }),
              const SizedBox(width: 20),
              _textButton(context, "1", ' Following', () {
                // var state = context.read<ProfileState>();
                // Navigator.push(
                //   context,
                //   FollowingListPage.getRoute(
                //     profile: state.profileUserModel,
                //     userList: state.profileUserModel.followingList!,
                //   ),
                // );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class Choice {
  const Choice(
      {required this.title, required this.icon, this.isEnable = false});

  final bool isEnable;
  final IconData icon;
  final String title;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Share', icon: Icons.directions_car, isEnable: true),
  Choice(title: 'QR code', icon: Icons.directions_railway, isEnable: true),
  Choice(title: 'Draft', icon: Icons.directions_bike),
  Choice(title: 'View Lists', icon: Icons.directions_boat),
  Choice(title: 'View Moments', icon: Icons.directions_bus),
];
