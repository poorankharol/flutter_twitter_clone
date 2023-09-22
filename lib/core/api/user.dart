import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../src/home/model/post_model.dart';
import '../model/user.dart';

class UserService {
  /*Get User Info*/
  Future<UserModel> getUserInfo(String uid) async {
    final data = FirebaseFirestore.instance.collection("users").doc(uid).get();
    var document = await data.whenComplete(() => null);
    return UserModel(
      uid: uid,
      name: document['name'] ?? '',
      email: document['email'] ?? '',
      profileImage: document['profileImage'] ?? '',
      bannerImage: document['bannerImage'] ?? '',
      bio: document['bio'] ?? '',
      location: document['location'] ?? '',
      website: document['website'] ?? '',
      dob: document['dob'] ?? '',
      username: document['username'] ?? '',
    );
  }

  Future<List<String>> getUserFollowing(uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('following')
        .get();
    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
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
        originalId: data['originalId']?? '',
      );
    }).toList();
  }

  Stream<List<PostModel>> getUserTweets({required String uid}) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  /*Get Profile Pic*/
  Future<String> getProfilePicture({
    required String uid,
  }) async {
    String profileImg = '';
    profileImg = await FirebaseStorage.instance
        .ref("user/profile/$uid/profile")
        .getDownloadURL();
    return profileImg;
  }

  /*Update Profile Pic*/
  Future<String> updateProfilePicture({
    required File? profileImage,
  }) async {
    String profileImg = '';
    if (profileImage != null) {
      profileImg = await uploadFile(profileImage,
          "user/profile/${FirebaseAuth.instance.currentUser!.uid}/profile");
    }

    Map<String, Object> data = HashMap();
    if (profileImg.isNotEmpty) data['profileImage'] = profileImg;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);

    return profileImg;
  }

  /*Update Banner*/
  Future<String> updateBanner({
    required File? bannerImage,
  }) async {
    String bannerImg = '';
    if (bannerImage != null) {
      bannerImg = await uploadFile(bannerImage,
          "user/profile/${FirebaseAuth.instance.currentUser!.uid}/banner");
    }
    Map<String, Object> data = HashMap();
    if (bannerImg.isNotEmpty) data['bannerImage'] = bannerImg;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    return bannerImg;
  }

  /*Upload File*/
  Future<String> uploadFile(File img, String path) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref(path);
    await storageRef.putFile(img).whenComplete(() {});
    String downloadUrl = '';
    await storageRef.getDownloadURL().then((value) {
      downloadUrl = value;
    });
    return downloadUrl;
  }

  /*Update Profile*/
  Future<void> updateProfile(UserModel userModel) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userModel.toFireStoreMap());
  }

  /*Search User*/
  List<UserModel> _userListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      return UserModel.fromJson(data);
    }).toList();
  }

  Stream<List<UserModel>> searchUser() {
    return FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .map(_userListFromSnapshot);
  }

  /*Is Following*/

  Stream<bool> isFollowing(String uid, String otherUid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .doc(otherUid)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.exists;
      },
    );
  }

  Future<void> followUser(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("following")
        .doc(uid)
        .set({});

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
  }

  Future<void> unFollowUser(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("following")
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }
}
