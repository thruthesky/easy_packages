import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// Chat invitation count builder widget
///
/// If the user didn't signed in, it will build with the value of 0.
class ChatInvitationCount extends StatelessWidget {
  const ChatInvitationCount({super.key, required this.builder});

  final Widget Function(int count) builder;

  @override
  Widget build(BuildContext context) {
    /// TODO: Implement the real logic
    return AuthStateChanges(
      builder: (user) => user == null ? builder(0) : builder(9999),
    );
  }
}
