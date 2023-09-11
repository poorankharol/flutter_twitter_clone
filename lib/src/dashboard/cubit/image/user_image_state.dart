part of 'user_image_cubit.dart';

@immutable
abstract class UserImageState {}

class UserImageInitial extends UserImageState {}

class UserImageLoading extends UserImageState {}

class UserImageError extends UserImageState {
  final String error;

  UserImageError(this.error);
}

class UserImageData extends UserImageState {
  final String url;
  UserImageData(this.url);
}


