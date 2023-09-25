part of 'replies_cubit.dart';

@immutable
abstract class RepliesState {}

class RepliesInitial extends RepliesState {}
class RepliesLoading extends RepliesState {}
class RepliesSuccess extends RepliesState {}
class RepliesError extends RepliesState {
}
