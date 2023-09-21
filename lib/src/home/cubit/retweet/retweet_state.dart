part of 'retweet_cubit.dart';

@immutable
abstract class RetweetState {}

class RetweetInitial extends RetweetState {}

class RetweetSuccess extends RetweetState with EquatableMixin {
  final bool isRetweeted;

  RetweetSuccess(this.isRetweeted);

  @override
  List<Object?> get props => [isRetweeted];
}

class RetweetError extends RetweetState {
  final String error;

  RetweetError(this.error);
}

