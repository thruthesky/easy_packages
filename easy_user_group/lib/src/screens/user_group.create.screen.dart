import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_user_group/easy_user_group.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class UserGroupCreateScreen extends StatefulWidget {
  static const String routeName = '/TaskUserGroupCreate';
  const UserGroupCreateScreen({super.key});

  @override
  State<UserGroupCreateScreen> createState() => _UserGroupCreateScreenState();
}

class _UserGroupCreateScreenState extends State<UserGroupCreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Group Create'.t),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Task Title'.t),
                  controller: titleController,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Task Description'.t),
                  controller: descriptionController,
                  minLines: 3,
                  maxLines: 8,
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      toast(context: context, message: Text('input a title'.t));
                      return;
                    }
                    final ref = await UserGroup.create(
                      title: titleController.text,
                      description: descriptionController.text,
                    );
                    final group = await UserGroup.get(ref.id);
                    if (context.mounted && group != null) {
                      Navigator.of(context).pop();
                      debugPrint(group.toString());
                      UserGroupService.instance
                          .showUserGroupDetailScreen(context, group);
                    }
                  },
                  child: Text('Create Task Group'.t),
                ),
              ],
            ),
          ),
        ));
  }
}
