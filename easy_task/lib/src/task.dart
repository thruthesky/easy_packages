import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';

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
    required this.parent,
    required this.child,
    required this.project,
    required this.urls,
  });

  final String id;
  final String creator;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool completed;

  final String? parent;
  final bool child;

  /// For Projects
  final bool project;

  final List<String> urls;

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
      completed: json['completed'] ?? false,
      parent: json['parent'],
      child: json['child'],
      project: json['project'],
      urls: List<String>.from(json['urls'] ?? []),
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
      'parent': parent,
      'child': child,
      'project': project,
      'urls': urls,
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

  /// Create a task or a project
  static Future<DocumentReference> create({
    required String title,
    String description = '',
    bool project = false,
    String? parent,
    List<String> urls = const [],
  }) async {
    final ref = await col.add({
      'creator': TaskService.instance.currentUser!.uid,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'completed': false,
      'parent': parent,
      'child': parent != null,
      'project': project,
      'urls': urls,
    });

    ///
    TaskService.instance.countRebuildNotifier.value = ref.id;
    return ref;
  }

  Future<void> update({
    required String title,
    required String description,
    required bool project,
    List<String>? urls,
  }) async {
    await ref.update({
      'title': title,
      'description': description,
      'project': project,
      'updatedAt': FieldValue.serverTimestamp(),
      if (urls != null) 'urls': urls,
    });
  }

  Future<void> toggleCompleted(bool isCompleted) async {
    await ref.update({
      'completed': isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (child == false) {
      TaskService.instance.countRebuildNotifier.value = id;
    }
  }
}
