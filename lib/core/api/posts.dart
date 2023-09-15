import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone/core/api/post_listener.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';

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

  List<PostModel> _postListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      return PostModel(
          id: doc.id,
          creator: data['creator'] ?? '',
          message: data['text'] ?? '',
          timestamp: data['timeStamp'] ?? 0);
    }).toList();
  }

  Stream<List<PostModel>> getPostByUser({required String uid}) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }
}
