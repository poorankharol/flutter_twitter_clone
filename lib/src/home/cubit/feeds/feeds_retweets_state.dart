part of 'feeds_retweets_cubit.dart';

@immutable
abstract class FeedsRetweetsState {}

class FeedsRetweetsInitial extends FeedsRetweetsState {}
class FeedsRetweetsData extends FeedsRetweetsState {
  final PostModel model;

  FeedsRetweetsData(this.model);
}
class FeedsRetweetsError extends FeedsRetweetsState {
  final String error;
  FeedsRetweetsError(this.error);
}

