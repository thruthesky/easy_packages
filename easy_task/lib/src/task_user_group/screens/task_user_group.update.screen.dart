import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TaskUserGroupUpdateScreen extends StatefulWidget {
  const TaskUserGroupUpdateScreen({
    super.key,
    required this.group,
    this.onUpdate,
  });

  final TaskUserGroup group;
  final Function()? onUpdate;

  @override
  State<TaskUserGroupUpdateScreen> createState() =>
      _TaskUserGroupUpdateScreenState();
}

class _TaskUserGroupUpdateScreenState extends State<TaskUserGroupUpdateScreen> {
  final nameController = TextEditingController();

  @override
  initState() {
    super.initState();
    nameController.text = widget.group.name;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Group"),
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
                await widget.group.update(name: nameController.text);
                widget.onUpdate?.call();
                if (!context.mounted) return;
                Navigator.of(context).pop(nameController.text);
              },
              child: const Text("Update"),
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
