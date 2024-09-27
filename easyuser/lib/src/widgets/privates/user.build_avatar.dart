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
///
/// if [photoUrl] and [initials] are both null, an anonymous avatar will be
/// displayed.
///
/// [size] is the size of the avatar.
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
  final String? initials;
  final double size;
  final double radius;
  final Border? border;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if ((photoUrl == null || photoUrl!.isEmpty) && (initials == null || initials!.isEmpty)) {
      // No photo url and no initials -> Anonymous avatar
      child = UserCircleAvatar(
        size: size,
        radius: radius,
        border: border,
        child: Icon(
          Icons.person,
          size: size / 1.5,
        ),
      );
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      // Photo url -> Display the photo
      child = UserCircleAvatar(
        size: size,
        radius: radius,
        border: border,
        child: ThumbnailImage(
          url: photoUrl!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // No photo url but initials -> First letter of the initials
      child = UserCircleAvatar(
        size: size,
        radius: radius,
        border: border,
        child: Center(
          child: Text(
            initials![0].toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: size / 1.5,
                ),
          ),
        ),
      );
    }

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
