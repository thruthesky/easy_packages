import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
    this.onTap,
  });

  final User user;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(user: user),
      title: Text(
        user.displayName,
      ),
      subtitle: Text(
        user.createdAt?.toShort ?? '',
      ),
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        showGeneralDialog(
          context: context,
          pageBuilder: (_, __, ___) => UserPublicProfileScreen(user: user),
        );
      },
    );
  }
}
