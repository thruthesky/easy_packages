import 'package:easyuser/src/widgets/privates/user.circle_avatar.dart';
import 'package:flutter/material.dart';

class AnonymousAvatar extends StatelessWidget {
  const AnonymousAvatar({
    super.key,
    this.size = 48,
    this.radius = 20,
    this.border,
  });

  final double size;
  final double radius;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return UserCircleAvatar(
      size: size,
      radius: radius,
      border: border,
      child: Icon(
        Icons.person,
        size: size / 1.5,
      ),
    );
  }
}
