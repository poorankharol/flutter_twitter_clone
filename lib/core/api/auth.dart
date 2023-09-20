import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone/core/api/auth_registration_listener.dart';
import 'package:username_generator/username_generator.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  void login({
    required String email,
    required String password,
    required AuthRegistrationListener authRegistrationListener,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    required String name,
    required String email,
    required String password,
    required AuthRegistrationListener authRegistrationListener,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var generator = UsernameGenerator();
      generator.separator = '_'; // optional
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(
        {
          'name': name,
          'email': userCredential.user?.email,
          "uid": userCredential.user?.uid,
          'profileImage': '',
          'bannerImage': '',
          'bio': '',
          'location': '',
          'website': '',
          'dob': '',
          'username': generator.generate(name)
        },
      );

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
