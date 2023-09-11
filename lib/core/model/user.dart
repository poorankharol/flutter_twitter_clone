import '../../src/home/model/post_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phoneNumber;
  final String profileImage;
  final String? bannerImage;
  List<PostModel>? tweets;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.profileImage,
    this.bannerImage,
    this.tweets,
  });
}
