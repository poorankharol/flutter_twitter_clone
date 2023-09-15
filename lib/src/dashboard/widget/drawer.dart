import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/helper/sharedprefs.dart';
import '../../../core/model/user.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  SharedPref sharedPref = SharedPref();
  UserModel? userLoad;

  loadSharedPrefs() async {
    try {
      UserModel user = UserModel.fromJson(await sharedPref.read("user"));
      setState(() {
        userLoad = user;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    loadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: userLoad != null
                        ? CachedNetworkImage(
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            imageUrl: userLoad!.profileImage!.isEmpty
                                ? 'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26'
                                : userLoad!.profileImage!,
                          )
                        : CachedNetworkImage(
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/twitter-clone-43c3e.appspot.com/o/placeholder%2Fuser.png?alt=media&token=9c85ab40-b21f-4b95-b661-19f03ebd5b26',
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userLoad!.name ?? '',
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@pooranpkharol',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '1',
                        style: textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Followers',
                        style: textTheme.titleMedium!.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        '1',
                        style: textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Following',
                        style: textTheme.titleMedium!.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.person_outline_rounded,
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.price_change_outlined,
            ),
            title: const Text('Premium'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bookmark_border_rounded,
            ),
            title: const Text('Bookmarks'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.list_alt_rounded,
            ),
            title: const Text('List'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.mic_none_outlined,
            ),
            title: const Text('Spaces'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.monetization_on_outlined,
            ),
            title: const Text('Monetisation'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ExpansionTile(
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            title: const Text("Professional Tools"),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.add_to_home_screen_rounded,
                ),
                title: const Text('Ads'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            title: const Text("Settings & Support"),
            children: [
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                ),
                title: const Text('Settings and privacy'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline_rounded,
                ),
                title: const Text('Help Centre'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline_rounded,
                ),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushNamed(context, '/');
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
