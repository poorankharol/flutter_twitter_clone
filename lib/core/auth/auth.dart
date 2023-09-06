import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone/core/auth/auth_registration_listener.dart';
import 'package:flutter_twitter_clone/core/model/user.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? _currentUser(User user) {
    return user != null ? UserModel(id: user.uid) : null;
  }

  void login({
    required String email,
    required String password,
    required AuthRegistrationListener authRegistrationListener,
  }) async {
    try {
      User user = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ) as User;
      //_currentUser(user);
      //userCredential.user.sendEmailVerification();
      //authInstance.signOut();
      authRegistrationListener.success();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        authRegistrationListener.weakPassword();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        authRegistrationListener.userExists();
      }
    } catch (e) {
      print(e);
      authRegistrationListener.failed();
    }
  }

  void register({
    required String email,
    required String password,
    required AuthRegistrationListener authRegistrationListener,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //_currentUser(user);
      authRegistrationListener.success();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        authRegistrationListener.weakPassword();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        authRegistrationListener.userExists();
      }
    } catch (e) {
      print(e);
      authRegistrationListener.failed();
    }
  }

  void signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}