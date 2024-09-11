import 'package:easychat/easychat.dart';
import 'package:flutter/material.dart';

class HomeChatScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const ChatOpenRoomListScreen();
  }
}
