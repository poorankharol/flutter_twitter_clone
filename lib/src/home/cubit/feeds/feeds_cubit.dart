import 'package:bloc/bloc.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/posts.dart';
import '../../../../core/api/user.dart';

part 'feeds_state.dart';

class FeedsCubit extends Cubit<FeedsState> {
  final PostService _postService;
  final UserService _userService;

  FeedsCubit(this._postService, this._userService) : super(FeedsInitial());

  Future<void> fetchData() async {
    emit(FeedsLoading());
    _postService.getFeeds().then((value) {
      if (value.isNotEmpty) {
        for (var model in value) {
          _postService.getCurrentUserLike(model).listen((boolean) {
            model.isLiked = boolean;
            _postService.getPostLikeCount(model).listen((event) {
              model.likesCount = event;
              _postService.getPostRetweetCount(model).listen((event) {
                model.retweetsCount = event;
                _userService.getUserInfo(model.creator).then((user) {
                  model.user = user;
                  emit(FeedsData(value));
                });
              });
            });
          });
        }
      } else {
        emit(FeedsData(value));
      }
    }).onError((error, stackTrace) {
      emit(FeedsError(error.toString()));
    });
  }
}
