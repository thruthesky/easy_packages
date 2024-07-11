import 'package:flutter/material.dart';
import 'package:easy_task/easy_task.dart';

class TestScreen extends StatelessWidget {
  static const routeName = '/test';
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                testAllTask();
              },
              child: const Text('Test ALL'),
            ),
            ElevatedButton(
              onPressed: () {
                testTaskCrud();
              },
              child: const Text('Test CRUD'),
            ),
            ElevatedButton(
              onPressed: () {
                testAssignRetrieveMyDocFromTaskID();
              },
              child: const Text('Test Get My Assign from Task Id'),
            ),
            ElevatedButton(
              onPressed: () {
                testInvitationCRUD();
              },
              child: const Text('Test Invitation CRUD'),
            ),
            ElevatedButton(
              onPressed: () {
                testGroupCRUD();
              },
              child: const Text('Test Group CRUD'),
            ),
            ElevatedButton(
              onPressed: () {
                testTaskAssignmentToGroup();
              },
              child: const Text('Test Assignment to Group'),
            ),
          ],
        ),
      ),
    );
  }
}
