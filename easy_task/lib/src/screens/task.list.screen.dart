import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/widgets/task.count.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

/// Task list screen
///
/// All menu will display all the projects and root level tasks.
///
/// Task menu will display only root level tasks.
///
/// Project menu will display only projects.
///
/// TODO: 사진 업로드, 태스크 아카이브(삭제 기능은 없음), 태스크(프로젝트) 삭제,
/// TODO: 프로젝트에는 task 갯수. 전체, complete 된것 과 되지않은 것 구분해서 카운트.
class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool completed = false;
  String menu = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Task List'),
          actions: [
            IconButton(
              onPressed: () {
                TaskService.instance.showTaskCreateScreen(context);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton(
                icon: const Icon(Icons.settings),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: CheckboxListTile(
                          value: completed,
                          title: const Text('Completed Tasks'),
                          onChanged: (v) {
                            setState(() {
                              completed = v ?? false;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ])
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        menu = 'all';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('All'),
                        TaskCount(menu: 'all', completed: completed),
                      ],
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        menu = 'task';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Tasks'),
                        TaskCount(menu: 'task', completed: completed),
                      ],
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        menu = 'project';
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Projects'),
                        TaskCount(menu: 'project', completed: completed),
                      ],
                    ))
              ],
            ),
          )),
      body: FirestoreListView(
        query: TaskFilter.query(menu: menu, completed: completed),
        itemBuilder: (context, snapshot) {
          final task = Task.fromSnapshot(snapshot);
          return TaskListTile(task: task);
        },
        errorBuilder: (context, error, stackTrace) {
          dog('error: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('An error occurred;\n$error'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
