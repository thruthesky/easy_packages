import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

/// Task list screen
///
/// TODO: 사진 업로드, 태스크 아카이브(삭제 기능은 없음), 태스크(프로젝트) 삭제,
class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool completed = false;
  String menu = 'all';

  Query get query {
    Query q = Task.col;

    if (menu == 'all') {
      q = q.where(Filter.and(
        Filter(
          'creator',
          isEqualTo: TaskService.instance.currentUser!.uid,
        ),
        Filter.or(
          Filter('project', isEqualTo: true),
          Filter.and(
            Filter('project', isEqualTo: false),
            Filter('parent', isEqualTo: ''),
          ),
        ),
      ));
    } else if (menu == 'task') {
      q = q.where(Filter.and(
        Filter(
          'creator',
          isEqualTo: TaskService.instance.currentUser!.uid,
        ),
        Filter('project', isEqualTo: false),
        Filter('parent', isEqualTo: ''),
      ));
    } else if (menu == 'project') {
      q = q.where(Filter.and(
        Filter(
          'creator',
          isEqualTo: TaskService.instance.currentUser!.uid,
        ),
        Filter('project', isEqualTo: true),
      ));
    }

    q = q.where('completed', isEqualTo: completed);

    q = q.orderBy('createdAt', descending: true);

    return q;
  }

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
                    child: const Text('All')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      menu = 'task';
                    });
                  },
                  child: const Text('Tasks'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      menu = 'project';
                    });
                  },
                  child: const Text(
                    'Projects',
                  ),
                ),
              ],
            ),
          )),
      body: FirestoreListView(
        query: query,
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
