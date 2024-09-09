import 'package:easyuser/easyuser.dart';
import 'package:easyuser/src/widgets/privates/user.build_avatar.dart';
import 'package:easyuser/src/widgets/privates/user.circle_avatar.dart';
import 'package:flutter/material.dart';

/// UserAvatar
///
/// This displays a user's avatar.
///
/// [user] is the user model object. The whole user model object is required
/// due to displaying the first letter or user display name when the user's
/// photoUrl is not available.
///
/// [UserAvatar.fromUid] is a constructor that takes a user's uid and
/// fetches the user's data from the firestore and with sync option, it can
/// rebuild the avatar realtime when the user's data changes.
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
    return UserBuildAvatar(
      user: user,
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
    return UserDoc(
      uid: uid,
      sync: sync,
      builder: (user) => user == null
          ? buildAnonymouseAvatar(size: size, radius: radius, border: border)
          : UserBuildAvatar(
              user: user,
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
