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
    List<String> userFollowing = await UserService()
        .getUserFollowing(FirebaseAuth.instance.currentUser!.uid);
    userFollowing.add(FirebaseAuth.instance.currentUser!.uid);
    var splitUsers = partition<dynamic>(userFollowing, 1);

    print(splitUsers);
    List<PostModel> feedList = [];

    for (int i = 0; i < splitUsers.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsers.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();
      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }

    feedList.sort((a, b) {
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
        timestamp: data['timeStamp'] ?? 0,
        isRetweeted: data['retweet'] ?? false,
        originalId: data['originalId'] ?? '',
      );
    }).toList();
  }

  Future likePost(PostModel post, bool current) async {
    if (current) {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('likes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({});
    }
  }

  Stream<bool> getCurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) {
      return event.exists;
    });
  }

  Stream<int> getPostLikeCount(PostModel post) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('likes')
        //.doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) {
      return event.size;
    });
  }

  Stream<int> getPostRetweetCount(PostModel post) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('retweets')
        .snapshots()
        .map((event) {
      return event.size;
    });
  }

  Future retweet(PostModel post, bool current) async {
    if (current) {
      //to remove retweet
      post.retweetsCount = post.retweetsCount - 1;
      // print(post.id);
      // await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
      //   'retweet': false,
      // }).then((value) => print("Updated"));

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('retweets')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('posts')
          .where("originalId", isEqualTo: post.id)
          .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          return;
        }
        FirebaseFirestore.instance
            .collection('posts')
            .doc(value.docs[0].id)
            .delete();
      });
      return;
    }

    post.retweetsCount = post.retweetsCount + 1;

    // print(post.id);
    // await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
    //   'retweet': true,
    // }).then((value) => print("Updated"));


    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('retweets')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    await FirebaseFirestore.instance.collection('posts').add({
      'creator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
      'retweet': true,
      'originalId': post.id
    });
  }

  Future<PostModel?> getPostById(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection("posts").doc(id).get();
    return _postFromSnapshot(snapshot);
  }

  PostModel? _postFromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      return PostModel(
        id: snapshot.id,
        creator: data['creator'] ?? '',
        message: data['text'] ?? '',
        timestamp: data['timeStamp'] ?? 0,
        isRetweeted: data['retweet'] ?? false,
        originalId: data['originalId'] ?? '',
      );
    } else {
      return null;
    }
  }
}
