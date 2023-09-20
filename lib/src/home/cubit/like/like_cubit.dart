import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/posts.dart';
import '../../model/post_model.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  final PostService _postService;

  LikeCubit(this._postService) : super(LikeInitial());

  Future<void> likePost(PostModel post, bool current) async {
    _postService
        .likePost(post, current)
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  Future<void> getCurrentUserLike(PostModel postModel) async {
    _postService.getCurrentUserLike(postModel).listen((boolean) {
      emit(LikeSuccess(boolean));
    });
  }
}
