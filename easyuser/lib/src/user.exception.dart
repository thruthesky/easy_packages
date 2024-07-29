class UserException implements Exception {
  final String code;
  final String message;

  UserException(this.code, this.message);

  @override
  String toString() {
    return 'UserException: ($code) $message';
  }
}
