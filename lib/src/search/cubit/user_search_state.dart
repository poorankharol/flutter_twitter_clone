part of 'user_search_cubit.dart';

@immutable
abstract class UserSearchState {}

class UserSearchInitial extends UserSearchState {}

class UserSearchLoading extends UserSearchState {}

class UserSearchError extends UserSearchState {
  final String error;

  UserSearchError(this.error);
}

class UserSearchData extends UserSearchState {
  final List<UserModel> data;

  UserSearchData(this.data);
}
