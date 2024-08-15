import 'package:easy_like/easy_like.dart';

class LikeService {
  static LikeService? _instance;
  static LikeService get instance => _instance ??= LikeService._();
  LikeService._();

  /// Callback after on Like event. usage, eg. push notification
  ///
  /// [like] the like object
  ///
  /// [isLiked] whether the like is liked or not. If the user has liked it, then it is true.
  /// If the user has unliked it (from the state of liked), then it is false.
  Function({required Like like, required bool isLiked})? onLiked;

  init({
    Function({required Like like, required bool isLiked})? onLiked,
  }) {
    this.onLiked = onLiked;
  }
}
