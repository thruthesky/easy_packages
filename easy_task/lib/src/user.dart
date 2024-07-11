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
