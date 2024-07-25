import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:easyuser/src/widgets/privates/user.circle_avatar.dart';
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
        : UserCircleAvatar(
            size: size,
            radius: radius,
            border: border,
            child: CachedNetworkImage(
              imageUrl: user.photoUrl!,
              fit: BoxFit.cover,
            ),
          );
  }
}
