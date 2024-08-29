import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:flutter/material.dart';
import 'package:easy_url_preview/easy_url_preview.dart';
import 'package:easy_firestore/easy_firestore.dart';

/// Chat Service
///
/// This is the chat service class that will be used to manage the chat rooms.
class ChatService {
  static ChatService? _instance;
  static ChatService get instance => _instance ??= ChatService._();

  ChatService._() {
    applyChatLocales();
  }

  /// Whether the service is initialized or not.
  ///
  /// Note that, chat service can be initialized multiple times.
  bool initialized = false;

  /// Callback function
  Future<void> Function({BuildContext context, bool openGroupChatsOnly})?
      $showChatRoomListScreen;
  Future<fs.DocumentReference?> Function(BuildContext context,
      {ChatRoom? room})? $showChatRoomEditScreen;

  /// Add custom widget on chatroom header,.
  /// e.g. push notification toggle button to unsubscribe/subscribe to notification
  Widget Function(ChatRoom)? chatRoomActionButton;

  /// Callback on chatMessage send, use this if you want to do task after message is created.,
  /// Usage: e.g. send push notification after message is created
  /// Callback will have the new [message] ChatMessage information and [room] ChatRoom information
  Function({required ChatMessage message, required ChatRoom room})?
      onSendMessage;

  /// Callback on after userInvite. Can be use if you want to do task after invite.
  /// Usage: e.g. send push notification after user was invited
  /// [room] current ChatRoom
  /// [uid] uid of the user that is being invited
  Function({required ChatRoom room, required String uid})? onInvite;

  /// It gets String parameter because the [no] can be something like "3+"
  Widget Function(String no)? newMessageBuilder;

  /// This is used in Chat Room list screen.
  ///
  /// Why? Login in different apps may have different way to present.
  Widget Function(BuildContext context)? loginButtonBuilder;

  /// Builder for showing a screen for chat room invites received by user.
  Widget Function(BuildContext context)?
      receivedChatRoomInviteListScreenBuilder;

  /// Builder for showing a screen for chat room invites rejected by user.
  Widget Function(BuildContext context)?
      rejectedChatRoomInviteListScreenBuilder;

  /// Builder for showing Dialog for chat member list
  Widget Function(BuildContext context, ChatRoom room)? membersDialogBuilder;

  /// Builder for showing Dialog for blocked user list
  Widget Function(BuildContext context, ChatRoom room)?
      blockedUsersDialogBuilder;

  /// User settings
  DocumentModel get setting =>
      DocumentModel(collectionName: 'chat-settings', id: myUid!);
  DocumentModel otherUserSetting(String uid) =>
      DocumentModel(collectionName: 'chat-settings', id: uid);

  init({
    Future<void> Function({BuildContext context, bool openGroupChatsOnly})?
        $showChatRoomListScreen,
    Future<fs.DocumentReference?> Function(BuildContext context,
            {ChatRoom? room})?
        $showChatRoomEditScreen,
    Function({required ChatMessage message, required ChatRoom room})?
        onSendMessage,
    Function({required ChatRoom room, required String uid})? onInvite,
    Widget Function(ChatRoom)? chatRoomActionButton,
    Widget Function(String no)? newMessageBuilder,
    Widget Function(int invites)? chatRoomInvitationCountBuilder,
    Widget Function(BuildContext context)? loginButtonBuilder,
    Widget Function(BuildContext context)?
        receivedChatRoomInviteListScreenBuilder,
    Widget Function(BuildContext context)?
        rejectedChatRoomInviteListScreenBuilder,
    Widget Function(BuildContext context, ChatRoom room)? membersDialogBuilder,
    Widget Function(BuildContext context, ChatRoom room)?
        blockedUsersDialogBuilder,
  }) {
    dog('ChatService::init() begins');
    dog('UserService.instance.init();');
    UserService.instance.init();

    initialized = true;

    this.newMessageBuilder = newMessageBuilder;
    this.$showChatRoomListScreen =
        $showChatRoomListScreen ?? this.$showChatRoomListScreen;
    this.$showChatRoomEditScreen =
        $showChatRoomEditScreen ?? this.$showChatRoomEditScreen;
    this.chatRoomActionButton = chatRoomActionButton;
    this.onSendMessage = onSendMessage;
    this.onInvite = onInvite;
    this.loginButtonBuilder = loginButtonBuilder;
    this.receivedChatRoomInviteListScreenBuilder =
        receivedChatRoomInviteListScreenBuilder;
    this.rejectedChatRoomInviteListScreenBuilder =
        rejectedChatRoomInviteListScreenBuilder;
    this.membersDialogBuilder = membersDialogBuilder;
    this.blockedUsersDialogBuilder = blockedUsersDialogBuilder;

    resetInvitationCount();
  }

  /// Reset the invitation count.
  ///
  /// Since the count may goes wrong, because the security rules is open.
  void resetInvitationCount() async {
    final countSnapshot = await ChatService.instance.roomCol
        .where(ChatRoom.field.invitedUsers, arrayContains: myUid)
        .count()
        .get();

    setting.update(
      {
        'chatInvitationCount': countSnapshot.count,
      },
    );
  }

  /// Firebase CollectionReference for Chat Room docs
  fs.CollectionReference get roomCol =>
      fs.FirebaseFirestore.instance.collection('chat-rooms');

  /// Firebase chat collection query by new message counter for the current user.
  fs.Query get myRoomQuery => roomCol.orderBy(
      '${ChatRoom.field.users}.$myUid.${ChatRoomUser.field.newMessageCounter}');

  /// CollectionReference for Chat Room Meta docs
  fs.CollectionReference roomMetaCol(String roomId) =>
      fs.FirebaseFirestore.instance
          .collection('chat-rooms')
          .doc(roomId)
          .collection('chat-room-meta');

  /// DocumentReference for chat room private settings.
  fs.DocumentReference roomPrivateDoc(String roomId) =>
      roomMetaCol(roomId).doc('private');

  db.DatabaseReference messageRef(String roomId) =>
      db.FirebaseDatabase.instance.ref().child("chat-messages").child(roomId);

  /// Show the chat room list screen.
  Future showChatRoomListScreen(
    BuildContext context, {
    ChatRoomQuery queryOption = ChatRoomQuery.allMine,
  }) {
    return $showChatRoomListScreen?.call() ??
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) => ChatRoomListScreen(
            queryOption: queryOption,
          ),
        );
  }

  Future showInviteListScreen(
    BuildContext context,
  ) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) =>
          receivedChatRoomInviteListScreenBuilder?.call(context) ??
          const ReceivedChatRoomInviteListScreen(),
    );
  }

  Future showOpenChatRoomListScreen(BuildContext context) {
    return $showChatRoomListScreen?.call(
          context: context,
          openGroupChatsOnly: true,
        ) ??
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) => const ChatRoomListScreen(
            queryOption: ChatRoomQuery.open,
          ),
        );
  }

  /// Show the chat room edit screen. It's for borth create and update.
  /// Return Dialog/Screen that may return DocReference
  Future<fs.DocumentReference?> showChatRoomEditScreen(BuildContext context,
      {ChatRoom? room}) {
    return $showChatRoomEditScreen?.call(context, room: room) ??
        showGeneralDialog<fs.DocumentReference>(
          context: context,
          pageBuilder: (_, __, ___) => ChatRoomEditScreen(room: room),
        );
  }

  showChatRoomScreen(BuildContext context, {User? user, ChatRoom? room}) {
    assert(user != null || room != null);
    return showGeneralDialog(
      context: context,
      barrierLabel: "Chat Room",
      pageBuilder: (_, __, ___) => ChatRoomScreen(
        user: user,
        room: room,
      ),
    );
  }

  showRejectListScreen(
    BuildContext context,
  ) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) =>
          rejectedChatRoomInviteListScreenBuilder?.call(context) ??
          const RejectedChatRoomInviteListScreen(),
    );
  }

  Future sendMessage(
    ChatRoom room, {
    String? photoUrl,
    String? text,
    ChatMessage? replyTo,
  }) async {
    if ((text ?? "").isEmpty && (photoUrl == null || photoUrl.isEmpty)) return;
    await _shouldBeOrBecomeMember(room);

    final newMessage = await ChatMessage.create(
      roomId: room.id,
      text: text,
      url: photoUrl,
      replyTo: replyTo,
    );
    await room.updateNewMessagesMeta();
    updateUrlPreview(newMessage, text);

    onSendMessage?.call(message: newMessage, room: room);
  }

  /// URL Preview 업데이트
  ///
  /// 채팅 메시지 자체에 업데이트하므로, 한번만 가져온다.
  Future updateUrlPreview(ChatMessage message, String? text) async {
    /// Update url preview
    final model = UrlPreviewModel();
    await model.load(text);

    if (model.hasData) {
      await message.update(
        previewUrl: model.firstLink,
        previewTitle: model.title,
        previewDescription: model.description,
        previewImageUrl: model.image,
      );
    }
  }

  _shouldBeOrBecomeMember(
    ChatRoom room,
  ) async {
    if (room.joined) return;
    if (room.open) return await room.join();
    if (room.invitedUsers.contains(myUid!) ||
        room.rejectedUsers.contains(myUid!)) {
      // The user may mistakenly reject the chat room
      // The user may accept it by replying.
      return await room.acceptInvitation();
    }
    throw ChatException(
      "uninvited-chat",
      'can only send message if member, invited or open chat'.t,
    );
  }

  Future<void> showEditMessageDialog(
    BuildContext context, {
    required ChatMessage message,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditChatMessageDialog(
          message: message,
        );
      },
    );
  }

  /// states for chat message reply
  ValueNotifier<ChatMessage?> reply = ValueNotifier<ChatMessage?>(null);
  bool get replyEnabled => reply.value != null;
  clearReply() => reply.value = null;

  /// Get chat rooms
  ///
  ///
  Future<List<ChatRoom>> getChatRooms({
    required fs.Query query,
  }) async {
    final snapshot = await query.get();
    if (snapshot.size == 0) return [];
    return snapshot.docs.map((e) => ChatRoom.fromSnapshot(e)).toList();
  }

  /// Why is it in UserService? Not in user.dart model?
  /// This is because; this method updates other user docuemnt. Not the login user's document.
  Future<void> increaseInvitationCount(String otherUid) async {
    await otherUserSetting(otherUid).update(
      {
        'chatInvitationCount': fs.FieldValue.increment(1),
      },
    );
  }

  /// It decreases the invitation count of the currently logged-in user.
  Future<void> decreaseInvitationCount() async {
    await setting.update(
      {
        'chatInvitationCount': fs.FieldValue.increment(-1),
      },
    );
  }
}
