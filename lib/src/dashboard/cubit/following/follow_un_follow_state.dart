part of 'follow_un_follow_cubit.dart';

@immutable
abstract class FollowUnFollowState {}

class FollowUnFollowInitial extends FollowUnFollowState {}

//Follow User
class FollowUser extends FollowUnFollowState {
  FollowUser();
}
//UnFollow User
class UnFollowUser extends FollowUnFollowState {
  UnFollowUser();
}

//IsFollowing
class IsFollowingUserData extends FollowUnFollowState {
  final bool isFollowing;
  IsFollowingUserData(this.isFollowing);
}
