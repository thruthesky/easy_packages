import 'dart:async';

import 'package:easy_locale/easy_locale.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easychat/easychat.dart';
import 'package:easychat/src/enums/order_type.dart';
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

  FirebaseDatabase get database => FirebaseDatabase.instance;

  /// Database path for chat room and message
  /// Database of chat room and message
  DatabaseReference get roomsRef => database.ref().child('chat/rooms');

  DatabaseReference roomRef(String roomId) => roomsRef.child(roomId);

  DatabaseReference get messagesRef => database.ref().child('chat/messages');

  DatabaseReference messageRef(String roomId) => messagesRef.child(roomId);

  DatabaseReference get joinsRef => database.ref().child('chat/joins');

  DatabaseReference joinRef(String roomId) => joinsRef.child(myUid!).child(roomId);

  /// Reference: the list of user and the room list that the user invited to.
  DatabaseReference get invitedUsersRef => database.ref().child('chat/invited-users');

  /// Reference: the chat room list that the user invited to.
  DatabaseReference invitedUserRef(String uid) => invitedUsersRef.child(uid);

  /// Reference: the chat room list that the login user invited to.
  DatabaseReference get myInvitationsRef => invitedUserRef(myUid!);

  final DatabaseReference rejectedUsersRef =
      FirebaseDatabase.instance.ref().child('chat').child('rejected-users');

  DatabaseReference rejectedUserRef(String uid) => rejectedUsersRef.child(uid);

  DatabaseReference get mySettingRef =>
      FirebaseDatabase.instance.ref().child('chat').child('settings').child(myUid!);

  /// Reference: the login user's unread message count of the chat room
  DatabaseReference unreadMessageCountRef(String roomId) =>
      mySettingRef.child('unread-message-count').child(roomId);

  /// Callback function
  Future<T?> Function<T>({BuildContext context, bool openGroupChatsOnly})? $showChatRoomListScreen;

  Future<T?> Function<T>(BuildContext context, {ChatRoom? room})? $showChatRoomEditScreen;

  /// Openn chat room screen
  Future<T?> Function<T>(BuildContext context)? $showOpenChatRoomListScreen;

  /// Add custom widget on chatroom header,.
  /// e.g. push notification toggle button to unsubscribe/subscribe to notification
  Widget Function(ChatRoom)? chatRoomActionButton;

  /// Callback on chatMessage send, use this if you want to do task after message is created.,
  /// Usage: e.g. send push notification after message is created
  /// Callback will have the new [message] ChatMessage information and [room] ChatRoom information
  FutureOr<void> Function({required ChatMessage message, required ChatRoom room})? onSendMessage;

  /// Callback on after userInvite. Can be use if you want to do task after invite.
  /// Usage: e.g. send push notification after user was invited
  /// [room] current ChatRoom
  /// [uid] uid of the user that is being invited
  FutureOr<void> Function({required ChatRoom room, required String uid})? onInvite;

  /// It gets String parameter because the [no] can be something like "3+"
  Widget Function(String no)? newMessageBuilder;

  /// This is used in Chat Room list screen.
  ///
  /// Why? Login in different apps may have different way to present.
  Widget Function(BuildContext context)? loginButtonBuilder;

  /// Builder for showing a screen for chat room invites received by user.
  Widget Function(BuildContext context)? chatRoomReceivedInviteListScreenBuilder;

  /// Builder for showing a screen for chat room invites rejected by user.
  Widget Function(BuildContext context)? chatRoomRejectedInviteListScreenBuilder;

  /// Builder for showing Dialog for chat member list
  Widget Function(BuildContext context, ChatRoom room)? membersDialogBuilder;

  /// Builder for showing Dialog for blocked user list
  Widget Function(BuildContext context, ChatRoom room)? blockedUsersDialogBuilder;

  OpenOrderType openOrderType = OpenOrderType.lastSeen;

  init({
    Future<T?> Function<T>({BuildContext context, bool openGroupChatsOnly})? $showChatRoomListScreen,
    Future<T?> Function<T>(BuildContext context, {ChatRoom? room})? $showChatRoomEditScreen,
    Function({required ChatMessage message, required ChatRoom room})? onSendMessage,
    Function({required ChatRoom room, required String uid})? onInvite,
    Widget Function(ChatRoom)? chatRoomActionButton,
    Widget Function(String no)? newMessageBuilder,
    Widget Function(int invites)? chatRoomInvitationCountBuilder,
    Widget Function(BuildContext context)? loginButtonBuilder,
    Widget Function(BuildContext context)? chatRoomReceivedInviteListScreenBuilder,
    Widget Function(BuildContext context)? chatRoomRejectedInviteListScreenBuilder,
    Widget Function(BuildContext context, ChatRoom room)? membersDialogBuilder,
    Widget Function(BuildContext context, ChatRoom room)? blockedUsersDialogBuilder,
    OpenOrderType orderType = OpenOrderType.lastSeen,
  }) {
    dog('ChatService::init() begins');
    dog('UserService.instance.init();');
    UserService.instance.init();

    initialized = true;

    openOrderType = orderType;

    this.newMessageBuilder = newMessageBuilder;
    this.$showChatRoomListScreen = $showChatRoomListScreen ?? this.$showChatRoomListScreen;
    this.$showChatRoomEditScreen = $showChatRoomEditScreen ?? this.$showChatRoomEditScreen;
    this.chatRoomActionButton = chatRoomActionButton;
    this.onSendMessage = onSendMessage;
    this.onInvite = onInvite;
    this.loginButtonBuilder = loginButtonBuilder;
    this.chatRoomReceivedInviteListScreenBuilder = chatRoomReceivedInviteListScreenBuilder;
    this.chatRoomRejectedInviteListScreenBuilder = chatRoomRejectedInviteListScreenBuilder;
    this.membersDialogBuilder = membersDialogBuilder;
    this.blockedUsersDialogBuilder = blockedUsersDialogBuilder;
  }

  /// Show the chat room list screen.
  Future<T?> showChatRoomListScreen<T>(
    BuildContext context, {
    bool? single,
    bool? group,
    bool? open,
  }) {
    return $showChatRoomListScreen?.call<T>() ??
        showGeneralDialog<T>(
          context: context,
          pageBuilder: (_, __, ___) => ChatRoomListScreen(
            single: single,
            group: group,
            open: open,
          ),
        );
  }

  Future<T?> showInviteListScreen<T>(
    BuildContext context,
  ) async {
    return await showGeneralDialog<T>(
      context: context,
      pageBuilder: (_, __, ___) =>
          chatRoomReceivedInviteListScreenBuilder?.call(context) ??
          const ChatRoomReceivedInviteListScreen(),
    );
  }

  Future<T?> showOpenChatJoinListScreen<T>(BuildContext context) {
    return $showChatRoomListScreen?.call<T>(
          context: context,
          openGroupChatsOnly: true,
        ) ??
        showGeneralDialog<T>(
          context: context,
          pageBuilder: (_, __, ___) => const ChatRoomListScreen(
            open: true,
          ),
        );
  }

  /// Shows the list of all Open rooms, whether user is joined or not
  Future<T?> showOpenChatRoomListScreen<T>(BuildContext context) {
    return $showOpenChatRoomListScreen?.call<T>(context) ??
        showGeneralDialog<T>(
          context: context,
          pageBuilder: (_, __, ___) => const ChatOpenRoomListScreen(),
        );
  }

  /// Show the chat room edit screen. It's for borth create and update.
  /// Return Dialog/Screen that may return DocReference
  ///
  Future<T?> showChatRoomEditScreen<T>(
    BuildContext context, {
    ChatRoom? room,
    bool open = false,
    EdgeInsets? tilePadding,
  }) {
    return $showChatRoomEditScreen?.call<T>(context, room: room) ??
        showGeneralDialog<T>(
          context: context,
          pageBuilder: (_, __, ___) => ChatRoomEditScreen(
            room: room,
            open: open,
            tilePadding: tilePadding,
          ),
        );
  }

  /// Wrapper of showChatRoomEditScreen
  Future<T?> showChatRoomCreateScreen<T>(
    BuildContext context, {
    bool open = false,
    EdgeInsets? tilePadding,
  }) async {
    return await showChatRoomEditScreen(
      context,
      open: open,
      tilePadding: tilePadding,
    );
  }

  /// Display the chat room screen.
  ///
  /// [join] is the chat join data.
  Future<T?> showChatRoomScreen<T>(
    BuildContext context, {
    User? user,
    ChatRoom? room,
    ChatJoin? join,
  }) async {
    assert(user != null || room != null || join != null);
    if (!context.mounted) return null;
    return await showGeneralDialog<T>(
      context: context,
      barrierLabel: "Chat Room",
      pageBuilder: (_, __, ___) => ChatRoomScreen(
        user: user,
        room: room,
        join: join,
      ),
    );
  }

  Future<T?> showRejectListScreen<T>(
    BuildContext context,
  ) {
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (_, __, ___) =>
          chatRoomRejectedInviteListScreenBuilder?.call(context) ??
          const ChatRoomRejectedInviteListScreen(),
    );
  }

  /// Send message
  ///
  /// Note that, it should only do the task that is related to sending message.
  Future<void> sendMessage(
    ChatRoom room, {
    String? text,
    String? photoUrl,
    String? protocol,
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
      protocol: protocol,
      replyTo: replyTo,
    );
    // onSendMessage should be called after sending message
    // other extra process comes after it.
    await onSendMessage?.call(message: newMessage, room: room);
    await updateUnreadMessageCountAndJoinAfterMessageSent(
      room: room,
      text: text,
      photoUrl: photoUrl,
      protocol: protocol,
    );
    await updateUrlPreview(newMessage, text);
  }

  Future<void> deleteLastMessageInJoins(ChatRoom room) async {
    final Map<String, Object?> updates = {};
    for (String uid in room.userUids) {
      updates['chat/joins/$uid/${room.id}/$lastMessageDeleted'] = true;
      updates['chat/joins/$uid/${room.id}/$lastText'] = null;
      updates['chat/joins/$uid/${room.id}/$lastUrl'] = null;
      updates['chat/joins/$uid/${room.id}/$lastProtocol'] = null;
    }
    await FirebaseDatabase.instance.ref().update(updates);
  }

  Future<void> updateLastMessageInChatJoins(
    ChatRoom room,
    ChatMessage updatedMessage,
  ) async {
    final Map<String, Object?> updates = {};
    for (String uid in room.userUids) {
      updates['chat/joins/$uid/${room.id}/$lastMessageDeleted'] =
          updatedMessage.deleted == true ? true : null;
      updates['chat/joins/$uid/${room.id}/$lastMessageUid'] = updatedMessage.uid;
      updates['chat/joins/$uid/${room.id}/$lastText'] =
          updatedMessage.text.isNullOrEmpty ? null : updatedMessage.text;
      updates['chat/joins/$uid/${room.id}/$lastUrl'] =
          (updatedMessage.url?.trim()).isNullOrEmpty ? null : updatedMessage.url;
      updates['chat/joins/$uid/${room.id}/$lastProtocol'] = updatedMessage.protocol;
    }
    await FirebaseDatabase.instance.ref().update(updates);
  }

  /// Update the unread message count and chat join relations.
  ///
  /// Purpose:
  /// - To update the chat joins of the chat room user with the last message information.
  /// - To update the unread message count of the chat room user.
  ///
  /// Refere README.md for more details
  Future<void> updateUnreadMessageCountAndJoinAfterMessageSent({
    required ChatRoom room,
    String? text,
    String? photoUrl,
    String? protocol,
  }) async {
    int timestamp = await getServerTimestamp();
    dog("Updating");
    final Map<String, Object?> updates = {};
    // See README.md for details
    final moreImportant = int.parse("-1$timestamp");
    final lessImportant = -1 * timestamp;
    for (String uid in room.userUids) {
      if (uid == myUid) {
        // If it's my join data, the order must not have -11 infront since I
        // have already read that chat room. (I am in the chat room)
        updates['chat/joins/$uid/${room.id}/order'] = lessImportant;
        if (room.single) {
          updates['chat/joins/$uid/${room.id}/$singleOrder'] = lessImportant;
        }
        if (room.group) {
          updates['chat/joins/$uid/${room.id}/$groupOrder'] = lessImportant;
        }
        if (room.open) {
          updates['chat/joins/$uid/${room.id}/$openOrder'] = lessImportant;
        }
        // updates['chat/settings/$uid/unread-message-count/${room.id}'] = null;
      } else {
        updates['chat/joins/$uid/${room.id}/order'] = moreImportant;
        if (room.single) {
          updates['chat/joins/$uid/${room.id}/$singleOrder'] = moreImportant;
        }
        if (room.group) {
          updates['chat/joins/$uid/${room.id}/$groupOrder'] = moreImportant;
        }
        if (room.open) {
          updates['chat/joins/$uid/${room.id}/$openOrder'] = moreImportant;
        }

        /// Increment the unread message count if the message is not
        /// - join,
        /// - left,
        /// - or invitation-not-sent
        if (protocol != ChatProtocol.join &&
            protocol != ChatProtocol.left &&
            protocol != ChatProtocol.invitationNotSent) {
          updates['chat/settings/$uid/unread-message-count/${room.id}'] = ServerValue.increment(1);
          updates['chat/joins/$uid/${room.id}/unread-message-count'] = ServerValue.increment(1);
        }
      }

      updates['chat/joins/$uid/${room.id}/$lastMessageAt'] = timestamp;

      // Add more about chat room info, to display the chat room list
      // information without referring to the chat room.
      updates['chat/joins/$uid/${room.id}/$lastMessageUid'] = myUid;
      updates['chat/joins/$uid/${room.id}/$lastText'] = text;
      updates['chat/joins/$uid/${room.id}/$lastUrl'] = photoUrl;
      updates['chat/joins/$uid/${room.id}/$lastProtocol'] = protocol;
      updates['chat/joins/$uid/${room.id}/lastMessageDeleted'] = null;

      if (room.single && uid != myUid) {
        updates['chat/joins/$uid/${room.id}/displayName'] = my.displayName;
        updates['chat/joins/$uid/${room.id}/photoUrl'] = my.photoUrl;
      } else if (room.group) {
        updates['chat/joins/$uid/${room.id}/name'] = room.name;
        updates['chat/joins/$uid/${room.id}/iconUrl'] = room.iconUrl;
      }

      // If it's group chat, add the sender's information
      if (room.group) {
        updates['chat/joins/$uid/${room.id}/displayName'] = my.displayName;
        updates['chat/joins/$uid/${room.id}/photoUrl'] = my.photoUrl;
      }
    }

    // Must save the last message at in room to properly reorder it upon seening the message.
    updates['chat/rooms/${room.id}/$lastMessageAt'] = timestamp;
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

  /// Reset the login user's unread message count and re-order the chat joins.
  ///
  /// From:
  /// - ChatRoomScreen
  ///
  /// Why:
  /// - To reset the unread message count and re-order the chat joins.
  ///
  /// Note:
  /// - If the order is based on the `room.lastMessageAt`, then the chat room will be placed in the order of the last message.
  /// - If the order is based on the `current time`, then the chat room will be placed in the order of the last seen.
  Future<void> resetUnreadMessage(ChatRoom room) async {
    /// Reset the unread message count
    final Map<String, Object?> resetUnread = {
      // unreadMessageCountRef(room.id).path: 0,
      // REVIEW: Is it better if we will save null?
      unreadMessageCountRef(room.id).path: null,
    };

    /// Re-order
    final lastMessageAt =
        room.lastMessageAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;

    int updatedOrder = lastMessageAt * -1;
    if (openOrderType == OpenOrderType.lastMessage) {
      // Do nothing.
      // The updatedOrder is already using lastMessageAt * -1;
    } else if (openOrderType == OpenOrderType.lastSeen) {
      updatedOrder = DateTime.now().millisecondsSinceEpoch * -1;
    }
    resetUnread['chat/joins/${myUid!}/${room.id}/order'] = updatedOrder;
    resetUnread['chat/joins/${myUid!}/${room.id}/unread-message-count'] = null;
    if (room.single) {
      resetUnread['chat/joins/${myUid!}/${room.id}/$singleOrder'] = updatedOrder;
    }
    if (room.group) {
      resetUnread['chat/joins/${myUid!}/${room.id}/$groupOrder'] = updatedOrder;
    }
    if (room.open) {
      resetUnread['chat/joins/${myUid!}/${room.id}/$openOrder'] = updatedOrder;
    }
    await FirebaseDatabase.instance.ref().update(resetUnread);
  }

  /// Join a chat room
  ///
  /// This method is used to join a chat room.
  ///
  ///
  /// Where:
  /// - It is called after the chat room created.
  /// - It is called after the user accepted the invitation.
  ///
  /// Logic:
  /// - It update the room.users with current user's uid. It's called as
  /// call-by-reference. So, the parent can use the updated room.users which
  /// includes the current user's uid.
  Future<void> join(
    ChatRoom room, {
    String? protocol,
  }) async {
    dog("Joining");

    if (room.joined) return;

    final timestamp = await getServerTimestamp();
    final negativeTimestamp = -1 * timestamp;

    // int timestamp = await getServerTimestamp();
    // final order = timestamp * -1; // int.parse("-1$timestamp");
    final joinValues = {
      // Incase there is an invitation, remove the invitation
      invitedUserRef(myUid!).child(room.id).path: null,
      // In case, invitation was mistakenly rejected
      rejectedUserRef(myUid!).child(room.id).path: null,
      // Add uid in users
      room.ref.child('users').child(myUid!).path: true,
      // Add in chat joins
      'chat/joins/${myUid!}/${room.id}/$joinedAt': ServerValue.timestamp,
      // Should be in top in order
      // This will make the newly joined room at top.
      'chat/joins/${myUid!}/${room.id}/$order': negativeTimestamp,
      if (room.single) 'chat/joins/${myUid!}/${room.id}/$singleOrder': negativeTimestamp,
      if (room.group) 'chat/joins/${myUid!}/${room.id}/$groupOrder': negativeTimestamp,
      if (room.open) 'chat/joins/${myUid!}/${room.id}/$openOrder': negativeTimestamp,
    };

    /// Add your uid into the user list of the chat room instead of reading from database.
    /// * This must be here before await. So it can return fast.
    room.users[myUid!] = true;
    await FirebaseDatabase.instance.ref().update(joinValues);
    await sendMessage(room, protocol: protocol ?? ChatProtocol.join);
  }

  /// Invite the other user on a 1:1 chat and delete invitation not sent message.
  ///
  /// This is only for single chat.
  ///
  /// Purpose:
  /// - To send the invitation to the other user if the other user is
  ///   - not joined
  ///   - not rejected
  ///   - not invited
  ///
  /// Where:
  /// - ChatRoomScreen -> ChatRoomInputBox -> inviteOtherUserInSingleChat
  /// - This method can be used in anywhere.
  Future<void> inviteOtherUserIfSingleChat(ChatRoom room) async {
    // Return if it's not single chat
    if (room.single == false) return;

    // Return if both users are already joined
    if (room.userUids.length == 2) return;

    // Return if the other user rejected. Don't send invitation again once rejected.
    final otherUserUid = getOtherUserUidFromRoomId(room.id)!;

    // Check if the other user rejected the invitation already
    final rejectedSnapshot = await ChatService.instance.rejectedUserRef(otherUserUid).child(room.id).get();
    if (rejectedSnapshot.exists) {
      // Take note that if we are using a separator,
      // using SizedBox.shrink here will not look good.)
      return;
    }

    // Check if the other user is already invited
    final invitedSnapshot = await ChatService.instance.invitedUserRef(otherUserUid).child(room.id).get();
    if (invitedSnapshot.exists) {
      return;
    }

    // Invite the other user
    await inviteUser(room, otherUserUid);
  }

  /// Get the invitation value (which is saved as an int) and return as DateTime
  Future<DateTime?> getInvitation(String roomId) async {
    final invitation = (await invitedUserRef(myUid!).child(roomId).get());
    if (invitation.exists) {
      // The invitation is saved as negative for ordering.
      final timestamp = (invitation.value as int).abs();
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  /// Get the rejection value (which is saved as an int) and return as DateTime
  Future<DateTime?> getRejection(String roomId) async {
    final rejection = (await rejectedUserRef(myUid!).child(roomId).get());
    if (rejection.exists) {
      final timestamp = (rejection.value as int).abs();
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  /// Delete the invitation-not-sent message.
  ///
  /// Why:
  /// - The invitation-not-sent protocol message is created when the chat room
  /// creator creates the 1:1 chat room. And it needs to be deleted after the
  /// first message is sent to the other user since the invitation will be
  /// sent to the other user automatically on the first message. And if the
  /// protocol message of invitation-not-sent still appears on the screen, it's
  /// confusing. That's why it needs to be deleted.
  ///
  /// - But why the code is like this?
  /// If another query made on the same node of the chat masssage list view,
  /// it will change(affect) the query of the chat message list view. That's
  /// why it does not query, but checks the index and the message protocol.
  /// And if it's the 'invitation-not-sent' protocol, it deletes the message.
  ///
  /// Refer README.md for more details.
  Future<void> deleteInvitationNotSentMessage({
    required int index,
    required ChatMessage message,
    required int length,
  }) async {
    /// Why: length is bigger than 2 and less than 7?
    /// - It's because the first message is expected to be the invitation-not-sent message
    /// So, if there is only one message, it means, the invitation-not-sent message is not sent.
    /// And if there are more than 7 messages, it means, the invitation-not-sent message is
    /// probably deleted.
    if (length >= 2 &&
        length <= 7 &&
        message.protocol == ChatProtocol.invitationNotSent &&
        message.uid == myUid) {
      await message.ref.remove();
    }
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
  Future<void> inviteUser(ChatRoom room, String uid) async {
    // To prevent the invitation from getting overlooked or from
    // getting buried by earlier ignored invitations.
    final reverseOrder = (await getServerTimestamp()) * -1;
    await invitedUserRef(uid).child(room.id).set(reverseOrder);
    await onInvite?.call(room: room, uid: uid);
  }

  /// Leave from Chat Room
  ///
  /// Removes uid in Room's users field
  /// Deletes the chat joins
  /// Deletes the mySettings that is related to the room
  Future<void> leave(ChatRoom room) async {
    final leave = {
      // remove uid in room's user
      roomRef(room.id).child('users').child(myUid!).path: null,

      // delete user's chat join (of the room)
      'chat/joins/${myUid!}/${room.id}': null,

      // For now, this is the only setting to be deleted.
      // Other settings must be deleted, as well.
      mySettingRef.child('unread-message-count').child(room.id).path: null,
    };
    await sendMessage(room, protocol: ChatProtocol.left);
    await FirebaseDatabase.instance.ref().update(leave);
  }

  /// URL Preview 업데이트
  ///
  /// 채팅 메시지 자체에 업데이트하므로, 한번만 가져온다.
  Future<void> updateUrlPreview(ChatMessage message, String? text) async {
    /// Update url preview
    final model = UrlPreviewModel();
    await model.load(text);
    if (!model.hasData) return;
    await message.update(
      previewUrl: model.firstLink,
      previewTitle: model.title,
      previewDescription: model.description,
      previewImageUrl: model.image,
    );
  }

  Future<void> showEditMessageDialog(
    BuildContext context, {
    required ChatMessage message,
    FutureOr<void> Function()? onSave,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return EditChatMessageDialog(
          message: message,
          onSave: onSave,
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
  /// Logic is very similar to join.
  ///
  /// Alias for `join()`
  Future<void> accept(ChatRoom room) async => await join(room);

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

  /// Removes and blocks the user from the group
  Future<void> block(ChatRoom room, String uid) async {
    // throw 'Not implemented yet';
    // 1. check if the user is the master
    if (!room.masterUsers.contains(myUid!)) {
      throw ChatException(
        "not-master",
        "you are not the master to block someone in this room".t,
      );
    }
    // 2. check if the user can be blocked
    if (room.blockedUids.contains(uid)) {
      throw ChatException(
        "already-blocked",
        "user is already blocked".t,
      );
    }
    // 3. block the user
    final blockUpdates = {
      room.ref.child('blockedUsers').child(uid).path: true,
      room.ref.child('users').child(uid).path: null,
      'chat/joins/$uid/${room.id}': null,
    };
    await FirebaseDatabase.instance.ref().update(blockUpdates);
    // TODO protocol on removing from the group
    // Issue: How can we pass who was removed from the group?
    // await sendMessage(room, protocol: ChatProtocol.removed);
  }

  /// Removes user from the blocklist of the group
  Future<void> unblock(ChatRoom room, String uid) async {
    // 1. check if the user is the master
    if (!room.masterUsers.contains(myUid!)) {
      throw ChatException(
        "not-master",
        "you are not the master to unblock someone in this room".t,
      );
    }
    // 2. check if the user can be unblocked
    if (!room.blockedUids.contains(uid)) {
      throw ChatException(
        "not-blocked",
        "User is already not blocked",
      );
    }
    // 3. unblock the user
    await room.ref.child('blockedUsers').child(uid).set(null);
  }

  /// Returns the number of invitations that the LOGIN user has.
  Future<int> getMyInvitationCount() async {
    final DataSnapshot snapshot = await myInvitationsRef.get();
    return snapshot.children.length;
  }
}
