import 'package:easy_user_group/src/user_group.service.dart';
import 'package:flutter/material.dart';

class UserGroupOpenListScreenButton extends StatelessWidget {
  const UserGroupOpenListScreenButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        UserGroupService.instance.showUserGroupListScreen(context);
      },
      icon: const Icon(Icons.groups),
    );
  }
}
