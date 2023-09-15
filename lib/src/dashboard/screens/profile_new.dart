import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:flutter_twitter_clone/core/widget/ripple_button.dart';
import 'package:flutter_twitter_clone/src/dashboard/widget/tweet_item.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';

import '../../../core/helper/utility.dart';
import '../../../core/model/user.dart';
import '../../../core/widget/cache_image.dart';
import '../../../core/widget/circular_image.dart';
import '../../../core/widget/customWidgets.dart';
import '../../../core/widget/emptyList.dart';
import '../cubit/following/follow_un_follow_cubit.dart';
import '../cubit/profile/user_profile_cubit.dart';

class ProfileNew extends StatefulWidget {
  const ProfileNew({super.key, required this.uid});

  final String uid;

  @override
  State<ProfileNew> createState() => _ProfileNewState();
}

class _ProfileNewState extends State<ProfileNew>
    with SingleTickerProviderStateMixin {
  bool isMyProfile = false;
  bool isFollowing = false;
  int pageIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  String profilePicUrl = '';
  UserModel? user;

  @override
  void initState() {
    isMyProfile = FirebaseAuth.instance.currentUser!.uid == widget.uid;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  void fetchData() {
    final cubit = context.read<UserProfileCubit>();
    cubit.fetchData(widget.uid);
    final following = context.read<FollowUnFollowCubit>();
    following.isFollowing(FirebaseAuth.instance.currentUser!.uid, widget.uid);
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
    List<PostModel>? tweetsList,
    bool isReply,
    bool isMedia,
  ) {
    List<PostModel> list = tweetsList!;

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

  SliverAppBar getAppbar(BuildContext context, UserModel model) {
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 200,
      elevation: 0,
      //pinned: true,
      stretch: true,
      iconTheme: const IconThemeData(color: Colors.white),
      // leading: Column(
      //   children: [
      //     const SizedBox(height: 15,),
      //     Row(
      //       children: [
      //         const SizedBox(width: 10),
      //         InkWell(
      //           onTap: (){
      //             Navigator.pop(context);
      //           },
      //           child: Container(
      //             width: 40,
      //             height: 40,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(30),
      //               color: Colors.black.withAlpha(20),
      //             ),
      //             child: const Icon(
      //               Icons.arrow_back,
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      backgroundColor: Colors.white,
      actions: const [
        // PopupMenuButton<Choice>(
        //   onSelected: (d) {
        //     if (d.title == "Share") {
        //       //shareProfile(context);
        //     } else if (d.title == "QR code") {
        //       //Navigator.push(context,ScanScreen.getRoute(authState.profileUserModel));
        //     }
        //   },
        //   itemBuilder: (BuildContext context) {
        //     return choices.map((Choice choice) {
        //       return PopupMenuItem<Choice>(
        //         value: choice,
        //         child: Text(
        //           choice.title,
        //           style: Theme.of(context).textTheme.titleMedium!.copyWith(
        //               color: choice.isEnable ? AppColors.blue : Colors.grey),
        //         ),
        //       );
        //     }).toList();
        //   },
        // ),
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
              child: InkWell(
                onTap: () {
                  //pickImage(context, false);
                },
                child: CacheImage(
                  path: model.bannerImage!.isEmpty
                      ? 'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fbanner-defau.jpg?alt=media&token=5adbc54c-2869-4689-8d94-4e21e72100e6'
                      : model.bannerImage!,
                  fit: BoxFit.fitWidth,
                ),
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
                      onPressed: () {
                        //pickImage(context, true);
                      },
                      child: CircularImage(
                        path: model.profileImage!.isEmpty
                            ? "https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26"
                            : model.profileImage!,
                        height: 80,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 90, right: 30),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        RippleButton(
                          splashColor: AppColors.blue.withAlpha(100),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(60)),
                          onPressed: () async {
                            if (isMyProfile) {
                              var result = await Navigator.pushNamed(
                                  context, '/editProfile',
                                  arguments: user);
                              if (!mounted) return;
                              if (result != null) {
                                fetchData();
                              }
                            } else {
                              var follow = context.read<FollowUnFollowCubit>();
                              if (isFollowing) {
                                follow.unFollowUser(user!.uid!);
                              } else {
                                follow.followUser(user!.uid!);
                              }
                              setState(() {
                                isFollowing = !isFollowing;
                              });
                            }
                          },
                          child:
                              BlocBuilder<FollowUnFollowCubit, FollowUnFollowState>(
                            builder: (context, state) {
                              if (state is IsFollowingUserData) {
                                isFollowing = state.isFollowing;
                                print("Issssssss$isFollowing");
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMyProfile
                                        ? AppColors.white
                                        : isFollowing
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
                                        : isFollowing
                                        ? 'Following'
                                        : 'Follow',
                                    style: TextStyle(
                                      color: isMyProfile
                                          ? Colors.black87.withAlpha(180)
                                          : isFollowing
                                          ? AppColors.white
                                          : Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isMyProfile
                                      ? AppColors.white
                                      : isFollowing
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
                                      : isFollowing
                                      ? 'Following'
                                      : 'Follow',
                                  style: TextStyle(
                                    color: isMyProfile
                                        ? Colors.black87.withAlpha(180)
                                        : isFollowing
                                        ? AppColors.white
                                        : Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
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
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileData) {
              UserModel data = state.data;
              user = data;
              isMyProfile = data.uid == FirebaseAuth.instance.currentUser!.uid;
              return NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    getAppbar(context, data),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: UserNameRowWidget(
                          isMyProfile: isMyProfile,
                          user: data,
                        ),
                      ),
                    ),
                  ];
                },
                body: DefaultTabController(
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
                          _tweetList(context, data.tweets, false, false),

                          /// Display all reply tweet list
                          _tweetList(context, [], true, false),

                          /// Display all reply and comments tweet list
                          _tweetList(context, [], false, true),
                          _tweetList(context, [], false, true),
                          _tweetList(context, [], false, true)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.blue,
            ));
          },
        ),
      ),
    );
  }
}

class UserNameRowWidget extends StatelessWidget {
  const UserNameRowWidget({
    Key? key,
    required this.isMyProfile,
    required this.user,
  }) : super(key: key);

  final bool isMyProfile;
  final UserModel user;

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
              Text(
                user.name!,
                style: const TextStyle(
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
            "@${user.username}",
            style: textTheme.titleMedium!.copyWith(fontSize: 13),
          ),
        ),
        user.bio!.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    customText(getBio(user.bio!), style: textTheme.titleMedium),
                  ],
                ),
              )
            : const SizedBox(
                height: 10,
              ),
        user.location!.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    // const Icon(
                    //   Icons.indeterminate_check_box_outlined,
                    //   color: Colors.black54,
                    //   size: 18,
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 5),
                    //   child: const Text(
                    //     'Mobile Application',
                    //     style: TextStyle(fontSize: 16, color: Colors.black54),
                    //   ),
                    // ),
                    const SizedBox(
                      width: 0,
                    ),
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.black54,
                      size: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Text(
                        user.location!,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        user.website!.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_link_rounded,
                      color: Colors.black54,
                      size: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Linkify(
                        onOpen: (link) async {
                          await Utility.launchURL(link.url);
                        },
                        linkStyle:
                            const TextStyle(decoration: TextDecoration.none),
                        text: user.website!,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 14,
                        ),
                        options: const LinkifyOptions(
                            removeWww: true, humanize: true),
                      ),
                    ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    // const Icon(
                    //   Icons.calendar_month_rounded,
                    //   color: Colors.black54,
                    //   size: 18,
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 5),
                    //   child: const Text(
                    //     'Joined December ',
                    //     style: TextStyle(fontSize: 16, color: Colors.black54),
                    //   ),
                    // ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 5,
        ),
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
