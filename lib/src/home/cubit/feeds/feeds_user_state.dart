part of 'feeds_user_cubit.dart';

@immutable
abstract class FeedsUserState {}

class FeedsUserInitial extends FeedsUserState {}

class FeedsUserLoading extends FeedsUserState {}

class FeedsUserData extends FeedsUserState with EquatableMixin {
  final UserModel user;

  FeedsUserData(this.user);

  @override
  List<Object?> get props => [user];
}

class FeedsUserError extends FeedsUserState {
  final String error;

  FeedsUserError(this.error);
}
