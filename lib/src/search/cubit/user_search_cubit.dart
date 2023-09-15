import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/api/user.dart';
import '../../../core/model/user.dart';

part 'user_search_state.dart';

class UserSearchCubit extends Cubit<UserSearchState> {
  final UserService _userService;

  UserSearchCubit(this._userService) : super(UserSearchInitial());

  Future<void> searchUser() async {
    emit(UserSearchLoading());
    _userService.searchUser().listen((value) {
      emit(UserSearchData(value));
    }).onError((handleError) {
      emit(UserSearchError(handleError.toString()));
    });
  }
}
