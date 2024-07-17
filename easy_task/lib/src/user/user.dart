import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';

// NOTE: User should not be exported in easy_task.dart
//       because this should be handled by the app and
//       should be independent from this package.
class User {
  final String uid;
  final String? photoUrl;
  final String? name;

  static String get photoUrlFieldName =>
      TaskService.instance.userDocInfo.photoUrl;
  static String get nameFieldName => TaskService.instance.userDocInfo.name;

  User({
    required this.uid,
    required this.photoUrl,
    required this.name,
  });

  factory User.fromJson({
    required Map<String, dynamic> json,
    required String uid,
  }) {
    return User(
      uid: uid,
      photoUrl: json[photoUrlFieldName],
      name: json[nameFieldName],
    );
  }

  static User fromSnapshot(DocumentSnapshot snapshot) {
    final json =
        Map<String, dynamic>.from(snapshot.data() as Map<dynamic, dynamic>);
    return User.fromJson(json: json, uid: snapshot.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'photoUrl': photoUrl,
      'name': name,
    };
  }
}
