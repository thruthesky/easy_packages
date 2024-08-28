import 'package:cloud_firestore/cloud_firestore.dart';

/// DocumentModel is a model class to handle the data from the Firestore database.
///
/// It supports the basic CRUD.
class DocumentModel {
  final String collectionName;
  final String id;
  final Map<String, dynamic> data;

  DocumentReference get ref =>
      FirebaseFirestore.instance.collection(collectionName).doc(id);

  DocumentModel({
    required this.collectionName,
    required this.id,
    required this.data,
  });

  factory DocumentModel.fromSnapshot(DocumentSnapshot snapshot) {
    return DocumentModel.fromJson(
      snapshot.reference.parent.id,
      snapshot.id,
      Map<String, dynamic>.from(snapshot.data() as Map? ?? {}),
    );
  }

  factory DocumentModel.fromJson(
    String collectionName,
    String id,
    Map<String, dynamic> data,
  ) {
    return DocumentModel(
      collectionName: collectionName,
      id: id,
      data: data,
    );
  }

  Map<String, dynamic> toJson() {
    return data;
  }

  /// To get the data from the database.
  static Future<DocumentModel> get(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('settings').doc(id).get();
    return DocumentModel.fromSnapshot(snapshot);
  }

  /// To update the field in the database.
  Future<void> update(Map<String, dynamic> data) async {
    await ref.set(data, SetOptions(merge: true));
  }

  /// To get a value of the field from the memory data. (Not from the database)
  T? value<T>(String key) {
    return data[key] as T?;
  }

  /// Increment the value of the field in the database.
  Future<void> increment(String key, [int value = 1]) async {
    await ref.set({key: FieldValue.increment(value)}, SetOptions(merge: true));
  }
}
