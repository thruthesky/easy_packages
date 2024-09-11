import 'package:easy_like/easy_like.dart';

class LikeService {
  static LikeService? _instance;
  static LikeService get instance => _instance ??= LikeService._();
  LikeService._();

  /// Callback after on Like event.
  /// Usage: e.g. send push notification to the user of the event. (post, comment, profile, etc)
  ///
  /// [like] the like object contains `Like` information
  ///
  /// [isLiked] whether the like is liked or not. If the user has liked it, then it is true.
  /// If the user has unliked it (from the state of liked), then it is false.
  Function({required Like like, required bool isLiked})? onLiked;

    FirebaseApp? app,
  init({
    FirebaseApp? app,
    Function({required Like like, required bool isLiked})? onLiked,
  }) {
    this.app = app;
    this.onLiked = onLiked;
  }
}
