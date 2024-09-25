class PostException implements Exception {
  final String code;
  final String message;

  PostException(
    this.code,
    this.message,
  );

  @override
  String toString() {
    return 'PostException: ($code) $message';
  }
}
