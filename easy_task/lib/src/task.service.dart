import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/screens/task.user_group.create.screen.dart';
import 'package:easy_task/src/screens/task.user_group.detail.screen.dart';
import 'package:easy_task/src/screens/task.user_group.edit.screen.dart';
import 'package:easy_task/src/screens/task.user_group.list.screen.dart';
import 'package:easy_task/src/task.user_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Task service
///
/// Task service is a helper class that will be used to manage and service the task management system.
class TaskService {
  static TaskService? _instance;
  static TaskService get instance => _instance ??= TaskService._();

  /// Task count rebuild notifier
  ///
  /// Firestore aggregation queries cannot be updated in real-time. That's why
  /// when there is changes on the completion of 'root level task', it will
  /// notify the listeners to rebuild the UI of the task count.
  ValueNotifier<String> countRebuildNotifier = ValueNotifier('');

  TaskService._() {
    dog('TaskService is created');
    addTaskLocaleTexts();
  }

  CollectionReference col = FirebaseFirestore.instance.collection('tasks');
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Function? setLocaleTexts;

  bool initialized = false;
  init({
    Function? setLocaleTexts,
  }) {
    initialized = true;
    this.setLocaleTexts = setLocaleTexts;
  }

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

  /// Show the task task group list screen.
  showUserGroupListScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const TaskUserGroupListScreen();
      },
    );
  }

  showUserGroupCreateScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const TaskUserGroupCreateScreen();
      },
    );
  }

  showTaskUserGroupDetailScreen(BuildContext context, TaskUserGroup userGroup) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, __, ___) {
        return TaskUserGroupDetailScreen(userGroup: userGroup);
      },
    );
  }

  showTaskUserGroupEditScreen(BuildContext context, TaskUserGroup userGroup) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return TaskUserGroupEditScreen(userGroup: userGroup);
      },
    );
  }
}
