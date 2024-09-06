import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/screens/chat.open.room.list.screen.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_url_preview/easy_url_preview.dart';

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

  /// Database path for chat room and message
  /// Database of chat room and message
  final DatabaseReference roomsRef =
      FirebaseDatabase.instance.ref().child('chat/rooms');

  DatabaseReference roomRef(String roomId) => roomsRef.child(roomId);

  final DatabaseReference messagesRef =
      FirebaseDatabase.instance.ref().child('chat/messages');

  DatabaseReference messageRef(String roomId) => messagesRef.child(roomId);

  final DatabaseReference joinsRef =
      FirebaseDatabase.instance.ref().child('chat/joins');

  DatabaseReference joinRef(String roomId) =>
      joinsRef.child(myUid!).child(roomId);

  final DatabaseReference invitedUsersRef =
      FirebaseDatabase.instance.ref().child('chat/invited-users');

  DatabaseReference invitedUserRef(String uid) => invitedUsersRef.child(uid);

  final DatabaseReference rejectedUsersRef =
      FirebaseDatabase.instance.ref().child('chat').child('rejected-users');

  DatabaseReference rejectedUserRef(String uid) => rejectedUsersRef.child(uid);

  DatabaseReference get mySettingRef => FirebaseDatabase.instance
      .ref()
      .child('chat')
      .child('settings')
      .child(myUid!);

  DatabaseReference unreadMessageCountRef(String roomId) =>
      mySettingRef.child('unread-message-count').child(roomId);

  /// Callback function
  Future<void> Function({BuildContext context, bool openGroupChatsOnly})?
      $showChatJoinListScreen;

  /// TODO: Add the return type
  Future Function(BuildContext context, {ChatRoom? room})?
      $showChatRoomEditScreen;

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
      chatRoomReceivedInviteListScreenBuilder;

  /// Builder for showing a screen for chat room invites rejected by user.
  Widget Function(BuildContext context)?
      chatRoomRejectedInviteListScreenBuilder;

  /// Builder for showing Dialog for chat member list
  Widget Function(BuildContext context, ChatRoom room)? membersDialogBuilder;

  /// Builder for showing Dialog for blocked user list
  Widget Function(BuildContext context, ChatRoom room)?
      blockedUsersDialogBuilder;

  init({
    Future<void> Function({BuildContext context, bool openGroupChatsOnly})?
        $showChatJoinListScreen,

    /// TODO: Add the return type
    Future Function(BuildContext context, {ChatRoom? room})?
        $showChatRoomEditScreen,
    Function({required ChatMessage message, required ChatRoom room})?
        onSendMessage,
    Function({required ChatRoom room, required String uid})? onInvite,
    Widget Function(ChatRoom)? chatRoomActionButton,
    Widget Function(String no)? newMessageBuilder,
    Widget Function(int invites)? chatRoomInvitationCountBuilder,
    Widget Function(BuildContext context)? loginButtonBuilder,
    Widget Function(BuildContext context)?
        chatRoomReceivedInviteListScreenBuilder,
    Widget Function(BuildContext context)?
        chatRoomRejectedInviteListScreenBuilder,
    Widget Function(BuildContext context, ChatRoom room)? membersDialogBuilder,
    Widget Function(BuildContext context, ChatRoom room)?
        blockedUsersDialogBuilder,
  }) {
    dog('ChatService::init() begins');
    dog('UserService.instance.init();');
    UserService.instance.init();

    initialized = true;

    this.newMessageBuilder = newMessageBuilder;
    this.$showChatJoinListScreen =
        $showChatJoinListScreen ?? this.$showChatJoinListScreen;
    this.$showChatRoomEditScreen =
        $showChatRoomEditScreen ?? this.$showChatRoomEditScreen;
    this.chatRoomActionButton = chatRoomActionButton;
    this.onSendMessage = onSendMessage;
    this.onInvite = onInvite;
    this.loginButtonBuilder = loginButtonBuilder;
    this.chatRoomReceivedInviteListScreenBuilder =
        chatRoomReceivedInviteListScreenBuilder;
    this.chatRoomRejectedInviteListScreenBuilder =
        chatRoomRejectedInviteListScreenBuilder;
    this.membersDialogBuilder = membersDialogBuilder;
    this.blockedUsersDialogBuilder = blockedUsersDialogBuilder;
  }

  /// Show the chat room list screen.
  Future showChatJoinListScreen(
    BuildContext context, {
    bool? single,
    bool? group,
    bool? open,
  }) {
    return $showChatJoinListScreen?.call() ??
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) => ChatJoinListScreen(
            single: single,
            group: group,
            open: open,
          ),
        );
  }

  Future showInviteListScreen(
    BuildContext context,
  ) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) =>
          chatRoomReceivedInviteListScreenBuilder?.call(context) ??
          const ChatRoomReceivedInviteListScreen(),
    );
  }

  Future showOpenChatJoinListScreen(BuildContext context) {
    return $showChatJoinListScreen?.call(
          context: context,
          openGroupChatsOnly: true,
        ) ??
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) => const ChatJoinListScreen(
            open: true,
          ),
        );
  }

  /// Shows the list of all Open rooms, whether user is joined or not
  Future showOpenChatRoomListScreen(BuildContext context) {
    // TODO customization
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => const ChatOpenRoomListScreen(),
    );
  }

  /// Show the chat room edit screen. It's for borth create and update.
  /// Return Dialog/Screen that may return DocReference
  ///
  /// TODO: Add the return type
  Future showChatRoomEditScreen(BuildContext context,
      {ChatRoom? room, bool defaultOpen = false}) {
    return $showChatRoomEditScreen?.call(context, room: room) ??

        /// TODO: Add the return type
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) => ChatRoomEditScreen(
            room: room,
            defaultOpen: defaultOpen,
          ),
        );
  }

  /// Display the chat room screen.
  ///
  /// [join] is the chat join data.
  showChatRoomScreen(
    BuildContext context, {
    User? user,
    ChatRoom? room,
    ChatJoin? join,
  }) async {
    assert(user != null || room != null || join != null);

    if (context.mounted) {
      return showGeneralDialog(
        context: context,
        barrierLabel: "Chat Room",
        pageBuilder: (_, __, ___) => ChatRoomScreen(
          user: user,
          room: room,
          join: join,
        ),
      );
    }
  }

  showRejectListScreen(
    BuildContext context,
  ) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) =>
          chatRoomRejectedInviteListScreenBuilder?.call(context) ??
          const ChatRoomRejectedInviteListScreen(),
    );
  }

  /// send message
  Future<void> sendMessage(
    ChatRoom room, {
    String? photoUrl,
    String? text,
    ChatMessage? replyTo,
  }) async {
    if (room.joined == false) {
      // Rear exception
      throw ChatException('join-required-to-send-message', 'Join required');
    }
    // Create new message
    final newMessage = await ChatMessage.create(
      roomId: room.id,
      text: text,
      url: photoUrl,
      replyTo: replyTo,
    );
    // onSendMessage should be called after sending message
    // other extra process comes after it.
    onSendMessage?.call(message: newMessage, room: room);
    await updateUnreadMessageCountAndJoin(
      room: room,
      text: text,
      photoUrl: photoUrl,
    );
    await inviteOtherUserIfSingleChat(room);
    await updateUrlPreview(newMessage, text);
  }

  /// Update the unread message count.
  ///
  /// Refere README.md for more details
  Future updateUnreadMessageCountAndJoin(
      {required ChatRoom room, String? text, String? photoUrl}) async {
    int timestamp = await getServerTimestamp();
    final Map<String, Object?> updates = {};
    // See README.md for details
    final order = int.parse("-1$timestamp");
    for (String uid in room.userUids) {
      if (uid != myUid) {
        updates['chat/settings/$uid/unread-message-count/${room.id}'] =
            ServerValue.increment(1);
      }
      updates['chat/joins/$uid/${room.id}/$lastMessageAt'] = timestamp;
      updates['chat/joins/$uid/${room.id}/order'] = order;
      if (room.single) {
        updates['chat/joins/$uid/${room.id}/$singleOrder'] = order;
      }
      if (room.group) {
        updates['chat/joins/$uid/${room.id}/$groupOrder'] = order;
      }
      // To display the chat room list information without referring to the chat room.
      updates['chat/joins/$uid/${room.id}/name'] = room.name;
      updates['chat/joins/$uid/${room.id}/iconUrl'] = room.iconUrl;
      updates['chat/joins/$uid/${room.id}/lastText'] = text;
      updates['chat/joins/$uid/${room.id}/lastPhotoUrl'] = photoUrl;
      updates['chat/joins/$uid/${room.id}/lastMessageDeleted'] = null;
      updates['chat/joins/$uid/${room.id}/joinedAt'] = timestamp;
      if (room.single && uid != myUid) {
        updates['chat/joins/$uid/${room.id}/displayName'] = my.displayName;
        updates['chat/joins/$uid/${room.id}/photoUrl'] = my.photoUrl;
      }
    }
    await FirebaseDatabase.instance.ref().update(updates);
    // Write the data first for the speed of performance and then update the
    // other user data.
    // See README.md for details
    if (room.single) {
      User? user = await User.get(getOtherUserUidFromRoomId(room.id)!);
      if (user != null) {
        await FirebaseDatabase.instance.ref().update({
          'chat/joins/${myUid!}/${room.id}/displayName': user.displayName,
          'chat/joins/${myUid!}/${room.id}/photoUrl': user.photoUrl,
        });
      }
    }
  }

  /// Invite the other user if not joined in single chat.
  ///
  /// This is only for single chat.
  ///
  ///
  ///
  /// Where:
  /// - ChatRoomScreen -> ChatRoomInputBox -> inviteOtherUserInSingleChat
  /// - This method can be used in anywhere.
  Future inviteOtherUserIfSingleChat(ChatRoom room) async {
    // Return if it's not single chat
    if (room.single == false) return;

    // Return if both users are already joined
    if (room.userUids.length == 2) return;

    // Return if the other user rejected. Don't send invitation again once rejected.
    final otherUserUid = getOtherUserUidFromRoomId(room.id)!;
    final snapshot =
        await ChatService.instance.rejectedUserRef(otherUserUid).get();
    if (snapshot.exists) {
      return;
    }

    // Invite the other user
    await inviteUser(room, otherUserUid);
  }

  /// Invite a user into the chat room.
  ///
  /// Purpose:
  /// - This can be used to invite a user into the chat room.
  /// - It can be used for single chat and group chat.
  ///
  /// Where:
  /// - It's used in ChatRoomScreen menu to invite a user.
  /// - It's called from ChatService::inviteOtherUserInSingleChat
  /// - This can be used in any where.
  Future inviteUser(ChatRoom room, String uid) async {
    await invitedUserRef(uid).child(room.id).set(ServerValue.timestamp);
    onInvite?.call(room: room, uid: uid);
  }

  /// Leave from Chat Room
  ///
  /// TODO: delete settings also.
  Future<void> leave(ChatRoom room) async {
    final leave = {
      // remove uid in room's user
      roomRef(room.id).child('users').child(myUid!).path: null,
      // remove roomId in user's chat joins
      'chat/joins/${myUid!}/${room.id}': null,
    };
    await FirebaseDatabase.instance.ref().update(leave);
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

  /// States for chat message reply
  ///
  /// Why:
  /// - The reply action is coming from the chat bubble menu.
  /// - And the UI (popup) for the reply appears on top of the chat input box.
  /// - It needs to keep the state whether the reply is enabled or not.
  ValueNotifier<ChatMessage?> reply = ValueNotifier<ChatMessage?>(null);
  bool get replyEnabled => reply.value != null;
  clearReply() => reply.value = null;

  /// Accepts the room invitation
  ///
  /// Logic is very similar to setJoin.
  ///
  /// Alias for `setJoin()`
  Future<void> accept(ChatRoom room) async => await setJoin(room);

  /// Rejects the room invitation
  Future<void> reject(ChatRoom room) async {
    final reject = {
      // Remove the invitation
      invitedUserRef(myUid!).child(room.id).path: null,
      // Add as Rejected Invitaion
      rejectedUserRef(myUid!).child(room.id).path: ServerValue.timestamp,
    };
    await FirebaseDatabase.instance.ref().update(reject);
  }

  /// Set join relation: to list a chat room in my room list
  ///
  /// Why:
  /// - After creating a chat room, the user should be able to see the room in the room list.
  ///
  /// Purpose:
  /// - Call this whenever creating a chat room including single and group chat.
  ///
  Future<void> setJoin(ChatRoom room) async {
    int timestamp = await getServerTimestamp();
    final order = int.parse("-1$timestamp");
    final joinVal = {
      // Incase there is an invitation, remove the invitation
      invitedUserRef(myUid!).child(room.id).path: null,
      // In case, invitation was mistakenly rejected
      rejectedUserRef(myUid!).child(room.id).path: null,
      // Add uid in users
      room.ref.child('users').child(myUid!).path: false,
      // update updatedAt
      room.ref.child('updatedAt').child(myUid!).path: false,
      // Add in chat joins
      'chat/joins/${myUid!}/${room.id}/$joinedAt': ServerValue.timestamp,
      if (room.single) 'chat/joins/${myUid!}/${room.id}/$singleOrder': order,
      if (room.group) 'chat/joins/${myUid!}/${room.id}/$groupOrder': order,
      if (room.open) 'chat/joins/${myUid!}/${room.id}/$openOrder': order,
      'chat/joins/${myUid!}/${room.id}/order': order,
    };
    await FirebaseDatabase.instance.ref().update(joinVal);
  }
}
