import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easyuser/easyuser.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Project Details'),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: UserDoc(
                    uid: task.creator,
                    sync: true,
                    builder: (creator) => creator == null
                        ? const CircularProgressIndicator.adaptive()
                        : Row(
                            children: [
                              Text('${'Creator'.t} :'),
                              UserAvatar(
                                user: creator,
                                size: 24,
                                radius: 8,
                              ),
                              Text(
                                ' ${creator.displayName}',
                              ),
                              const Spacer(),
                              Text(
                                '${'Created At'.t}: ${task.createdAt.short}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Project: ${task.project}'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Card(
                    child: ListTile(
                      title: Text(task.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text(task.description,
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                // Text(
                //   'Updated At: ${task.updatedAt.short}',
                //   style: Theme.of(context).textTheme.labelSmall,
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: DisplayPhotos(urls: task.urls),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          TaskService.instance.showChildTaskCreateScreen(
                            context,
                            parentTask: task,
                          );
                        },
                        child: Text('Add Task'.t)),
                    ElevatedButton(
                        onPressed: () => TaskService.instance
                            .showTaskUpdateScreen(context, task),
                        child: Text('Update'.t)),
                  ],
                ),
              ],
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
                return TaskListTile(task: task);
              },
            ),
          )
        ],
      ),
    );
  }
}
