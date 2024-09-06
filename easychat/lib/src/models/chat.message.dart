import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessage {
  /// Field names for the Chat Message Model
  static const field = (
    id: 'id',
    roomId: 'roomId',
    text: 'text',
    url: 'url',
    uid: 'uid',
    createdAt: 'createdAt',
    order: 'order',
    replyTo: 'replyTo',
    deleted: 'deleted',
    updatedAt: 'updatedAt',
    previewUrl: 'previewUrl',
    previewTitle: 'previewTitle',
    previewDescription: 'previewDescription',
    previewImageUrl: 'previewImageUrl',
    protocol: 'protocol',
  );

  String id;
  String? roomId;
  String? uid;
  int createdAt;
  int? updatedAt;
  int? order;
  String? text;
  String? url;
  String? protocol;
  final bool deleted;

  String? previewUrl;
  String? previewTitle;
  String? previewDescription;
  String? previewImageUrl;

  ChatMessage? replyTo;

  bool get isUpdated => updatedAt != null;

  DatabaseReference get ref =>
      ChatService.instance.messagesRef.child(roomId!).child(id);

  ChatMessage({
    required this.id,
    required this.roomId,
    this.text,
    this.url,
    this.protocol,
    this.uid,
    required this.createdAt,
    required this.order,
    this.replyTo,
    required this.deleted,
    this.updatedAt,
    this.previewUrl,
    this.previewTitle,
    this.previewDescription,
    this.previewImageUrl,
  });

  factory ChatMessage.fromSnapshot(DataSnapshot snapshot) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return ChatMessage.fromJson(data, snapshot.key!);
  }

  static ChatMessage fromJson(Map<String, dynamic> json, String id) {
    final replyTo = json[field.replyTo] == null
        ? null
        : Map<String, dynamic>.from(json[field.replyTo] as Map);
    return ChatMessage(
      id: id,
      roomId: json[field.roomId],
      text: json[field.text],
      url: json[field.url],
      protocol: json[field.protocol],
      uid: json[field.uid],
      createdAt: json[field.createdAt],
      order: json[field.order],
      replyTo: replyTo == null
          ? null
          : ChatMessage.fromJson(replyTo, replyTo[field.id]),
      // Added '?? false' because this it RTDB
      // Reason: There is no use for saving false in deleted.
      deleted: json[field.deleted] ?? false,
      updatedAt: json[field.updatedAt],
      previewUrl: json[field.previewUrl],
      previewTitle: json[field.previewTitle],
      previewDescription: json[field.previewDescription],
      previewImageUrl: json[field.previewImageUrl],
    );
  }

  static Future<ChatMessage> create({
    required String roomId,
    String? text,
    String? url,
    String? protocol,
    ChatMessage? replyTo,
  }) async {
    final replyToData = replyTo == null
        ? null
        : {
            field.id: replyTo.id,
            // Save only upto 20 characters in text
            // This is reply anyway, we don't have to
            // show and save the whole text.
            if (replyTo.text != null)
              field.text: replyTo.text!.length > 80
                  ? "${replyTo.text?.substring(0, 77)}..."
                  : replyTo.text,
            if (replyTo.url != null) field.url: replyTo.url,
            field.uid: replyTo.uid,
            field.createdAt: replyTo.createdAt,
            field.deleted: replyTo.deleted,
          };
    final newMessageData = {
      field.roomId: roomId,
      if (text != null) field.text: text,
      if (url != null) field.url: url,
      if (protocol != null) field.protocol: protocol,
      field.uid: FirebaseAuth.instance.currentUser!.uid,
      field.createdAt: ServerValue.timestamp,
      field.order: DateTime.now().millisecondsSinceEpoch * -1,
      if (replyTo != null) field.replyTo: replyToData,
    };
    final ref = ChatService.instance.messagesRef.child(roomId).push();
    await ref.set(newMessageData);
    return ChatMessage(
      id: ref.key!,
      roomId: roomId,
      text: text,
      url: url,
      protocol: protocol,
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
      if (text != null) field.text: text,
      if (url != null) field.url: url,
      if (url?.isEmpty == true) field.url: null,
      if (replyTo != null)
        field.replyTo: {
          field.id: replyTo.id,
          // Save only upto 80 characters in text
          // This is reply anyway, we don't have to
          // show and save the whole text.
          if (replyTo.text != null)
            field.text: replyTo.text!.length > 80
                ? "${replyTo.text?.substring(0, 77)}..."
                : replyTo.text,
          if (replyTo.url != null) field.url: replyTo.url,
          field.uid: replyTo.uid,
          field.createdAt: replyTo.createdAt,
          field.deleted: replyTo.deleted,
        },
      if (isEdit) field.updatedAt: ServerValue.timestamp,
      if (previewUrl != null) field.previewUrl: previewUrl,
      if (previewTitle != null) field.previewTitle: previewTitle,
      if (previewDescription != null)
        field.previewDescription: previewDescription,
      if (previewImageUrl != null) field.previewImageUrl: previewImageUrl,
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
        field.deleted: true,
        field.text: null,
        field.url: null,
        field.replyTo: null,
        field.previewUrl: null,
        field.previewTitle: null,
        field.previewDescription: null,
        field.previewImageUrl: null,
      }),
    ];
    // If error is caught here, check all the futures.
    await Future.wait(futures);
  }
}
