abstract class AuthRegistrationListener {
  void success();
  void failed();
  void userExists();
  void weakPassword();
}