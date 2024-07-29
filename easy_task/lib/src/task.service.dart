import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Task service
///
/// Task service is a helper class that will be used to manage and service the task management system.
class TaskService {
  static TaskService? _instance;
  static TaskService get instance => _instance ??= TaskService._();

  TaskService._();

  CollectionReference col = FirebaseFirestore.instance.collection('tasks');
  User? get currentUser => FirebaseAuth.instance.currentUser;

  showTaskCreateScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const TaskCreateScreen();
      },
    );
  }

  showTaskUpdateScreen(BuildContext context, Task task) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return TaskUpdateScreen(task: task);
      },
    );
  }

  showTaskDetailScreen(BuildContext context, Task task) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return TaskDetailsScreen(task: task);
      },
    );
  }

  showTaskListScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const TaskListScreen();
      },
    );
  }
}
