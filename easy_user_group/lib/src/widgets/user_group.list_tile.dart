import 'package:easy_user_group/easy_user_group.dart';
import 'package:flutter/material.dart';

class UserGroupListTile extends StatelessWidget {
  const UserGroupListTile({super.key, required this.userGroup});

  final UserGroup userGroup;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userGroup.title),
      subtitle: Text(userGroup.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        UserGroupService.instance.showUserGroupDetailScreen(context, userGroup);
      },
    );
  }
}
