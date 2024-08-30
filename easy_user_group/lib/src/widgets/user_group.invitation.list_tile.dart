import 'package:easy_locale/easy_locale.dart';
import 'package:easy_user_group/easy_user_group.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UserGroupInvitationListTile extends StatelessWidget {
  const UserGroupInvitationListTile({
    super.key,
    required this.userGroup,
    this.onAccept,
    this.onReject,
  });

  final UserGroup userGroup;
  final Function(UserGroup userGroup, User? user)? onAccept;
  final Function(UserGroup userGroup, User? user)? onReject;

  static const double _minTileHeight = 70;

  static const EdgeInsetsGeometry _contentPadding =
      EdgeInsets.symmetric(horizontal: 16);

  onTapAccept([User? user]) async {
    onAccept?.call(userGroup, user);
    await userGroup.acceptInvite();
  }

  onTapReject([User? user]) async {
    onReject?.call(userGroup, user);
    await userGroup.rejectInvite();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: _minTileHeight,
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        width: 48,
        height: 48,
        clipBehavior: Clip.hardEdge,
        child: Icon(
          Icons.people,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
      title: Text(
        userGroup.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        userGroup.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onTapAccept,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            child: Text("accept".t),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: onTapReject,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            child: Text("reject".t),
          ),
        ],
      ),
      contentPadding: _contentPadding,
    );
  }
}
