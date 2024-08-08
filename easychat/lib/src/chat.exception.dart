class ChatException implements Exception {
  final String code;
  final String message;

  ChatException(
    this.code,
    this.message,
  );

  @override
  String toString() {
    return 'ChatException: ($code) $message';
  }
}
