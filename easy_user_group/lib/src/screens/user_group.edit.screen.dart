import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_user_group/easy_user_group.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class UserGroupEditScreen extends StatefulWidget {
  static const String routeName = '/UserGroupEdit';
  const UserGroupEditScreen({
    super.key,
    required this.userGroup,
  });

  final UserGroup userGroup;

  @override
  State<UserGroupEditScreen> createState() => _UserGroupEditScreenState();
}

class _UserGroupEditScreenState extends State<UserGroupEditScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.userGroup.title);
    descriptionController =
        TextEditingController(text: widget.userGroup.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Group'.t),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'User Group Title'.t),
                controller: titleController,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                decoration:
                    InputDecoration(labelText: 'User Group Description'.t),
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
                    toast(
                      context: context,
                      message: Text('input a title'.t),
                    );
                    return;
                  }
                  await widget.userGroup.update(
                    title: titleController.text,
                    description: descriptionController.text,
                  );
                  if (context.mounted) {
                    toast(
                      context: context,
                      message: Text('User group updated message'.t),
                    );
                  }
                },
                child: Text('Update User Group'.t),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
