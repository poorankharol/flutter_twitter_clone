import 'package:bloc/bloc.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/posts.dart';
import '../../../../core/api/user.dart';

part 'feeds_retweets_state.dart';

class FeedsRetweetsCubit extends Cubit<FeedsRetweetsState> {
  final PostService _postService;
  final UserService _userService;

  FeedsRetweetsCubit(this._postService, this._userService)
      : super(FeedsRetweetsInitial());

  Future<void> getPostById(String id) async {
    _postService.getPostById(id).then((model) {
      _postService.getCurrentUserLike(model!).listen((boolean) {
        model.isLiked = boolean;
        _postService.getPostLikeCount(model).listen((event) {
          model.likesCount = event;
          _userService.getUserInfo(model.creator).then((user) {
            model.user = user;
            emit(FeedsRetweetsData(model));
          });
        });
      });
    }).onError((error, stackTrace) {
      emit(FeedsRetweetsError(error.toString()));
    });
  }
}
