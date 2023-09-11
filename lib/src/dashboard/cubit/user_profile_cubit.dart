import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_twitter_clone/core/auth/posts.dart';
import 'package:flutter_twitter_clone/core/auth/user.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';
import 'package:meta/meta.dart';

import '../../home/model/post_model.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final PostService _repository;
  final UserService _userService;

  UserProfileCubit(this._repository,this._userService) : super(UserProfileInitial());

  Future<void> fetchData(String uid) async {
    emit(UserProfileLoading());
    _userService.getUserDataByUid(uid).then((value){
      _repository.getPostByUser(uid: uid).listen((event) {
        value.tweets = event;
        emit(UserProfileData(value));
      });
    });

  }
}
