import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter_clone/core/auth/posts.dart';

import '../../../core/auth/post_listener.dart';

enum PostState { success, failed, initial }

class PostCubit extends Cubit<PostState> implements PostListener {
  final _authRepository = PostService();

  PostCubit(PostState initialState) : super(initialState);

  void postTweet({required String message}) {
    _authRepository.postTweet(message: message, postListener: this);
  }

  @override
  void failed() {
    emit(PostState.initial);
    emit(PostState.failed);
  }

  @override
  void success() {
    emit(PostState.success);
  }
}
