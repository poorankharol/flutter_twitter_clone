import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/api/user.dart';
import 'package:flutter_twitter_clone/core/constants/apptheme.dart';
import 'package:flutter_twitter_clone/src/add/cubit/add_post_cubit.dart';
import 'package:flutter_twitter_clone/src/add/new_tweet.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/image/user_image_cubit.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/profile/user_profile_cubit.dart';
import 'package:flutter_twitter_clone/src/dashboard/screens/dashboard.dart';
import 'package:flutter_twitter_clone/src/dashboard/screens/edit_profile.dart';
import 'package:flutter_twitter_clone/src/dashboard/screens/profile_new.dart';
import 'package:flutter_twitter_clone/src/login/cubit/login_user_cubit.dart';
import 'package:flutter_twitter_clone/src/login/login.dart';
import 'package:flutter_twitter_clone/src/register/cubit/register_user_cubit.dart';
import 'package:flutter_twitter_clone/src/register/register.dart';
import 'package:flutter_twitter_clone/src/search/widget/search_widget.dart';
import 'package:flutter_twitter_clone/src/splash/splash.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginUserCubit>(
          create: (context) => LoginUserCubit(LoginUserState.initial),
        ),
        BlocProvider<RegisterUserCubit>(
          create: (_) => RegisterUserCubit(RegisterUserState.initial),
        ),
        BlocProvider<PostCubit>(
          create: (_) => PostCubit(PostState.initial),
        ),
        BlocProvider<UserProfileCubit>(
          create: (_) => UserProfileCubit(UserService()),
        ),
        BlocProvider<UserImageCubit>(
          create: (_) => UserImageCubit(UserService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Twitter Clone',
        theme: AppTheme.lightTheme,
        home: const Splash(),
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? "/" : "/dashboard",
        routes: {
          '/login': (context) => const Login(),
          '/register': (context) => const Register(),
          '/dashboard': (context) => const Dashboard(),
          '/newTweet': (context) => const NewTweet(),
          '/profile': (context) => const ProfileNew(),
          '/editProfile': (context) => const EditProfile(),
          '/search': (context) => const SearchWidget(),
        },
      ),
    );
  }
}
