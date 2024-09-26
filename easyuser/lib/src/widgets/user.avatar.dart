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
/// * Note that, if the [onTap] is NOT set, the GestureDetector will not be
/// added to the avatar.
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
  /// [uid] is the user's uid. It can not be a null value.
  ///
  /// If [sync] is set to true, the image will be updated when the user updates
  /// his profile. By default it's false.
  ///
  /// It uses UserField to get the user's photo url. And the UserField uses
  /// memory cache internally. So, memory cache is enabled by default.
  static Widget fromUid({
    Key? key,
    required String uid,
    double size = 48,
    double radius = 20,
    Border? border,
    bool sync = false,
    final Function()? onTap,
  }) {
    return UserField<String?>(
      uid: uid,
      field: User.field.photoUrl,
      sync: sync,
      builder: (url) => UserBuildAvatar(
        photoUrl: url,
        initials: uid,
        onTap: onTap,
        size: size,
        radius: radius,
        border: border,
      ),
    );
  }
}
