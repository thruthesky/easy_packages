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
    required this.childCount,
    required this.completedChildCount,
    required this.project,
    required this.urls,
  });

  /// [id] is the task id
  final String id;

  /// [creator] is the uid of the user who created this task.
  final String creator;

  /// [title] is the title of the task.
  final String title;

  /// [description] is the description of the task.
  final String description;

  /// [createdAt] is the date and time when the task is created.
  final DateTime createdAt;

  /// [updatedAt] is the date and time when the task is updated. This field
  /// will be updated when the task is created or updated.
  final DateTime updatedAt;

  /// [completed] is true if the task is completed. Otherwise, it is false.
  /// For projects, if all the child tasks are completed, then the project is
  /// considered as completed and this will be set to true.
  final bool completed;

  /// [childCount] is the number of child tasks. This field is only for the
  /// project tasks.
  final int childCount;

  /// [completedChildCount] is the number of completed child tasks. This field
  /// is only for the project tasks.
  final int completedChildCount;

  /// [parent] is the id of the parent task. If the task is a root level task,
  /// then this field will be null. The parent may be a task or a project.
  /// If this take is a child task of a project, then the parent will be the
  /// project id.
  final String? parent;

  /// [child] is true if the task is a child task. Otherwise, it is false. If
  /// the task is a root level task, then this field will be false.
  final bool child;

  /// [project] is true if the task is a project. To list projects only, use
  /// this field.
  final bool project;

  /// [urls] is the list of urls of uploads in Firebase Stroage that are
  /// attached to the task.
  final List<String> urls;

  /// Get the task object from the snapshot.
  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    return Task.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  /// Get the task object from the json.
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
      childCount: json['childCount'] ?? 0,
      completedChildCount: json['completedChildCount'] ?? 0,
      project: json['project'],
      urls: List<String>.from(json['urls'] ?? []),
    );
  }

  /// Convert the task object to the json.
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
      'childCount': childCount,
      'completedChildCount': completedChildCount,
      'project': project,
      'urls': urls,
    };
  }

  @override
  String toString() {
    return toJson().toString();
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

    /// if parent exist, count child and update parent childCount
    if (parent != null) {
      /// count childCount
      final getChildCount = await col
          .where('creator', isEqualTo: TaskService.instance.currentUser!.uid)
          .where('parent', isEqualTo: parent)
          .count()
          .get();

      ///  save childCount and reset complete status
      await col.doc(parent).update({
        'childCount': getChildCount.count ?? 0,
        'completed': false,
      });
    }

    ///
    TaskService.instance.countRebuildNotifier.value = ref.id;
    return ref;
  }

  /// Update the task
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

  /// toggle the task
  Future<void> toggleCompleted(bool isCompleted) async {
    ///
    await ref.update({
      'completed': isCompleted,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (child == false) {
      TaskService.instance.countRebuildNotifier.value = "$id$isCompleted";
    }
    updateParentChildCount(isCompleted);
  }

  /// Update the parent childCount
  /// Count childCount, if has data then count completedChildCount.
  /// If childCount is equal to completedChildCount meaning all task are complete.
  /// Save [completedChildCount] and [completed] status
  /// If the update will change  the total count of on total completion or Project
  /// e.g. 1) A project with all task has been completed, then it should go to completed list
  ///      2) A project that has complete status but new task was added, then it should go to project list.
  ///      3) A complete project then an existing task was uncheck, then it should go to project list.
  ///
  Future<void> updateParentChildCount(bool isCompleted) async {
    if (parent == null) return;

    /// count child
    final getChildCount = await col
        .where('creator', isEqualTo: TaskService.instance.currentUser!.uid)
        .where('parent', isEqualTo: parent)
        .count()
        .get();

    if (getChildCount.count != null && getChildCount.count! > 0) {
      /// Count the completed child
      final getCompleteChildCount = await col
          .where('creator', isEqualTo: TaskService.instance.currentUser!.uid)
          .where('parent', isEqualTo: parent)
          .where('completed', isEqualTo: true)
          .count()
          .get();

      /// Update parent completed child Count
      await col.doc(parent).update({
        'completedChildCount': getCompleteChildCount.count ?? 0,
        'completed': getCompleteChildCount.count == getChildCount.count,
      });

      /// If the update result of the update was completion of all the project task,
      /// Then notify count rebuild
      if (isCompleted && getCompleteChildCount.count == getChildCount.count) {
        TaskService.instance.countRebuildNotifier.value = "$id$isCompleted";

        /// If the update result from all complete to uncomplete project task,
        /// Then notify count rebuild
      } else if (!isCompleted &&
          (getCompleteChildCount.count ?? 0) + 1 == getChildCount.count) {
        TaskService.instance.countRebuildNotifier.value = "$id$isCompleted";
      }
    }
  }
}
