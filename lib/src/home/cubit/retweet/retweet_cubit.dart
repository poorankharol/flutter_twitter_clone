import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/posts.dart';
import '../../model/post_model.dart';

part 'retweet_state.dart';

class RetweetCubit extends Cubit<RetweetState> {

  final PostService _postService;

  RetweetCubit(this._postService) : super(RetweetInitial());

  Future<void> retweetPost(PostModel post, bool current) async {
    _postService
        .retweet(post, current)
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  // Future<void> getCurrentUserLike(PostModel postModel) async {
  //   _postService.getCurrentUserLike(postModel).listen((boolean) {
  //     emit(RetweetSuccess(boolean));
  //   });
  // }
}
