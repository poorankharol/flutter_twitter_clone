import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';
import 'package:flutter_twitter_clone/src/dashboard/widget/drawer.dart';
import 'package:flutter_twitter_clone/src/home/home.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.supervised_user_circle_rounded, size: 30),
        //   onPressed: () {
        //     _scaffoldKey.currentState!.openDrawer();
        //   },
        // ),
        leading: InkWell(
          onTap: (){
            _scaffoldKey.currentState!.openDrawer();
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
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
            icon: Icon(Icons.home_outlined),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
              label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
              label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email_outlined),
              label: ""
          ),
        ],
      ),
    );
  }
}
