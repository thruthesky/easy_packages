import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';
import 'package:flutter/material.dart';

class InvitationScreen extends StatelessWidget {
  const InvitationScreen({
    super.key,
    required this.invitation,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invitation'),
      ),
      body: Column(
        children: [
          if (invitation.uid == myUid) ...[
            const Text("Do you want to accept group invitation?"),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await TaskService.instance
                          .acceptGroupInvitation(invitation.groupId);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Accept",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await TaskService.instance
                          .declineGroupInvitation(invitation.groupId);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Decline",
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            const Text("Waiting for response..."),
            if (invitation.invitedBy == myUid)
              ElevatedButton(
                onPressed: () async {
                  await invitation.delete();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel Invitation",
                ),
              ),
          ],
        ],
      ),
    );
  }
}
