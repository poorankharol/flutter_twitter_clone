import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_twitter_clone/core/auth/user.dart';
import 'package:meta/meta.dart';

part 'user_image_state.dart';

class UserImageCubit extends Cubit<UserImageState> {
  final UserService _repository;

  UserImageCubit(this._repository) : super(UserImageInitial());

  Future<void> uploadProfilePicture(File profile) async {
    emit(UserImageLoading());
    String url = await _repository.updateProfilePicture(profileImage: profile);
    emit(UserImageData(url));
  }

  Future<void> getProfilePicture(String uid) async {
    emit(UserImageLoading());
    String url = await _repository.getProfilePicture(uid: uid);
    emit(UserImageData(url));
  }

  Future<void> uploadBanner(File profile) async {
    emit(UserImageBannerLoading());
    String url = await _repository.updateBanner(bannerImage: profile);
    emit(UserImageBannerData(url));
  }

}
