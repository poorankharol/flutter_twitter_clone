import 'package:bloc/bloc.dart';
import 'package:flutter_twitter_clone/src/home/model/post_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/posts.dart';

part 'feeds_retweets_state.dart';

class FeedsRetweetsCubit extends Cubit<FeedsRetweetsState> {
  final PostService _postService;
  FeedsRetweetsCubit(this._postService) : super(FeedsRetweetsInitial());

  Future<void> getPostById(String id) async {
    _postService.getPostById(id).then((value) {
      emit(FeedsRetweetsData(value!));
    }).onError((error, stackTrace) {
      emit(FeedsRetweetsError(error.toString()));
    });
  }
}
