import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/auth/auth.dart';
import '../../../core/auth/auth_registration_listener.dart';

enum RegisterUserState { success, user_exists, weak_password, failed, initial }

class RegisterUserCubit extends Cubit<RegisterUserState>
    implements AuthRegistrationListener {
  final _authRepository = AuthService();

  RegisterUserCubit(RegisterUserState initialState) : super(initialState);

  void registerUser(
      {required String name, required String email, required String password}) {
    _authRepository.register(
      email: email,
      password: password,
      authRegistrationListener: this,
      name: name,
    );
  }

  @override
  void failed() {
    emit(RegisterUserState.initial);
    emit(RegisterUserState.failed);
  }

  @override
  void success() {
    emit(RegisterUserState.success);
  }

  @override
  void userExists() {
    emit(RegisterUserState.initial);
    emit(RegisterUserState.user_exists);
  }

  @override
  void weakPassword() {
    emit(RegisterUserState.initial);
    emit(RegisterUserState.weak_password);
  }
}
