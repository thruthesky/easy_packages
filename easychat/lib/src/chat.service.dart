import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyuser/easyuser.dart';

class ChatService {
  static ChatService? _instance;
  static ChatService get instance => _instance ??= ChatService._();

  ChatService._();

  init() {
    UserService.instance.init();
  }

  CollectionReference get col =>
      FirebaseFirestore.instance.collection('chat-rooms');
}
