part of 'feeds_user_cubit.dart';

@immutable
abstract class FeedsUserState {}

class FeedsUserInitial extends FeedsUserState {}
class FeedsUserLoading extends FeedsUserState {}
class FeedsUserData extends FeedsUserState {
  final UserModel user;

  FeedsUserData(this.user);

}
class FeedsUserError extends FeedsUserState {
  final String error;

  FeedsUserError(this.error);

}
