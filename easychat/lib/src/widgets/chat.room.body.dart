import 'dart:async';

import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class ChatRoomBody extends StatefulWidget {
  static const String routeName = '/ChatRoomBody';
  const ChatRoomBody({
    super.key,
    this.onTapFakeInputBox,
    this.hintTextOnFakeInputBox,
    required this.room,
    this.inputBoxPadding = const EdgeInsets.all(0),
    this.inputBoxRadius = 20,
  });
  final VoidCallback? onTapFakeInputBox;
  final String? hintTextOnFakeInputBox;
  final ChatRoom room;
  final EdgeInsets inputBoxPadding;
  final double inputBoxRadius;

  @override
  State<ChatRoomBody> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRoomBody> {
  /// All: Default Chat Room for all users to chat in Home Screen
  /// This is to speed up for displaying the chat room immediately in the Home Screen
  ///
  ChatRoom? _room;
  ChatRoom get room => _room!;
  set room(ChatRoom value) => setState(() => _room = value);

  StreamSubscription? roomUserSubscription;

  @override
  void initState() {
    super.initState();

    _room = widget.room;

    init();
  }

  init() async {
    /// Get the actual chat room information from the database only once
    room = await ChatRoom.get(room.id) ?? room;

    /// Update user list
    roomUserSubscription = room.ref.child("users").onValue.listen((e) {
      room.users = Map<String, bool>.from(e.snapshot.value as Map);
    });
  }

  @override
  void dispose() {
    roomUserSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ChatMessagesListView(
            padding: const EdgeInsets.all(0),
            room: room,
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: widget.inputBoxPadding,
            child: AuthStateChanges(
              builder: (user) {
                return user == null
                    ? FakeChatRoomInputBox(
                        onTap: widget.onTapFakeInputBox,
                        hintText: widget.hintTextOnFakeInputBox,
                        inputBoxRadius: widget.inputBoxRadius,
                      )
                    : ChatRoomInputBox(
                        room: room,
                        beforeSend: (input) async => await ChatService.instance.join(room),
                        inputBoxRadius: widget.inputBoxRadius,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
