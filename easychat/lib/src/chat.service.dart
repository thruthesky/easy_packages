import 'package:easyuser/easyuser.dart';

class ChatService {
  static ChatService? _instance;
  static ChatService get instance => _instance ??= ChatService._();

  ChatService._();

  init() {
    UserService.instance.init();
  }
}
