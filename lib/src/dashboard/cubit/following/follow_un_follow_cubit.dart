import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/user.dart';

part 'follow_un_follow_state.dart';

class FollowUnFollowCubit extends Cubit<FollowUnFollowState> {
  final UserService _userService;
  FollowUnFollowCubit(this._userService) : super(FollowUnFollowInitial());

  Future<void> followUser(String uid) async {
    _userService.followUser(uid).then((value) {
      emit(FollowUser());
    });
  }
  Future<void> unFollowUser(String uid) async {
    _userService.unFollowUser(uid).then((value) {
      emit(UnFollowUser());
    });
  }

  Future<void> isFollowing(String uid, String otherUid) async {
    _userService.isFollowing(uid, otherUid).listen((value) {
      emit(IsFollowingUserData(value));
    });
  }
}
