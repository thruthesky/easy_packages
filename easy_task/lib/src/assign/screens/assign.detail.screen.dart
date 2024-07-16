import 'package:easy_task/src/defines.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class AssignDetailScreen extends StatefulWidget {
  AssignDetailScreen({
    super.key,
    required this.assign,
    this.task,
    this.group,
  })  : assert(task == null || assign.taskId == task.id,
            "Assign and Task must be related."),
        assert(group == null || assign.groupId == group.id,
            "Assign and Group must be related.");

  final Assign assign;

  /// For faster, and less rebuild, add [task]
  /// so that it doesn't have to get and wait for future
  final Task? task;

  /// Since only moderator can close task, we need the user group information.
  final TaskUserGroup? group;

  @override
  State<AssignDetailScreen> createState() => _AssignDetailScreenState();
}

class _AssignDetailScreenState extends State<AssignDetailScreen> {
  Task? task;
  TaskUserGroup? group;
  String? statusSelected;
  late Assign assign;

  @override
  void initState() {
    super.initState();
    assign = widget.assign;
    statusSelected = assign.status;
    task = widget.task;
    if (task == null) _initTask();
    group = widget.group;
    if (assign.groupId != null && widget.group == null) _initGroup();
  }

  _initGroup() async {
    final group = await TaskUserGroup.get(assign.groupId!);
    if (group == null) throw 'Assign has group id but Group not found.';
    setState(() {
      this.group = group;
    });
  }

  _initTask() async {
    final task = await Task.get(assign.taskId);
    if (task == null) throw 'Task not found.';
    setState(() {
      this.task = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Task: ${task?.title}"),
            Text("Task Content: ${task?.content}"),
            const SizedBox(height: 24),
            Text("UID: ${assign.assignTo}"),
            Text("Status: ${assign.status}"),
            const Spacer(),
            if (assign.assignTo == myUid ||
                assign.assignedBy == myUid ||
                (group?.moderatorUsers.contains(myUid) ?? false)) ...[
              DropdownMenu<String>(
                width: MediaQuery.of(context).size.width - 48,
                dropdownMenuEntries: [
                  if (assign.status != AssignStatus.closed) ...[
                    if (assign.status == AssignStatus.waiting ||
                        assign.assignedBy == currentUser?.uid)
                      const DropdownMenuEntry(
                        value: AssignStatus.waiting,
                        label: "Waiting",
                      ),
                    const DropdownMenuEntry(
                      value: AssignStatus.progress,
                      label: "In Progress",
                    ),
                    const DropdownMenuEntry(
                      value: AssignStatus.review,
                      label: "Review",
                    ),
                    if (assign.assignedBy == currentUser?.uid ||
                        assign.status == AssignStatus.finished) ...[
                      const DropdownMenuEntry(
                        value: AssignStatus.finished,
                        label: "Finished",
                      ),
                    ],
                    if (group?.moderatorUsers.contains(myUid) ?? false) ...[
                      const DropdownMenuEntry(
                        value: AssignStatus.closed,
                        label: "Closed",
                      ),
                    ],
                  ] else ...[
                    const DropdownMenuEntry(
                      value: AssignStatus.closed,
                      label: "Closed",
                    ),
                  ],
                ],
                initialSelection: assign.status,
                onSelected: (value) => statusSelected = value,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await assign.changeStatus(statusSelected!);
                  if (!context.mounted) return;
                  assign = (await Assign.get(assign.id))!;
                  setState(() {});
                },
                child: const Text("CHANGE STATUS"),
              ),
            ],
            const SizedBox(height: 24),
            if (assign.assignedBy == currentUser?.uid)
              ElevatedButton(
                onPressed: () async {
                  await assign.delete();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text("UNASSIGN"),
              ),
            const SafeArea(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}
