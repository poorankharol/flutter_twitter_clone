import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_twitter_clone/core/auth/posts.dart';
import 'package:meta/meta.dart';

import '../../home/model/post_model.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final PostService _repository;

  UserProfileCubit(this._repository) : super(UserProfileInitial());

  Future<void> fetchTweetsData(String uid) async {
    emit(UserProfileLoading());
    _repository.getPostByUser(uid: uid).listen((event) {
      emit(UserProfileData(event));
    });
  }
}
