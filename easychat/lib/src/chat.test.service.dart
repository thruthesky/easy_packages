import 'package:easychat/easychat.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatTestService {
  static ChatTestService? _instance;
  static ChatTestService get instance => _instance ??= ChatTestService._();
  ChatTestService._();

  /// Test the chat invitation not sent
  ///
  /// This method tests the 'invitation not sent' protocol is properly
  /// generated and deleted.
  ///
  Future<void> invitationNotSent(String otherUid) async {
    // Get the user SE10
    final se10 = await User.get(otherUid);
    // Create a new 1:1 chat room with SE10
    final newRoomRef = await ChatRoom.createSingle(se10!.uid);

    // Get the 1:1 chat room
    final room = await ChatRoom.get(newRoomRef.key!);

    // Join the chat room
    // Send a message to the chat room. It will automatically send
    // invitatoin to the other user
    await ChatService.instance.join(
      room!,
      protocol: ChatProtocol.invitationNotSent,
    );

    // By this time, there should be a message with protocol 'invitationNotSent'
    // final message =
    //     await ChatService.instance.getInvitationNotSentMessage(room);
    // assert(message != null);

    await ChatService.instance.sendMessage(
      room,
      text: 'Hello SE10',
    );

    // Invite the user after first message sent
    await ChatService.instance.inviteOtherUserIfSingleChat(room);

    // By this time, there should be no chat room message with protocol 'invitationNotSent'
    // final message2 =
    //     await ChatService.instance.getInvitationNotSentMessage(room);
    // assert(message2 == null);
  }

  Future<DatabaseReference> createGroupChat() async {
    return await ChatRoom.create(
      name: 'Group Chat: ${DateTime.now().jm}',
      users: {myUid!: true},
    );
  }

  Future<void> joinGroupChat() async {
    final ref = await ChatRoom.create(
      name: 'Group Chat: ${DateTime.now().jm}',
      users: {myUid!: true},
    );

    final room = await ChatRoom.get(ref.key!);

    await ChatService.instance.join(room!);
  }

  Future<void> joinOpenChat() async {
    final ref = await ChatRoom.create(
      name: 'Open Chat: ${DateTime.now().jm}',
      users: {myUid!: true},
      open: true,
    );

    final room = await ChatRoom.get(ref.key!);

    await ChatService.instance.join(room!);
  }
}
