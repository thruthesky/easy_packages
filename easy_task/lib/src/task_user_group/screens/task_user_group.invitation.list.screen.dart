import 'dart:async';

import 'package:easy_task/src/task_user_group/task_user_group.dart';
import 'package:easy_task/src/user/user.list.screen.dart';
import 'package:flutter/material.dart';

class TaskUserGroupInvitationListScreen extends StatefulWidget {
  const TaskUserGroupInvitationListScreen({
    super.key,
    required this.group,
    this.onInviteUids,
  });

  final TaskUserGroup group;

  /// To use own user listing, use `onInviteUids`.
  /// It must return List of uids of users to invite into group.
  /// If it returned null, it will not do anything.
  final FutureOr<List<String>?> Function(BuildContext context)? onInviteUids;

  @override
  State<TaskUserGroupInvitationListScreen> createState() =>
      _TaskUserGroupInvitationListScreenState();
}

class _TaskUserGroupInvitationListScreenState
    extends State<TaskUserGroupInvitationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Invitations'),
        actions: [
          IconButton(
            onPressed: () async {
              List<String>? inviteUids;
              if (widget.onInviteUids != null) {
                inviteUids = await widget.onInviteUids!.call(context);
              } else {
                inviteUids = await showGeneralDialog<List<String>?>(
                  context: context,
                  pageBuilder: (context, a1, a2) => UserListScreen(
                    onTap: (uid) => Navigator.of(context).pop([uid]),
                  ),
                );
              }
              if (inviteUids == null) return;
              widget.group.inviteUsers(inviteUids);
              widget.group.invitedUsers.addAll(inviteUids);
              if (!mounted) return;
              setState(() {});
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.group.invitedUsers.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(widget.group.invitedUsers[index]),
        ),
      ),
    );
  }
}
