import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_twitter_clone/core/api/user.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';
import 'package:meta/meta.dart';

import '../../../../core/helper/sharedprefs.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserService _userService;

  UserProfileCubit(this._userService) : super(UserProfileInitial());

  Future<void> fetchData(String uid) async {
    //SharedPref sharedPref = SharedPref();
    emit(UserProfileLoading());
    _userService.getUserInfo(uid).then((value) {
      _userService.getUserTweets(uid: uid).listen((event) {
        value.tweets = event;
        emit(UserProfileData(value));
      });
    });
  }

  Future<void> updateProfile(UserModel userModel) async {
    emit(UpdateUserProfileLoading());
    _userService.updateProfile(userModel).then((value) {
      emit(UpdateUserProfileData());
    }, onError: (error) {
      emit(UserProfileError(error));
    });
  }
}
