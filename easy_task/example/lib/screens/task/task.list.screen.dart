import 'package:easy_task/easy_task.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  String title = 'Tasks I Created';
  TaskQueryOptions queryOptions = TaskQueryOptions.myCreates();

  final Map<String, TaskQueryOptions> dropDownItems = {
    'Tasks I Created': TaskQueryOptions.myCreates(),
    'Tasks Assigned to Me': TaskQueryOptions.assignedToMe(),
    'Tasks I Created and Assigned to Me':
        TaskQueryOptions.myCreatesAndAssignedToMe(),
    'Tasks I Created and Assigned to Others':
        TaskQueryOptions.myAssignsToOthers(),
    'Tasks I Created but Unassigned Yet':
        TaskQueryOptions.myCreatesButUnassigned(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton<String>(
          items: dropDownItems.keys.toList().map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            );
          }).toList(),
          value: title,
          onChanged: (value) {
            setState(() {
              title = value!;
              queryOptions = dropDownItems[value]!;
            });
          },
          selectedItemBuilder: (context) {
            return dropDownItems.keys.toList().map((e) {
              return DropdownMenuItem<String>(
                value: e,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 48 - 48 - 24,
                  child: Text(
                    e,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
      body: TaskListView(
        queryOptions: queryOptions,
        itemBuilder: (task, index) {
          return ListTile(
            onTap: () async {
              if (task.assignTo.contains(myUid)) {
                final assign =
                    await TaskService.instance.getMyAssignFrom(task.id);
                if (assign == null) return;
                if (!context.mounted) return;
                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) => AssignDetailScreen(
                    assign: assign,
                    task: task,
                  ),
                );
              } else {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) => TaskDetailScreen(
                    task: task,
                    assignUids: (context) async {
                      final uids = await showGeneralDialog<String?>(
                        context: context,
                        pageBuilder: (_, __, ___) => UserListView(
                          itemBuilder: (user, index) {
                            return UserListTile(
                              user: user,
                              onTap: () => {
                                Navigator.of(context).pop([user.uid]),
                              },
                            );
                          },
                        ),
                      );
                      return uids;
                    },
                  ),
                );
              }
            },
            title: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.checklist_rounded),
            subtitle: task.content.isEmpty
                ? null
                : Text(
                    task.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            trailing: const Icon(Icons.chevron_right_outlined),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          );
        },
      ),
    );
  }
}
