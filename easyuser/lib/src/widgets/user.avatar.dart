import 'package:easyuser/easyuser.dart';
import 'package:easyuser/src/widgets/privates/user.build_avatar.dart';
import 'package:easyuser/src/widgets/privates/user.circle_avatar.dart';
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
class UserAvatar extends StatelessWidget {
  const UserAvatar({
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
    return UserBuildAvatar(
      photoUrl: photoUrl,
      initials: initials,
      size: size,
      radius: radius,
      border: border,
    );
  }

  /// Display user's avatar from the user's uid.
  ///
  /// [sync] is supported to support realtime update when the user's data is
  /// updated.
  static Widget fromUid({
    Key? key,
    required String uid,
    double size = 48,
    double radius = 20,
    Border? border,
    bool sync = false,
  }) {
    return UserDoc<String?>(
      uid: uid,
      field: User.field.photoUrl,
      sync: sync,
      builder: (url) => url == null
          ? buildAnonymouseAvatar(size: size, radius: radius, border: border)
          : UserBuildAvatar(
              photoUrl: url,
              initials: uid,
              size: size,
              radius: radius,
              border: border,
            ),
    );
  }

  static buildAnonymouseAvatar({
    required double size,
    double radius = 20,
    Border? border,
  }) {
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
