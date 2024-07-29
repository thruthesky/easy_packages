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
      completed: json['completed'] ?? false,
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

  Future<void> toggleCompleted(bool isCompleted) async {
    await ref.update({
      'completed': isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
