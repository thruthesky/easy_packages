import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';

class ChatRoomMemberListTile extends StatelessWidget {
  const ChatRoomMemberListTile({
    super.key,
    required this.user,
    this.onTap,
    this.trailing,
    this.contentPadding,
  });

  final User user;
  final Function()? onTap;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding,
      trailing: trailing,
      leading: UserAvatar(user: user),
      title: Text(
        user.displayName,
      ),
      subtitle: Text(
        user.createdAt?.short ?? '',
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
