import '../../src/home/model/post_model.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? bannerImage;
  final String? bio;
  final String? location;
  final String? website;
  final String? dob;
  final String? username;
  List<PostModel>? tweets;

  UserModel(
      {this.uid,
      this.name,
      this.email,
      this.profileImage,
      this.bannerImage,
      this.tweets,
      this.bio,
      this.location,
      this.website,
      this.dob,
      this.username});

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        profileImage = json['profileImage'],
        bannerImage = json['bannerImage'],
        bio = json['bio'],
        location = json['location'],
        website = json['website'],
        dob = json['dob'],
        username = json['username'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'bio': bio,
      'location': location,
      'website': website,
      'dob': dob,
      'username': username,
    };
  }

  Map<String, dynamic> toFireStoreMap() {
    return {
      'name': name,
      'bio': bio ?? '',
      'location': location ?? '',
      'website': website ?? '',
      'dob': dob ?? '',
    };
  }

  // copyWith(UserModel userData) {
  //   return UserModel(
  //     uid: userData.uid,
  //       name : userData.name,
  //       email : email'],
  //       profileImage : profileImage'],
  //       bannerImage : bannerImage'],
  //       bio : bio'],
  //       location : location'],
  //       website : website'],
  //       dob : dob'],
  //       username : username']
  //   );
  // }
}
