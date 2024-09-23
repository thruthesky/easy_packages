import 'package:easychat/easychat.dart';

class ChatInput {
  final String? text;
  final String? uploadUrl;
  final ChatMessage? replyTo;

  ChatInput({
    this.text,
    this.uploadUrl,
    this.replyTo,
  });
}
