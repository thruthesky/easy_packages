import 'package:easyuser/src/widgets/privates/user.circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:easy_storage/easy_storage.dart';

/// UserBuildAvatar
///
/// It displays user photo or the first letter of the user's name or uid.
///
///
/// [photoUrl] is the user's photo url.
///
/// [initials] is a String of user's display name or uid. Or even, you can pass
/// any stirng. The first letter of the [initials] will be displayed if there is
/// no photo url.
class UserBuildAvatar extends StatelessWidget {
  const UserBuildAvatar({
    super.key,
    required this.photoUrl,
    required this.initials,
    this.size = 48,
    this.radius = 20,
    this.border,
    this.onTap,
  });

  final String? photoUrl;
  final String initials;
  final double size;
  final double radius;
  final Border? border;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final child = photoUrl == null
        ? initials.isEmpty
            // No photo url and no initials
            ? UserCircleAvatar(
                size: size,
                radius: radius,
                border: border,
                child: Icon(
                  Icons.person,
                  size: size / 1.5,
                ),
              )
            :
            // No photo url but initials
            Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: border,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Center(
                  child: Text(
                    initials[0].toUpperCase(),
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
            child: ThumbnailImage(
              url: photoUrl!,
              fit: BoxFit.cover,
            ),
          );

    if (onTap == null) {
      return child;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}
