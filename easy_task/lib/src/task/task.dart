import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/src/task.service.dart';

/// A task entity class of Todo feature
///
/// This class provides all the functionalities of the entity itself. If the
/// app needs a functionality that is not for the entity itself, it should be
/// served by [TaskService].
///
/// A task can be assigned to muliple users. To assign a task to a user, use
/// [assignTo] method.
class Task {
  static final CollectionReference col = TaskService.instance.taskCol;
  DocumentReference get ref => col.doc(id);

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> assignTo;
  final String? groupId;
  final DateTime? startAt;
  final DateTime? endAt;
  final Map<String, dynamic> data;

  /// [creator] is the uid of the task creator
  String creator;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.assignTo,
    required this.groupId,
    this.startAt,
    this.endAt,
    required this.creator,
    required this.data,
  });

  factory Task.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    return Task.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }

  factory Task.fromJson(Map<String, dynamic> json, String id) {
    final Timestamp? createdAt = json['createdAt'];
    final Timestamp? updatedAt = json['updatedAt'];
    final Timestamp? startAt = json['startAt'];
    final Timestamp? endAt = json['endAt'];

    return Task(
      id: id,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: createdAt == null ? DateTime.now() : createdAt.toDate(),
      updatedAt: updatedAt == null ? DateTime.now() : updatedAt.toDate(),
      assignTo: List<String>.from(json['assignTo'] ?? []),
      groupId: json['groupId'],
      startAt: startAt?.toDate(),
      endAt: endAt?.toDate(),
      creator: json['creator'],
      data: json,
    );
  }

  /// Get a task by its id
  ///
  /// Example:
  /// ```dart
  /// return (await get(createdRef.id))!;
  /// ```
  ///
  /// Warning! avoid to use this method as much as possible since it costs a lot.
  static Future<Task?> get(String id) async {
    final snapshot = await col.doc(id).get();
    if (!snapshot.exists) return null;
    return Task.fromSnapshot(snapshot);
  }

  /// Create a task
  ///
  /// [title] is the title of the task.
  ///
  static Future<DocumentReference> create({
    String? title,
    String? content,
    DateTime? startAt,
    DateTime? endAt,
    List<String>? assignTo,
    String? groupId,
  }) async {
    return await col.add({
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (startAt != null) 'startAt': Timestamp.fromDate(startAt),
      if (endAt != null) 'endAt': Timestamp.fromDate(endAt),
      'assignTo': assignTo ?? [],
      if (groupId != null) 'groupId': groupId,
      'creator': myUid!,
    });
  }

  /// Update task
  ///
  /// The [update] method is used to update fields and is using
  /// `DocumentReference.update(updateData)` from cloud_functions.
  /// It means that if fields are existing it will be replaced by
  /// the values being updated. Therefore fields that are `maps`
  /// will be replaced by the map value if they are being updated
  /// here.
  ///
  /// NOTE: This cannot be used to `nullify` any field. Use
  /// [deleteField] method to delete a field.
  ///
  /// Be warned in updating [extraData] because it may
  /// be overriden by other fields if the update is also
  /// updating other task fields (the fields that are originally
  /// in Task already).
  Future<void> update({
    String? title,
    String? content,
    DateTime? startAt,
    DateTime? endAt,
    Map<String, dynamic>? extraData,
  }) async {
    final data = <String, dynamic>{
      ...?extraData,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (title != null) data['title'] = title;
    if (content != null) data['content'] = content;
    if (startAt != null) data['startAt'] = Timestamp.fromDate(startAt);
    if (endAt != null) data['endAt'] = Timestamp.fromDate(endAt);
    await ref.update(data);
  }

  /// Delete a field to a doc of task
  // Future<void> deleteField(List<String> fields) async {
  //   final deleteData = Map<String, dynamic>.fromEntries(
  //     fields.map((field) => MapEntry(field, FieldValue.delete())),
  //   );
  //   await ref.update(deleteData);
  // }

  /// Delete task including all the related assigns and data.
  Future<void> delete() async {
    final assigns = await TaskService.instance.assignCol
        .where('taskId', isEqualTo: id)
        .get();

    // Delete the assigns under the task first
    final assignDeleteFutures =
        assigns.docs.map((assign) => assign.reference.delete());

    // Await for all the assign delete futures
    await Future.wait(assignDeleteFutures);

    // Delete the task if all the assigns are deleted
    await ref.delete();
  }
}
