import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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

    );
  }
}
