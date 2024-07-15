import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskUserGroupCreateScreen extends StatefulWidget {
  const TaskUserGroupCreateScreen({super.key});

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
                final group = await TaskUserGroup.get(groupRef.id);
                if (!context.mounted) return;
                Navigator.of(context).pop(nameController.text);
                if (group == null) return;
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return TaskUserGroupDetailScreen(group: group);
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
