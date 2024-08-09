import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:memory_cache/memory_cache.dart';

/// User model
///
/// This is the user model class that will be used to manage the user's data.
///
/// [private] is the private field that will be used to store the user's data.
class User {
  String uid;

  /// If the user is an admin, it will be true. If not, it will be false.
  final bool admin;

  String displayName;

  /// [caseIncensitiveDisplayName] is the display name that is case insensitive.
  /// It is saved in the database and used to search user name.
  /// Note that this is not needed for serialization.
  String caseIncensitiveDisplayName;
  String name;

  /// [caseIncensitiveName] is the name that is case insensitive.
  /// It is saved in the database and used to search user name.
  /// Note that this is not needed for serialization.
  String caseIncensitveName;

  String? gender;

  /// 처음 회원 가입을 하고, 최초 데이터를 업데이트(저장)하는 동안에는 createdAt 이 null 이 될 수 있다.
  DateTime? createdAt;
  DateTime? updatedAt;
  int? birthYear;
  int? birthMonth;
  int? birthDay;
  DateTime? lastLoginAt;
  String? photoUrl;

  /// state message and state image url
  String? stateMessage;
  String? statePhotoUrl;

  /// Collection reference of the user's collection.
  ///
  CollectionReference col = UserService.instance.col;
  CollectionReference metaCol = UserService.instance.metaCol;

  /// [doc] is the document reference of this user model.
  DocumentReference get doc => col.doc(uid);

  /// [ref] is an alias of [doc].
  DocumentReference get ref => doc;

  /// Current user's mirror reference in the RTDB.
  DatabaseReference get mirrorRef =>
      UserService.instance.mirrorUsersRef.child(uid);

  User({
    required this.uid,
    this.admin = false,
    this.displayName = '',
    this.caseIncensitiveDisplayName = '',
    this.name = '',
    this.caseIncensitveName = '',
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.birthYear,
    this.birthMonth,
    this.birthDay,
    this.lastLoginAt,
    this.photoUrl,
    this.stateMessage,
    this.statePhotoUrl,
  });

  /// Create a user with the given [uid].
  ///
  /// This is a factory constructor that will be used to create a user with the
  /// given [uid]. Be sure that the other fields are  empty(or null) even if
  /// they are not empty(or null) in the database.
  ///
  /// Use this when you need to use the method of the user model class. And do
  /// not use the fields of the user model class.
  ///
  ///
  /// uid 로 부터 사용자 객체 생성
  ///
  /// 주로, uid 값만 알고 있는 경우, 해당 uid 를 바탕으로 User 클래스 함수를 사용하고자 할 때
  /// 사용한다.
  factory User.fromUid(String uid) {
    return User(
      uid: uid,
      lastLoginAt: DateTime.now(),
    );
  }

  factory User.fromDatabaseSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw Exception('User.fromDatabaseSnapshot: value does not exist.');
    }
    if (snapshot.value == null) {
      throw Exception('User.fromDatabaseSnapshot: value is null.');
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from((snapshot.value as Map?) ?? {});

    return User.fromJson(data, snapshot.key!);
  }

  factory User.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
    if (snapshot.exists == false) {
      throw Exception('User.fromSnapshot: Document does not exist.');
    }
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('User.fromSnapshot: Document data is null.');
    }

    return User.fromJson(data, snapshot.id);
  }

  /// Serialize the user data to the json format.
  ///
  /// TODO: the date time can be Firestore Timestamp or Realtime Database integer.
  factory User.fromJson(Map<String, dynamic> json, String uid) {
    return User(
      uid: uid,
      admin: json['admin'] ?? false,
      displayName: json['displayName'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      lastLoginAt: json['lastLoginAt'] is Timestamp
          ? (json['lastLoginAt'] as Timestamp).toDate()
          : null,
      birthYear: json['birthYear'],
      birthMonth: json['birthMonth'],
      birthDay: json['birthDay'],
      photoUrl: json['photoUrl'],
      stateMessage: json['stateMessage'],
      statePhotoUrl: json['statePhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['admin'] = admin;
    data['displayName'] = displayName;
    data['name'] = name;
    data['gender'] = gender;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['birthYear'] = birthYear;
    data['birthMonth'] = birthMonth;
    data['birthDay'] = birthDay;
    data['lastLoginAt'] = lastLoginAt;
    data['photoUrl'] = photoUrl;
    data['stateMessage'] = stateMessage;
    data['statePhotoUrl'] = statePhotoUrl;
    return data;
  }

  @override
  toString() {
    return 'User(${toJson()})';
  }

  /// Get the user data from Database
  static Future<User?> get(
    String uid, {
    bool cache = true,
  }) async {
    return await getData(uid, cache: cache, database: true);
  }

  /// Get the user data from Firestore
  static Future<User?> getFromFirestore(
    String uid, {
    bool cache = true,
  }) async {
    return await getData(uid, cache: cache, firestore: true);
  }

  /// Get the user data with the given [uid].
  ///
  /// This is a static method that will be used to get a user with the given [uid].
  ///
  /// [cache] if cache is true, it will use the cache data if it exists. If not,
  /// it will get the data from the server.
  ///
  /// If [firestore] is true, it will get the data from Firestore.
  ///
  /// if [database] is true, it will get the data from the RTDB.
  ///
  /// TODO: unit test is needed.
  static Future<User?> getData(
    String uid, {
    bool cache = true,
    bool? firestore,
    bool? database,
  }) async {
    User? user;
    if (cache) {
      user = MemoryCache.instance.read<User?>(uid);
      if (user != null) {
        return user;
      }
    }

    /// Get the user data from the server
    if (firestore == true) {
      final DocumentSnapshot snapshot =
          await UserService.instance.col.doc(uid).get();
      if (snapshot.exists) {
        user = User.fromSnapshot(snapshot);
      }
    } else if (database == true) {
      DataSnapshot snapshot;
      final ref = UserService.instance.mirrorUsersRef.child(uid);

      ///
      try {
        snapshot = await ref.get();
      } catch (e) {
        throw UserException(
          'user/get-data from database: at: ${ref.path} ',
          e.toString(),
        );
      }

      ///
      if (snapshot.exists) {
        user = User.fromDatabaseSnapshot(snapshot);
      }
    } else {
      throw UserException(
        'user/get-data',
        'firestore or database must be true.',
      );
    }

    /// If the snapshot does not exist, return null.
    MemoryCache.instance.create<User?>(uid, user);
    return user;
  }

  /// Deprecated
  ///
  /// Don't use create method. It's not for creating a user.
  ///
  /// Use update method instead to create user data.
  @Deprecated('This is not for use.')
  static create({
    required String uid,
  }) {
    throw UnimplementedError('This is not for use.');
  }

  /// Update user data
  ///
  /// User `update` method is used to update the user data.
  ///
  /// [photoUrl] is dynamic since it can be a string of url or FieldValue.delete().
  ///
  /// It mirros the data to the RTDB and it does not use transaction because
  /// mirroring is not for transaction.
  Future<void> update({
    String? displayName,
    String? name,
    int? birthYear,
    int? birthMonth,
    int? birthDay,
    String? gender,
    dynamic photoUrl,
    String? stateMessage,
    String? statePhotoUrl,
  }) async {
    final data = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
      if (displayName != null) 'displayName': displayName,
      if (displayName != null)
        'caseIncensitiveDisplayName': displayName.toLowerCase(),
      if (name != null) 'name': name,
      if (name != null) 'caseIncensitveName': name.toLowerCase(),
      if (birthYear != null) 'birthYear': birthYear,
      if (birthMonth != null) 'birthMonth': birthMonth,
      if (birthDay != null) 'birthDay': birthDay,
      if (gender != null) 'gender': gender,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (stateMessage != null) 'stateMessage': stateMessage,
      if (statePhotoUrl != null) 'statePhotoUrl': statePhotoUrl,
    };
    final List<Future> futures = [];
    futures.add(ref.set(
      data,
      SetOptions(merge: true),
    ));

    /// Mirror to RTDB. Update the same data to the RTDB.
    ///
    /// TODO: Make a function in easy_firebase to convert the data for rtdb.
    if (data['updatedAt'] != null) {
      data['updatedAt'] = ServerValue.timestamp;
    }
    if (data['photoUrl'] == FieldValue.delete()) {
      data['photoUrl'] = null;
    }

    futures.add(mirrorRef.update(data));

    await Future.wait(futures);
  }

  /// delete user
  ///
  /// User `delete` delete the user document if its there own uid
  Future delete() async {
    if (uid != my.uid) {
      throw 'user-delete/not-your-document You dont have permission to delete other user';
    }
    await doc.delete();
  }
}
