import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatRoom {
  CollectionReference get col =>
      FirebaseFirestore.instance.collection('chat-rooms');

  /// 여기서 부터... FireFlutter v-2024-07-08 을 보고 코드 복사 할 것.
}
