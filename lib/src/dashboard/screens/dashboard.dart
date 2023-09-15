import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:flutter_twitter_clone/src/dashboard/widget/drawer.dart';
import 'package:flutter_twitter_clone/src/home/home.dart';
import 'package:username_generator/username_generator.dart';

import '../../../core/helper/sharedprefs.dart';
import '../../direct/dm.dart';
import '../../notification/notification.dart';
import '../../search/screens/search.dart';
import '../cubit/profile/user_profile_cubit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPref sharedPref = SharedPref();
  int _selectedIndex = 0; //New
  bool hasSearchBarFocus = false;
  var bottomWidgets = [
    const Home(),
    const Search(),
    const NotificationScreen(),
    const DirectMessage(),
  ];
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchData();
    });
    _focus.addListener(_onFocusChange);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      hasSearchBarFocus = _focus.hasFocus;
    });
    print("Focus: ${_focus.hasFocus.toString()}");
  }


  void fetchData() {
    final cubit = context.read<UserProfileCubit>();
    cubit.fetchData(FirebaseAuth.instance.currentUser!.uid);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  AppBar _appBar(UserProfileState state) {
    if (_selectedIndex == 0) {
      return _homeAppBar(state);
    } else if (_selectedIndex == 1) {
      return _searchAppBar(state);
    } else {
      return _homeAppBar(state);
    }
  }

  AppBar _homeAppBar(UserProfileState state) {
    return AppBar(
      leading: Container(margin: const EdgeInsets.only(left: 16),
        child: InkWell(
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
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      imageUrl: state.data.profileImage!.isEmpty
                          ? 'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'
                          : state.data.profileImage!,
                    )
                  : CachedNetworkImage(
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      imageUrl:
                          'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'),
            ),
          ),
        ),
      ),
      title: const Text("X"),
      centerTitle: true,
    );
  }

  AppBar _searchAppBar(UserProfileState state) {
    return AppBar(
      leading: null,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
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
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        imageUrl: state.data.profileImage!.isEmpty
                            ? 'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'
                            : state.data.profileImage!,
                      )
                    : CachedNetworkImage(
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                onTap: (){
                    Navigator.pushNamed(context, "/search");
                },
                //cursorHeight: 20,
                //focusNode: _focus,
                readOnly: true,
                //cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.withAlpha(50),
                  isDense: false,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                  /* -- Text and Icon -- */
                  hintText: "Search X",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  /* -- Border Styling -- */
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45.0),
                    borderSide: BorderSide.none, // BorderSide
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),// InputDecoration
              ),
            ), // TextField
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.settings,
            color: AppColors.blue,
          ) //
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          appBar: _appBar(state),
          body : bottomWidgets.elementAt(_selectedIndex),
          drawer: const DrawerWidget(),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            //New
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined,size: 30,), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined,size: 30), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined,size: 30), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.email_outlined,size: 30), label: ""),
            ],
          ),
        );
      },
    );
  }
}
