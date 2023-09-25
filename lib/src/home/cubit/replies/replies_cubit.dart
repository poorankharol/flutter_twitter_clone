import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/api/post_listener.dart';
import '../../../../core/api/posts.dart';
import '../../model/post_model.dart';

part 'replies_state.dart';

class RepliesCubit extends Cubit<RepliesState> implements PostListener {
  final _authRepository = PostService();

  RepliesCubit(RepliesState initialState) : super(initialState);

  void postReply({
    required PostModel post,
    required String message,
  }) {
    _authRepository.postReply(
      message: message,
      postListener: this,
      post: post,
    );
  }

  @override
  void failed() {
    emit(RepliesInitial());
    emit(RepliesError());
  }

  @override
  void success() {
    emit(RepliesSuccess());
  }
}
