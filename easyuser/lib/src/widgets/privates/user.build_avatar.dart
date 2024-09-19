import 'package:easyuser/easyuser.dart';
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
  });

  final String? photoUrl;
  final String initials;
  final double size;
  final double radius;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return photoUrl == null
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
  }
}
