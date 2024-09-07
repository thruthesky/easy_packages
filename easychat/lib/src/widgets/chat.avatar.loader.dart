import 'package:flutter/material.dart';

class ChatAvatarLoader extends StatelessWidget {
  const ChatAvatarLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      width: 48,
      height: 48,
      child: const CircularProgressIndicator(),
    );
  }
}
