import 'dart:async';

import 'package:easy_task/src/entities/group.dart';
import 'package:easy_task/src/screens/user/user.list.screen.dart';
import 'package:flutter/material.dart';

class GroupInvitationListScreen extends StatefulWidget {
  const GroupInvitationListScreen({
    super.key,
    required this.group,

    // Review on Invite user?
    this.onInviteUidList,
  });

  final Group group;

  /// To use own user listing, use `onInviteUidList`.
  /// It must return List of uids of users to invite into group.
  /// If it returned null, it will not do anything.
  final FutureOr<List<String>?> Function()? onInviteUidList;

  @override
  State<GroupInvitationListScreen> createState() =>
      _GroupInvitationListScreenState();
}

class _GroupInvitationListScreenState extends State<GroupInvitationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Invitations'),
        actions: [
          IconButton(
            onPressed: () async {
              final inviteUids = await showGeneralDialog<List<String>?>(
                context: context,
                pageBuilder: (context, a1, a2) => UserListScreen(
                  onTap: (uid) => Navigator.of(context).pop([uid]),
                ),
              );
              if (inviteUids == null) return;
              widget.group.inviteUsers(inviteUids);
              inviteUids.addAll(inviteUids);
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
