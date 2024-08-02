import 'package:cloud_firestore/cloud_firestore.dart';

class SettingModel {
  final String id;
  final Map<String, dynamic> data;

  DocumentReference get ref =>
      FirebaseFirestore.instance.collection('settings').doc(id);

  SettingModel({required this.id, required this.data});

  factory SettingModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SettingModel.fromJson(
      Map<String, dynamic>.from(snapshot.data() as Map? ?? {}),
      snapshot.id,
    );
  }

  factory SettingModel.fromJson(
    Map<String, dynamic> data,
    String id,
  ) {
    return SettingModel(id: id, data: data);
  }

  Map<String, dynamic> toJson() {
    return data;
  }

  /// To get the data from the database.
  static Future<SettingModel> get(String id) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('settings').doc(id).get();
    return SettingModel.fromSnapshot(snapshot);
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
