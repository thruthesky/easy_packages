import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
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

/// Task model
///
/// Task model is a class that will be used to manage the task data.
class Task {
  static CollectionReference get col =>
      FirebaseFirestore.instance.collection('tasks');

  DocumentReference get ref => col.doc(id);

  Task({
    required this.id,
    required this.creator,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.completed,
  });

  final String id;
  final String creator;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool completed;

  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    return Task.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    return Task(
      id: id,
      creator: json['creator'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      completed: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completed': completed,
    };
  }

  /// Get the task with the given [id].
  static Future<Task?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return Task.fromSnapshot(snapshot);
  }

  static Future<DocumentReference> create({
    required String title,
    required String description,
  }) async {
    final doc = await col.add({
      'creator': TaskService.instance.currentUser!.uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'completed': false,
    });
    return doc;
  }

  Future<void> update({
    required String title,
    required String description,
  }) async {
    await ref.update({
      'title': title,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

class TaskCreateScreen extends StatefulWidget {
  static const String routeName = '/TaskCreate';
  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _createTask() async {
    if (_formKey.currentState!.validate()) {
      final ref = await Task.create(
        title: _titleController.text,
        description: _descriptionController.text,
      );
      final task = await Task.get(ref.id);
      TaskService.instance.showTaskDetailScreen(context, task!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTask,
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: ${widget.task.creator}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Title: ${widget.task.title}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Description: ${widget.task.description}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Created At: ${widget.task.createdAt}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Updated At: ${widget.task.updatedAt}',
                style: const TextStyle(fontSize: 16)),
            ElevatedButton(
                onPressed: () => TaskService.instance
                    .showTaskUpdateScreen(context, widget.task),
                child: const Text('Update Task')),
          ],
        ),
      ),
    );
  }
}

class TaskUpdateScreen extends StatefulWidget {
  static const String routeName = '/TaskUpdate';
  const TaskUpdateScreen({super.key, required this.task});

  final Task task;

  @override
  State<TaskUpdateScreen> createState() => _TaskUpdateScreenState();
}

class _TaskUpdateScreenState extends State<TaskUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskUpdate'),
      ),
      body: const Column(
        children: [
          Text("TaskUpdate"),
        ],
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  static const String routeName = '/TaskList';
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskList'),
      ),
      body: FirestoreListView(
        query: Task.col
            .where('creator', isEqualTo: TaskService.instance.currentUser!.uid),
        itemBuilder: (context, snapshot) {
          final task = Task.fromSnapshot(snapshot);
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
            onTap: () =>
                TaskService.instance.showTaskDetailScreen(context, task),
          );
        },
      ),
    );
  }
}
