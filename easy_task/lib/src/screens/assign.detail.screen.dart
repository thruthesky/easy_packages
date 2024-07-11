import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class AssignDetailScreen extends StatefulWidget {
  const AssignDetailScreen({
    super.key,
    required this.assign,
  });

  final Assign assign;

  @override
  State<AssignDetailScreen> createState() => _AssignDetailScreenState();
}

class _AssignDetailScreenState extends State<AssignDetailScreen> {
  Task? task;
  final statusController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _initTask();
  }

  _initTask() async {
    final task = await Task.get(widget.assign.taskId);
    if (task == null) return;
    setState(() {
      this.task = task;
    });
  }

  @override
  void dispose() {
    statusController.dispose();
    super.dispose();
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
            Text("UID: ${widget.assign.uid}"),
            Text("Status: ${widget.assign.status}"),
            const Spacer(),
            if (widget.assign.uid == currentUser?.uid ||
                widget.assign.assignedBy == currentUser?.uid) ...[
              DropdownMenu<String>(
                // dropdownMenuEntries: AssignStatus.values()
                //     .map(
                //       (status) => DropdownMenuEntry(value: status, label: status),
                //     )
                //     .toList(),
                dropdownMenuEntries: [
                  if (widget.assign.status == AssignStatus.waiting)
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
                  if (widget.assign.assignedBy == currentUser?.uid) ...[
                    const DropdownMenuEntry(
                      value: AssignStatus.finished,
                      label: "Finished",
                    ),
                    const DropdownMenuEntry(
                      value: AssignStatus.closed,
                      label: "Closed",
                    ),
                  ],
                ],
                initialSelection: widget.assign.status,
                controller: statusController,
              ),
              ElevatedButton(
                onPressed: () async {
                  await widget.assign.changeStatus(statusController.text);
                  if (!context.mounted) return;
                  setState(() {
                    widget.assign.status = statusController.text;
                  });
                },
                child: const Text("CHANGE STATUS"),
              ),
            ],
            const SizedBox(height: 24),
            if (widget.assign.assignedBy == currentUser?.uid)
              ElevatedButton(
                onPressed: () async {
                  await widget.assign.delete();
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
