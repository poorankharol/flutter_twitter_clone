import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/user.dart';

part 'feeds_user_state.dart';

class FeedsUserCubit extends Cubit<FeedsUserState> {
  final UserService _userService;

  FeedsUserCubit(this._userService) : super(FeedsUserInitial());

  Future<void> getUserInfo(String uid) async {
    emit(FeedsUserLoading());
    _userService.getUserInfo(uid).then((value) {
      emit(FeedsUserData(value));
    }).onError((error, stackTrace) {
      emit(FeedsUserError(error.toString()));
    });
    // try {
    //   var userData = await _userService.getUserInfo(uid);
    //   final updatedData = state.copyWith(userData); // Update the model
    //   emit(updatedData);
    // } catch (e) {
    //   //emit(FeedsUserError(e.toString()));
    // }
  }
}
