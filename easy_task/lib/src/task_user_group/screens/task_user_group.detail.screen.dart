import 'dart:async';

import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/src/task_user_group/screens/task_user_group.invitation.list.screen.dart';
import 'package:easy_task/src/task_user_group/screens/task_user_group.update.screen.dart';

import 'package:flutter/material.dart';

class TaskUserGroupDetailScreen extends StatefulWidget {
  const TaskUserGroupDetailScreen({
    super.key,
    required this.group,
    this.onInviteUids,
    this.userListTileBuilder,
  });

  final TaskUserGroup group;

  /// To use own user listing, use `inviteUids`.
  /// It must return List of uids of users to invite into group.
  /// If it returned null, it will not do anything.
  final FutureOr<List<String>?> Function(BuildContext context)? onInviteUids;

  /// To build own custom List Tile to display user, use `userListTileBuilder`.
  final Widget Function(String uid)? userListTileBuilder;

  @override
  State<TaskUserGroupDetailScreen> createState() =>
      _TaskUserGroupDetailScreenState();
}

class _TaskUserGroupDetailScreenState extends State<TaskUserGroupDetailScreen> {
  late TaskUserGroup group;

  @override
  void initState() {
    super.initState();
    group = widget.group;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group"),
        actions: [
          if (group.moderatorUsers.contains(myUid))
            IconButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) =>
                      TaskUserGroupInvitationListScreen(
                    group: group,
                    onInviteUids: widget.onInviteUids,
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
                      return widget.userListTileBuilder
                              ?.call(group.users[index]) ??
                          ListTile(
                            title: Text(group.users[index]),
                          );
                    },
                    itemCount: group.users.length,
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
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Text("Tasks:"),
          ),
          Expanded(
              child: TaskListView(
            queryOptions: TaskQueryOptions(
              groupId: group.id,
            ),
          )),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return TaskCreateScreen(
                      group: group,
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
                            group.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              pageBuilder: (dialogContext, a1, a2) =>
                                  TaskUserGroupUpdateScreen(
                                group: group,
                                onUpdate: () async {
                                  group = (await TaskUserGroup.get(group.id))!;
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
                    ...group.moderatorUsers.map(
                      (e) => Text(e),
                    ),
                    ...group.users.map((e) => Text(e)),
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
