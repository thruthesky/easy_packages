import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// TODO ChatMessageField

class ChatMessage {
  String id;
  String roomId;
  String? text;
  String? url;
  String? uid;
  int createdAt;
  int order;
  ChatMessage? replyTo;
  final bool deleted;

  ChatMessage({
    required this.id,
    required this.roomId,
    this.text,
    this.url,
    this.uid,
    required this.createdAt,
    required this.order,
    this.replyTo,
    required this.deleted,
  });

  factory ChatMessage.fromSnapshot(DataSnapshot snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return ChatMessage.fromJson(data, snapshot.key!);
  }

  static ChatMessage fromJson(Map<String, dynamic> json, String id) {
    final replyTo = json['replyTo'] == null
        ? null
        : Map<String, dynamic>.from(json['replyTo'] as Map);
    return ChatMessage(
      id: id,
      roomId: json['roomId'],
      text: json['text'],
      url: json['url'],
      uid: json['uid'],
      createdAt: json['createdAt'],
      order: json['order'],
      replyTo:
          replyTo == null ? null : ChatMessage.fromJson(replyTo, replyTo['id']),
      // Added '?? false' because this it RTDB
      // Reason: There is no use for saving false in deleted.
      deleted: json['deleted'] ?? false,
    );
  }

  static Future<ChatMessage> create({
    required String roomId,
    String? text,
    String? url,
    ChatMessage? replyTo,
  }) async {
    // TODO review
    // Must not include replyTo since it may cause deeper
    // nesting of data.
    // TODO must only save few chars of text
    final replyToData = {
      if (replyTo?.id != null) 'id': replyTo?.id,
      if (replyTo?.roomId != null) 'roomId': replyTo?.roomId,
      if (replyTo?.text != null) 'text': replyTo?.text,
      if (replyTo?.url != null) 'url': replyTo?.url,
      if (replyTo?.uid != null) 'uid': replyTo?.uid,
      if (replyTo?.createdAt != null) 'createdAt': replyTo?.createdAt,
      if (replyTo?.order != null) 'order': replyTo?.order,
    };
    final newMessageData = {
      'roomId': roomId,
      if (text != null) 'text': text,
      if (url != null) 'url': url,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'createdAt': ServerValue.timestamp,
      'order': DateTime.now().millisecondsSinceEpoch * -1,
      if (replyTo != null) 'replyTo': replyToData,
      // There is no usage in saving 'deleted': false in RTDB
      // 'deleted': false,
    };
    final ref = ChatService.instance.messageRef(roomId).push();
    await ref.set(newMessageData);
    return ChatMessage(
      id: ref.key!,
      roomId: roomId,
      text: text,
      url: url,
      uid: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      order: DateTime.now().millisecondsSinceEpoch * -1,
      replyTo: replyTo,
      deleted: false,
    );
  }

  delete() async {
    if (uid != myUid) {
      throw ChatException(
        'delete-only-own-message',
        'You can only delete your own message.',
      );
    }
    // Use update instead
    await ChatService.instance.messageRef(roomId).child(id).update({
      'text': null,
      'url': null,
      'replyTo': null,
      'deleted': true,
    });
  }
}
