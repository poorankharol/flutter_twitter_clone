import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone/core/api/post_listener.dart';
import 'package:flutter_twitter_clone/core/api/user.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:quiver/iterables.dart';

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

  Future<List<PostModel>> getFeeds() async {
    Iterable<String> userFollowing = await UserService()
        .getUserFollowing(FirebaseAuth.instance.currentUser!.uid);

    var splitUsers = partition<dynamic>(userFollowing!, 10);
    List<PostModel> feedList = [];

    for (int i = 0; i < splitUsers.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsers.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();
      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }

    feedList.sort((a,b){
      var atimeStamp = a.timestamp;
      var btimeStamp = b.timestamp;
      return btimeStamp.compareTo(atimeStamp);
    });

    return feedList;
  }

  /*Get User Tweets*/
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
}
