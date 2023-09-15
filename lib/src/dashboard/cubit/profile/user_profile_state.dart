part of 'user_profile_cubit.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String error;

  UserProfileError(this.error);
}

class UserProfileData extends UserProfileState {
  final UserModel data;

  UserProfileData(this.data);
}

//Update
class UpdateUserProfileLoading extends UserProfileState {}

class UpdateUserProfileData extends UserProfileState {}



