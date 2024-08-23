import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessageField {
  static const id = 'id';
  static const roomId = 'roomId';
  static const text = 'text';
  static const url = 'url';
  static const uid = 'uid';
  static const createdAt = 'createdAt';
  static const order = 'order';
  static const replyTo = 'replyTo';
  static const deleted = 'deleted';
  static const editedAt = 'editedAt';
  static const previewUrl = 'previewUrl';
  static const previewTitle = 'previewTitle';
  static const previewDescription = 'previewDescription';
  static const previewImageUrl = 'previewImageUrl';

  ChatMessageField._();
}

class ChatMessage {
  String id;
  String? roomId;
  String? text;
  String? url;
  String? uid;
  int createdAt;
  int? order;
  ChatMessage? replyTo;
  final bool deleted;
  int? editedAt;

  bool get isEdited => editedAt != null;

  DatabaseReference get ref =>
      ChatService.instance.messageRef(roomId!).child(id);

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
    this.editedAt,
  });

  factory ChatMessage.fromSnapshot(DataSnapshot snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return ChatMessage.fromJson(data, snapshot.key!);
  }

  static ChatMessage fromJson(Map<String, dynamic> json, String id) {
    final replyTo = json[ChatMessageField.replyTo] == null
        ? null
        : Map<String, dynamic>.from(json[ChatMessageField.replyTo] as Map);
    return ChatMessage(
      id: id,
      roomId: json[ChatMessageField.roomId],
      text: json[ChatMessageField.text],
      url: json[ChatMessageField.url],
      uid: json[ChatMessageField.uid],
      createdAt: json[ChatMessageField.createdAt],
      order: json[ChatMessageField.order],
      replyTo: replyTo == null
          ? null
          : ChatMessage.fromJson(replyTo, replyTo[ChatMessageField.id]),
      // Added '?? false' because this it RTDB
      // Reason: There is no use for saving false in deleted.
      deleted: json[ChatMessageField.deleted] ?? false,
      editedAt: json[ChatMessageField.editedAt],
    );
  }

  static Future<ChatMessage> create({
    required String roomId,
    String? text,
    String? url,
    ChatMessage? replyTo,
  }) async {
    final replyToData = replyTo == null
        ? null
        : {
            ChatMessageField.id: replyTo.id,
            // Save only upto 20 characters in text
            // This is reply anyway, we don't have to
            // show and save the whole text.
            if (replyTo.text != null)
              ChatMessageField.text: replyTo.text!.length > 80
                  ? "${replyTo.text?.substring(0, 77)}..."
                  : replyTo.text,
            if (replyTo.url != null) ChatMessageField.url: replyTo.url,
            ChatMessageField.uid: replyTo.uid,
            ChatMessageField.createdAt: replyTo.createdAt,
            ChatMessageField.deleted: replyTo.deleted,
          };
    final newMessageData = {
      ChatMessageField.roomId: roomId,
      if (text != null) ChatMessageField.text: text,
      if (url != null) ChatMessageField.url: url,
      ChatMessageField.uid: FirebaseAuth.instance.currentUser!.uid,
      ChatMessageField.createdAt: ServerValue.timestamp,
      ChatMessageField.order: DateTime.now().millisecondsSinceEpoch * -1,
      if (replyTo != null) ChatMessageField.replyTo: replyToData,
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
      replyTo: replyTo == null
          ? null
          : ChatMessage.fromJson(replyToData!, replyTo.id),
      deleted: false,
    );
  }

  /// To delete url, update it into empty string
  ///
  /// NOTE: Should not be used directly, use
  /// updateMessage in chat service instead.
  ///
  /// ChatService.instance.updateMessage.
  Future update({
    String? text,
    String? url,
    ChatMessage? replyTo,
    bool isEdit = false,
    String? previewUrl,
    String? previewTitle,
    String? previewDescription,
    String? previewImageUrl,
  }) async {
    final updateData = {
      if (text != null) ChatMessageField.text: text,
      if (url != null) ChatMessageField.url: url,
      if (url?.isEmpty == true) ChatMessageField.url: null,
      if (replyTo != null)
        ChatMessageField.replyTo: {
          ChatMessageField.id: replyTo.id,
          // Save only upto 80 characters in text
          // This is reply anyway, we don't have to
          // show and save the whole text.
          if (replyTo.text != null)
            ChatMessageField.text: replyTo.text!.length > 80
                ? "${replyTo.text?.substring(0, 77)}..."
                : replyTo.text,
          if (replyTo.url != null) ChatMessageField.url: replyTo.url,
          ChatMessageField.uid: replyTo.uid,
          ChatMessageField.createdAt: replyTo.createdAt,
          ChatMessageField.deleted: replyTo.deleted,
        },
      if (isEdit) ChatMessageField.editedAt: ServerValue.timestamp,
      if (previewUrl != null) ChatMessageField.previewUrl: previewUrl,
      if (previewTitle != null) ChatMessageField.previewTitle: previewTitle,
      if (previewDescription != null)
        ChatMessageField.previewDescription: previewDescription,
      if (previewImageUrl != null)
        ChatMessageField.previewImageUrl: previewImageUrl,
    };
    await ref.update(updateData);
    this.text = text;
    this.url = url;
    this.replyTo = replyTo;
  }

  /// To delete the message
  ///
  /// NOTE: Pleaase use Chat Service in deleting message.
  /// ChatService.instance.deleteMessage
  Future<void> delete() async {
    if (uid != myUid) {
      throw ChatException(
        'delete-only-own-message',
        'You can only delete your own message.',
      );
    }

    List<Future> futures = [
      if (url != null) StorageService.instance.delete(url!),
      if (replyTo?.url != null) StorageService.instance.delete(replyTo!.url!),
      ref.update({
        ChatMessageField.deleted: true,
        ChatMessageField.text: null,
        ChatMessageField.url: null,
        ChatMessageField.replyTo: null,
        ChatMessageField.previewUrl: null,
        ChatMessageField.previewTitle: null,
        ChatMessageField.previewDescription: null,
        ChatMessageField.previewImageUrl: null,
      }),
    ];
    // If error is caught here, check all the futures.
    await Future.wait(futures);
  }
}
