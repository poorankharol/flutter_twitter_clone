import '../../src/home/model/post_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profileImage;
  final String? bannerImage;
  final String? bio;
  final String? location;
  final String? website;
  final String? dob;
  List<PostModel>? tweets;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    this.bannerImage,
    this.tweets,
    this.bio,
    this.location,
    this.website,
    this.dob,
  });
}
