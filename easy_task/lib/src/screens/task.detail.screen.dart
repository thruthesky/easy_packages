import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/widgets/task.doc.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_comment/easy_comment.dart';

class TaskDetailsScreen extends StatefulWidget {
  static const String routeName = '/TaskDetails';
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return TaskDoc(
      task: widget.task,
      sync: true,
      builder: (task) => Scaffold(
        appBar: AppBar(
          title: Text(task.title),
        ),
        body: CustomScrollView(
          slivers: [
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
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          task.description,
                          style: const TextStyle(fontSize: 16),
                        ),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Row(
                      children: [
                        // complete button
                        TextButton.icon(
                          onPressed: () async {
                            await task.toggleCompleted(!task.completed);
                          },
                          icon: task.completed ? const Icon(Icons.check) : null,
                          label: Text(
                              task.completed ? 'Completed'.t : 'To complete'.t),
                        ),
                        ElevatedButton(
                          onPressed: () => TaskService.instance
                              .showTaskUpdateScreen(context, task),
                          child: Text('Update Task'.t),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SliverPadding(padding: EdgeInsets.all(16)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommentFakeInputBox(
                  onTap: () => CommentService.instance.showCommentEditDialog(
                    context: context,
                    documentReference: task.ref,
                    focusOnContent: true,
                  ),
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.all(16)),
            CommentListTreeView(documentReference: task.ref),
          ],
        ),
      ),
    );
  }
}
