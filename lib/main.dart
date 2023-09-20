import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/api/user.dart';
import 'package:flutter_twitter_clone/core/constants/apptheme.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';
import 'package:flutter_twitter_clone/src/add/cubit/add_post_cubit.dart';
import 'package:flutter_twitter_clone/src/add/new_tweet.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/following/follow_un_follow_cubit.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/image/user_image_cubit.dart';
import 'package:flutter_twitter_clone/src/dashboard/cubit/profile/user_profile_cubit.dart';
import 'package:flutter_twitter_clone/src/dashboard/screens/dashboard.dart';
import 'package:flutter_twitter_clone/src/dashboard/screens/edit_profile.dart';
import 'package:flutter_twitter_clone/src/dashboard/screens/profile_new.dart';
import 'package:flutter_twitter_clone/src/home/cubit/feeds_cubit.dart';
import 'package:flutter_twitter_clone/src/home/cubit/feeds_user_cubit.dart';
import 'package:flutter_twitter_clone/src/login/cubit/login_user_cubit.dart';
import 'package:flutter_twitter_clone/src/login/login.dart';
import 'package:flutter_twitter_clone/src/register/cubit/register_user_cubit.dart';
import 'package:flutter_twitter_clone/src/register/register.dart';
import 'package:flutter_twitter_clone/src/search/cubit/user_search_cubit.dart';
import 'package:flutter_twitter_clone/src/search/widget/search_widget.dart';
import 'package:flutter_twitter_clone/src/splash/splash.dart';

import 'core/api/posts.dart';
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
        BlocProvider<UserSearchCubit>(
          create: (_) => UserSearchCubit(UserService()),
        ),
        BlocProvider<FollowUnFollowCubit>(
          create: (_) => FollowUnFollowCubit(UserService()),
        ),
        BlocProvider<FeedsCubit>(
          create: (_) => FeedsCubit(PostService()),
        ),
        BlocProvider<FeedsUserCubit>(
          create: (_) => FeedsUserCubit(UserService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Twitter Clone',
        theme: AppTheme.lightTheme,
        home: FirebaseAuth.instance.currentUser == null
            ? const Splash()
            : const Dashboard(),
        //initialRoute:  FirebaseAuth.instance.currentUser == null ? "/" : "/dashboard",
        routes: {
          '/login': (context) => const Login(),
          '/splash': (context) => const Splash(),
          '/register': (context) => const Register(),
          '/dashboard': (context) => const Dashboard(),
          '/newTweet': (context) => const NewTweet(),
          //'/profile': (context) => const ProfileNew(),
          '/editProfile': (context) => const EditProfile(),
          '/search': (context) => const SearchWidget(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/profile') {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final args = settings.arguments as UserModel;
            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return ProfileNew(
                  uid: args.uid!,
                );
              },
            );
          }
          // The code only supports
          // PassArgumentsScreen.routeName right now.
          // Other values need to be implemented if we
          // add them. The assertion here will help remind
          // us of that higher up in the call stack, since
          // this assertion would otherwise fire somewhere
          // in the framework.
          //assert(false, 'Need to implement ${settings.name}');
          return null;
        },
      ),
    );
  }
}
