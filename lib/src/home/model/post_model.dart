import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String creator;
  final String message;
  final Timestamp timestamp;
  bool isLiked = false;
  bool isRetweeted;
  int likesCount = 0;
  int retweetsCount = 0;
  String originalId;

  PostModel(
      {required this.id,
      required this.creator,
      required this.message,
      required this.timestamp,
      required this.isRetweeted,
      required this.originalId});
}
