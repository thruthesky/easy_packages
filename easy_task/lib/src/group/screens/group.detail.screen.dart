import 'dart:async';

import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/src/group/screens/group.invitation.list.screen.dart';
import 'package:easy_task/src/group/screens/group.update.screen.dart';

import 'package:flutter/material.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({
    super.key,
    required this.group,
    this.inviteUids,
  });

  final Group group;

  /// To use own user listing, use `inviteUids`.
  /// It must return List of uids of users to invite into group.
  /// If it returned null, it will not do anything.
  final FutureOr<List<String>?> Function(BuildContext context)? inviteUids;

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
          if (widget.group.moderatorUsers.contains(myUid))
            IconButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) => GroupInvitationListScreen(
                    group: widget.group,
                    inviteUids: widget.inviteUids,
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
                        title: Text(widget.group.users[index]),
                      );
                    },
                    itemCount: widget.group.users.length,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.group),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
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
          if (widget.group.moderatorUsers.contains(myUid))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
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
            ),
          const SafeArea(
            child: SizedBox(
              height: 24,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 24 - 48,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SafeArea(
                      top: true,
                      bottom: false,
                      child: SizedBox(height: 4),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            widget.group.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              pageBuilder: (context, a1, a2) =>
                                  GroupUpdateScreen(
                                group: widget.group,
                                onUpdate: () {
                                  if (!context.mounted) return;
                                  setState(() => {});
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Moderators:",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    ...widget.group.moderatorUsers.map((e) => Text(e)),
                    const SizedBox(height: 24),
                    Text(
                      "Users:",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    ...widget.group.users.map((e) => Text(e)),
                    const SizedBox(height: 24),
                    const Spacer(),
                    const SizedBox(height: 24),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          Scaffold.of(context).closeEndDrawer();
                        },
                        child: const Text("Close"),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
