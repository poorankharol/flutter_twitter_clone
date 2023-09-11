import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

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
                  radius: 25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/users.jpg",
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Pooran Kharol',
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
                  height: 10,
                ),
                Row(
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
                )
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
