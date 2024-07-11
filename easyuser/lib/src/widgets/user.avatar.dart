import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// UserAvatar
///
/// This displays a user's avatar.
///
/// [user] is the user model object. The whole user model object is required
/// due to displaying the first letter or user display name when the user's
/// photoUrl is not available.
///
///
class UserAvatar extends StatelessWidget {
  const UserAvatar({
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
                    ),
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: border,
              ),
              child: CachedNetworkImage(
                imageUrl: user.photoUrl!,
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
