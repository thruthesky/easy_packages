import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatefulWidget {
  static const String routeName = '/ProjectDetails';
  final Task task;

  const ProjectDetailsScreen({super.key, required this.task});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  Task get task => widget.task;

  @override
  void initState() {
    super.initState();
    dog('ProjectDetailsScreen::initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dog('ProjectDetailsScreen::didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant ProjectDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    dog('ProjectDetailsScreen::didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Project Details'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User ID: ${task.creator}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Project: ${task.project}',
                      style: const TextStyle(fontSize: 16)),
                  Text('Title: ${task.title}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Description: ${task.description}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Created At: ${task.createdAt}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Updated At: ${task.updatedAt}',
                      style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          TaskService.instance.showChildTaskCreateScreen(
                            context,
                            parentTask: task,
                          );
                        },
                        child: const Text('Add Task'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () => TaskService.instance
                              .showTaskUpdateScreen(context, task),
                          child: const Text('Update Project')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FirestoreListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              query: Task.col
                  .where(
                    'creator',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
                  .where('parent', isEqualTo: task.id)
                  .orderBy('createdAt', descending: true),
              itemBuilder: (context, snapshot) {
                final task = Task.fromSnapshot(snapshot);
                print('task: $task');
                return TaskListTile(task: task);
              },
            ),
          )
        ],
      ),
    );
  }
}
