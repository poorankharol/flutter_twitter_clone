import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/user.dart';

class UserService {
  Future<UserModel> getUserDataByUid(String uid) async {
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
    );
  }

  // UserModel _postListFromSnapshot(QuerySnapshot querySnapshot) {
  //   return querySnapshot.docs.map((doc) {
  //     Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
  //     return UserModel(
  //       uid: "",
  //       email: data['email'],
  //       phoneNumber: data['phoneNumber'] ?? '',
  //       profileImage: data['profileImage'] ?? '',
  //       bannerImage: data['bannerImage'] ?? '',
  //     );
  //   });
  // }

  Future<String> getProfilePicture({
    required String uid,
  }) async {
    String profileImg = '';
    profileImg = await FirebaseStorage.instance
        .ref("user/profile/$uid/profile")
        .getDownloadURL();
    return profileImg;
  }

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
}
