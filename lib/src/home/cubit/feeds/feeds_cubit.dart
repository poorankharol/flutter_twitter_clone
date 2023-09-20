import 'package:bloc/bloc.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/posts.dart';

part 'feeds_state.dart';

class FeedsCubit extends Cubit<FeedsState> {
  final PostService _postService;

  FeedsCubit(this._postService) : super(FeedsInitial());

  Future<void> fetchData() async {
    emit(FeedsLoading());
    _postService.getFeeds().then((value) {
      for (var model in value) {
        _postService.getCurrentUserLike(model).listen((boolean) {
          model.isLiked = boolean;
          _postService.getPostLikeCount(model).listen((event) {
            model.likesCount = event;
            emit(FeedsData(value));
          });
        });
      }
    }).onError((error, stackTrace) {
      emit(FeedsError(error.toString()));
    });
  }
}
