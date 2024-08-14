class LikeException implements Exception {
  final String code;
  final String message;

  LikeException(
    this.code,
    this.message,
  );

  @override
  String toString() {
    return 'LikeException: ($code) $message';
  }
}
