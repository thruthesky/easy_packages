// NOTE: User should not be exported in easy_task.dart
//       because this should be handled by the app and
//       should be independent from this package.
class User {
  final String uid;
  final String photoUrl;

  User({
    required this.uid,
    required this.photoUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'photoUrl': photoUrl,
    };
  }
}
