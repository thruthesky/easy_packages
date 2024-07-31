import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Task service
///
/// Task service is a helper class that will be used to manage and service the task management system.
class TaskService {
  static TaskService? _instance;
  static TaskService get instance => _instance ??= TaskService._();

  TaskService._() {
    dog('TaskService is created');
    addPostTranslations();
  }

  CollectionReference col = FirebaseFirestore.instance.collection('tasks');
  User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Show the task create screen. It can be a project creation.
  showTaskCreateScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const TaskCreateScreen();
      },
    );
  }

  /// Show the child task create screen
  showChildTaskCreateScreen(
    BuildContext context, {
    required Task parentTask,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return ChildTaskCreateScreen(
          parentTask: parentTask,
        );
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

  showProjectDetailScreen(BuildContext context, Task task) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return ProjectDetailsScreen(task: task);
      },
    );
  }
}
