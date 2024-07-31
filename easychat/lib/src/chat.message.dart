import 'package:easychat/easychat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessage {
  String id;
  String roomId;
  String? text;
  String? url;
  String? uid;
  int createdAt;
  int order;

  ChatMessage({
    required this.id,
    required this.roomId,
    this.text,
    this.url,
    this.uid,
    required this.createdAt,
    required this.order,
  });

  factory ChatMessage.fromSnapshot(DataSnapshot snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return ChatMessage(
      id: snapshot.key!,
      roomId: data['roomId'],
      text: data['text'],
      url: data['url'],
      uid: data['uid'],
      createdAt: data['createdAt'],
      order: data['order'],
    );
  }

  static ChatMessage fromJson(Map<String, dynamic> json, String id) {
    return ChatMessage(
      id: id,
      roomId: json['roomId'],
      text: json['text'],
      url: json['url'],
      uid: json['uid'],
      createdAt: json['createdAt'],
      order: json['order'],
    );
  }

  static Future<ChatMessage> create({
    required String roomId,
    String? text,
    String? url,
  }) async {
    final newMessageData = {
      'roomId': roomId,
      if (text != null) 'text': text,
      if (url != null) 'url': url,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': ServerValue.timestamp,
      'order': DateTime.now().millisecondsSinceEpoch * -1,
    };
    await ChatService.instance.messageRef(roomId).push().set(newMessageData);
    return ChatMessage(
      id: '',
      roomId: roomId,
      text: text,
      url: url,
      uid: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      order: DateTime.now().millisecondsSinceEpoch * -1,
    );
  }
}
