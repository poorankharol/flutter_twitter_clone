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
  List<PostModel>? tweets;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.profileImage,
    this.bannerImage,
    this.tweets,
    this.bio,
    this.location,
    this.website,
    this.dob,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        profileImage = json['profileImage'],
        bannerImage = json['bannerImage'],
        bio = json['bio'],
        location = json['location'],
        website = json['website'],
        dob = json['dob'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      //'tweets': tweets,
      'bio': bio,
      'location': location,
      'website': website,
      'dob': dob,
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
}
