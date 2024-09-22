import 'package:flutter/material.dart';

class FakeChatRoomInputBox extends StatelessWidget {
  const FakeChatRoomInputBox({
    super.key,
    this.onTap,
    this.hintText,
    this.inputBoxRadius = 12,
  });

  final VoidCallback? onTap;
  final String? hintText;
  final double inputBoxRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(inputBoxRadius)),
            ),
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.camera_alt),
            suffixIcon: const Icon(Icons.send),
            hintText: hintText,
            enabled: false,
          ),
        ),
      ),
    );
  }
}
