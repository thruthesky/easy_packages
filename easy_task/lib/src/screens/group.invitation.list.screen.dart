import 'package:easy_task/src/entities/group.dart';
import 'package:easy_task/src/screens/user/user.list.screen.dart';
import 'package:flutter/material.dart';

class GroupInvitationListScreen extends StatefulWidget {
  const GroupInvitationListScreen({
    super.key,
    required this.group,

    // Review on Invite user?
  });

  final Group group;

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
              final inviteUid = await showGeneralDialog<String?>(
                context: context,
                pageBuilder: (context, a1, a2) => UserListScreen(
                  onTap: (uid) => Navigator.of(context).pop(uid),
                ),
              );
              if (inviteUid == null) return;
              widget.group.inviteUsers([inviteUid]);
              widget.group.invitedUsers.add(inviteUid);
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
