import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/src/screens/group.invitation.list.screen.dart';
import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({
    super.key,
    required this.group,
  });

  final Group group;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group"),
        actions: [
          IconButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, a1, a2) => GroupInvitationListScreen(
                  group: widget.group,
                ),
              );
            },
            icon: const Icon(Icons.outbox),
          ),
          IconButton(
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, a1, a2) => Scaffold(
                  appBar: AppBar(
                    title: const Text("Members"),
                  ),
                  body: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.group.members[index]),
                      );
                    },
                    itemCount: widget.group.members.length,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.group),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: TaskListView(
            queryOptions: TaskQueryOptions(
              groupId: widget.group.id,
            ),
          )),
          const Spacer(),
          if (widget.group.moderatorUid == myUid)
            ElevatedButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return TaskCreateScreen(
                      group: widget.group,
                    );
                  },
                );
                if (!context.mounted) return;
                setState(() {});
              },
              child: const Text('+ Create Group Task'),
            ),
          const SafeArea(
            child: SizedBox(
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
