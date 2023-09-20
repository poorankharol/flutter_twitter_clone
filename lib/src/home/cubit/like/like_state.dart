part of 'like_cubit.dart';

@immutable
abstract class LikeState {}

class LikeInitial extends LikeState {}

class LikeSuccess extends LikeState with EquatableMixin {
  final bool isLiked;

  LikeSuccess(this.isLiked);

  @override
  List<Object?> get props => [isLiked];
}

class LikeError extends LikeState {
  final String error;

  LikeError(this.error);
}
