import 'package:flutter/material.dart';

/// UserCircleAvatar
///
/// Build a circle avatar for user photo.
///
/// [child] is the widget to display inside the circle avatar. It can be any
/// widget.
class UserCircleAvatar extends StatelessWidget {
  const UserCircleAvatar({
    super.key,
    required this.child,
    this.size = 48,
    this.radius = 20,
    this.border,
  });

  final Widget child;
  final double size;
  final double radius;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(radius),
          border: border,
        ),
        child: child,
      ),
    );
  }
}
