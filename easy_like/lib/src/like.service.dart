import 'package:easy_like/easy_like.dart';

class LikeService {
  static LikeService? _instance;
  static LikeService get instance => _instance ??= LikeService._();
  LikeService._();

  /// Callback after on Like event. usage, eg. push notification
  Function({required Like like, required bool isLiked})? onLike;

  init({
    Function({required Like like, required bool isLiked})? onLike,
  }) {
    this.onLike = onLike;
  }
}
