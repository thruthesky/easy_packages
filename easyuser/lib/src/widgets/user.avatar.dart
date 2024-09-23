import 'package:easyuser/easyuser.dart';
import 'package:easyuser/src/widgets/privates/user.build_avatar.dart';
import 'package:flutter/material.dart';

/// UserAvatar
///
/// This displays a user's avatar.
///
/// [photoUrl] is the user's photo url.
///
/// [initials] can be a uid, a displayName, or a name of the user. Only the first letter will be display if
/// there is no photo url.
///
/// [UserAvatar.fromUid] is a constructor that takes a user's uid and fetches
/// the user's data from the firestore and with sync option, it can
/// rebuild the avatar realtime when the user's data changes. The [uid] must
/// be the user's UID. It cannot be a name or a display name.
///
/// [size] is the size of the avatar.
///
/// [radius] is the radius of the avatar.
///
/// [onTap] is a function that is called when the avatar is tapped.
///
class UserAvatar extends StatelessWidget {
  const UserAvatar({
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
    return UserBuildAvatar(
      photoUrl: photoUrl,
      initials: initials,
      size: size,
      radius: radius,
      border: border,
      onTap: onTap,
    );
  }

  /// Display user's avatar from the user's uid.
  ///
  /// [uid] is the user's uid. It can be a null value. If it is null, an
  /// anonymous avatar will be displayed.
  ///
  /// [sync] is supported to support realtime update when the user's data is
  /// updated. If the [uid] is null, sync will be ignored.
  static Widget fromUid({
    Key? key,
    required String? uid,
    double size = 48,
    double radius = 20,
    Border? border,
    bool sync = false,
    final Function()? onTap,
  }) {
    return uid == null
        ? UserBuildAvatar(photoUrl: null, initials: null, onTap: onTap, size: size, radius: radius, border: border)
        : UserField<String?>(
            uid: uid,
            field: User.field.photoUrl,
            sync: sync,
            builder: (url) =>
                UserBuildAvatar(photoUrl: url, initials: uid, onTap: onTap, size: size, radius: radius, border: border),
          );
  }
}
