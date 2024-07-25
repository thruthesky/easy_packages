import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UserBuildAvatar extends StatelessWidget {
  const UserBuildAvatar({
    super.key,
    required this.user,
    this.size = 48,
    this.radius = 20,
    this.border,
  });

  final User user;
  final double size;
  final double radius;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return user.photoUrl == null
        ? Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: border,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Center(
              child: Text(
                user.displayName.isEmpty
                    ? user.uid[0].toUpperCase()
                    : user.displayName[0].toUpperCase(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: size / 1.5,
                    ),
              ),
            ),
          )
        : UserBuildCircleAvatar(
            size: size,
            radius: radius,
            border: border,
            child: CachedNetworkImage(
              imageUrl: user.photoUrl!,
              fit: BoxFit.cover,
            ),
          );
    // ClipRRect(
    //     borderRadius: BorderRadius.circular(radius),
    //     child: Container(
    //       width: size,
    //       height: size,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(radius),
    //         border: border,
    //       ),
    //       child: CachedNetworkImage(
    //         imageUrl: user.photoUrl!,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   );
  }
}

class UserBuildCircleAvatar extends StatelessWidget {
  const UserBuildCircleAvatar({
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
