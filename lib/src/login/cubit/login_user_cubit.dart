import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth.dart';
import '../../../core/auth/auth_registration_listener.dart';

enum LoginUserState { success, user_exists, weak_password, failed, initial }

class LoginUserCubit extends Cubit<LoginUserState>
    implements AuthRegistrationListener {
  final _authRepository = AuthService();

  LoginUserCubit(LoginUserState initialState) : super(initialState);

  void loginUser({required String email, required String password}) {
    _authRepository.register(
      email: email,
      password: password,
      authRegistrationListener: this,
    );
  }

  @override
  void failed() {
    emit(LoginUserState.initial);
    emit(LoginUserState.failed);
  }

  @override
  void success() {
    emit(LoginUserState.success);
  }

  @override
  void userExists() {
    emit(LoginUserState.initial);
    emit(LoginUserState.user_exists);
  }

  @override
  void weakPassword() {
    emit(LoginUserState.initial);
    emit(LoginUserState.weak_password);
  }
}
