import 'package:example/screens/group/group.list.screen.dart';
import 'package:example/screens/task/task.list.screen.dart';
import 'package:example/screens/test/test.screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easyuser/easyuser.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  fa.User? get user => fa.FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(TestScreen.routeName);
            },
            icon: const Icon(Icons.fact_check),
          ),
          IconButton(
            onPressed: () {
              context.push(GroupListScreen.routeName);
            },
            icon: const Icon(Icons.group),
          ),
          IconButton(
            onPressed: () {
              context.push(TaskListScreen.routeName);
            },
            icon: const Icon(Icons.checklist),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AuthStateChanges(
          builder: (user) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (user == null) ...[
                  EmailPasswordLogin(
                    onLogin: () {
                      if (!context.mounted) return;
                      setState(() {});
                    },
                  ),
                ] else ...[
                  Text("Display Name: ${user.displayName}"),
                  Text("UID: ${user.uid}"),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('List of Tasks Created by Me'),
                        Expanded(
                          child: TaskListView(
                            queryOptions: TaskQueryOptions.myCreates(),
                            itemBuilder: (task, index) {
                              return ListTile(
                                onTap: () async {
                                  if (task.uid == my.uid) {
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder: (_, __, ___) =>
                                          TaskDetailScreen(
                                        task: task,
                                      ),
                                    );
                                  } else if (task.assignTo.contains(my.uid)) {
                                    final assign = await TaskService.instance
                                        .getMyAssignFrom(task.id);
                                    if (assign == null) return;
                                    if (!context.mounted) return;
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder: (_, __, ___) =>
                                          AssignDetailScreen(
                                        assign: assign,
                                      ),
                                    );
                                  }
                                },
                                title: Text(
                                  task.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: const Icon(Icons.checklist_rounded),
                                subtitle: task.content.isEmpty
                                    ? null
                                    : Text(
                                        task.content,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                trailing:
                                    const Icon(Icons.chevron_right_outlined),
                                contentPadding: EdgeInsets.zero,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (context, a1, a2) {
                          return const TaskCreateScreen();
                        },
                      );
                      if (!context.mounted) return;
                      setState(() {});
                    },
                    child: const Text('+ Create Task'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await fa.FirebaseAuth.instance.signOut();
                      if (!context.mounted) return;
                      setState(() {});
                    },
                    child: const Text('Sign Out'),
                  ),
                  const SafeArea(
                    child: SizedBox(height: 24),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
