part of 'feeds_cubit.dart';

@immutable
abstract class FeedsState {}

class FeedsInitial extends FeedsState {}

class FeedsLoading extends FeedsState {}

class FeedsError extends FeedsState {
  final String error;

  FeedsError(this.error);
}

class FeedsData extends FeedsState {
  final List<PostModel> data;

  FeedsData(this.data);
}