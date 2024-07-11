import 'package:easy_task/src/entities/group.dart';
import 'package:easy_task/src/entities/invitation.dart';
import 'package:easy_task/src/screens/user/user.list.screen.dart';
import 'package:easy_task/src/widgets/invitation.list_view.dart';
import 'package:flutter/material.dart';

class GroupInvitationListScreen extends StatelessWidget {
  const GroupInvitationListScreen({
    super.key,
    required this.group,

    // Review on Invite user?
  });

  final Group group;

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
              await Invitation.create(
                groupId: group.id,
                uid: inviteUid,
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: InvitationListView(
        queryOptions: InvitationQueryOptions(
          groupId: group.id,
        ),
      ),
    );
  }
}
