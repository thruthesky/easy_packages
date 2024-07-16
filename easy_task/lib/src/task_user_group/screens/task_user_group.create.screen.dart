import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskUserGroupCreateScreen extends StatefulWidget {
  const TaskUserGroupCreateScreen({super.key, this.onCreate});

  final Function(
    BuildContext context,
    DocumentReference ref,
  )? onCreate;

  @override
  State<TaskUserGroupCreateScreen> createState() =>
      _TaskUserGroupCreateScreenState();
}

class _TaskUserGroupCreateScreenState extends State<TaskUserGroupCreateScreen> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Group Name",
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final groupRef =
                    await TaskUserGroup.create(name: nameController.text);
                if (!context.mounted) return;
                if (widget.onCreate != null) {
                  widget.onCreate?.call(context, groupRef);
                  return;
                }

                final group = await TaskUserGroup.get(groupRef.id);
                if (!context.mounted) return;
                Navigator.of(context).pop(nameController.text);
                if (group == null) return;
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return TaskUserGroupDetailScreen(
                      group: group,
                    );
                  },
                );
              },
              child: const Text("Create"),
            ),
            const SafeArea(
              child: SizedBox(
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
