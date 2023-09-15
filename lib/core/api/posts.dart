import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone/core/api/post_listener.dart';

class PostService {
  void postTweet({
    required String message,
    required PostListener postListener,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("posts").add({
        'text': message,
        "creator": FirebaseAuth.instance.currentUser!.uid,
        "timeStamp": FieldValue.serverTimestamp()
      });
      postListener.success();
    } catch (e) {
      print(e);
      postListener.failed();
    }
  }
}
