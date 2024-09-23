import 'package:easyuser/easyuser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';

/// User model
///
/// This is the user model class that will be used to manage the user's data.
///
/// [private] is the private field that will be used to store the user's data.
class User {
  /// Field names used for the Firestore document
  static const field = (
    createdAt: 'createdAt',
    updatedAt: 'updatedAt',
    name: 'name',
    displayName: 'displayName',
    caseInsensitiveName: 'caseInsensitiveName',
    caseInsensitiveDisplayName: 'caseInsensitiveDisplayName',
    birthYear: 'birthYear',
    birthMonth: 'birthMonth',
    birthDay: 'birthDay',
    lastLoginAt: 'lastLoginAt',
    photoUrl: 'photoUrl',
    stateMessage: 'stateMessage',
    statePhotoUrl: 'statePhotoUrl',
    gender: 'gender',
  );

  Map<String, dynamic>? data;

  /// [uid] is the user's uid.
  String uid;

  /// If the user is an admin, it will be true. If not, it will be false.
  final bool admin;

  String displayName;

  /// [caseInsensitiveDisplayName] is the display name that is case insensitive.
  /// It is saved in the database and used to search user name.
  /// Note that this is not needed for serialization.
  String caseInsensitiveDisplayName;
  String name;

  /// [caseInsensitiveName] is the name that is case insensitive.
  /// It is saved in the database and used to search user name.
  /// Note that this is not needed for serialization.
  String caseInsensitiveName;

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
  DatabaseReference usersRef = UserService.instance.usersRef;

  DatabaseReference metaRef = UserService.instance.metaRef;

  /// [doc] is the document reference of this user model.
  DatabaseReference get doc => usersRef.child(uid);

  /// [ref] is an alias of [doc].
  DatabaseReference get ref => doc;

  User({
    required this.uid,
    this.admin = false,
    this.displayName = '',
    this.caseInsensitiveDisplayName = '',
    this.name = '',
    this.caseInsensitiveName = '',
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
    this.data,
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

    final Map<String, dynamic> data = Map<String, dynamic>.from((snapshot.value as Map?) ?? {});

    return User.fromJson(data, snapshot.key!);
  }

  // TODO REVIEW
  // TODO cleanup if we will no longer use Firestore
  // factory User.fromSnapshot(DocumentSnapshot<Object?> snapshot) {
  //   if (snapshot.exists == false) {
  //     throw Exception('User.fromSnapshot: Document does not exist.');
  //   }
  //   final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
  //   if (data == null) {
  //     throw Exception('User.fromSnapshot: Document data is null.');
  //   }

  //   return User.fromJson(data, snapshot.id);
  // }

  /// Serialize the user data to the json format.
  ///
  factory User.fromJson(Map<String, dynamic> json, String uid) {
    return User(
      uid: uid,
      admin: json['admin'] ?? false,
      displayName: json['displayName'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'],
      createdAt: json['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['updatedAt']) : DateTime.now(),
      lastLoginAt:
          json['lastLoginAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['lastLoginAt']) : DateTime.now(),
      birthYear: json['birthYear'],
      birthMonth: json['birthMonth'],
      birthDay: json['birthDay'],
      photoUrl: json['photoUrl'],
      stateMessage: json['stateMessage'],
      statePhotoUrl: json['statePhotoUrl'],
      data: json,
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
    return await getData(uid, cache: cache);
  }

  static Future getField<T>({
    required String uid,
    required String field,
    bool cache = true,
  }) async {
    String key = '$uid+$field';
    final value = MemoryCache.instance.read<T>(key);
    if (cache && value != null) {
      return value;
    }

    ///
    // final snapshot = await userFieldRef(uid, field).get();
    debugPrint("userFieldRef(uid, field).path: ${userFieldRef(uid, field).path}");
    // TODO using get is getting all the fields. Need to review.
    final snapshot = await FirebaseDatabase.instance.ref().child("users").child(uid).child(field).get();

    debugPrint("Snapshot Value: ${snapshot.value}");

    if (snapshot.exists) {
      final value = snapshot.value;
      MemoryCache.instance.create(key, value);
      return value;
    }
    return null;
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
  }) async {
    User? user;
    if (cache) {
      user = MemoryCache.instance.read<User?>(uid);
      if (user != null) {
        return user;
      }
    }

    DataSnapshot snapshot;
    final ref = UserService.instance.usersRef.child(uid);

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

    /// If the snapshot does not exist, return null.
    MemoryCache.instance.create<User?>(uid, user);
    return user;
  }

  /// Deprecated
  ///
  /// Don't use create method. It's not for creating a user.
  ///
  /// Use update method instead to create user data.
  @Deprecated('User data is created automatically when the user logs in. This is not for use.')
  static create() {
    throw UnimplementedError('This is not for use.');
  }

  /// Update user data
  ///
  /// User `update` method is used to update the user data.
  ///
  /// [photoUrl] is dynamic since it can be a string of url or FieldValue.delete().
  Future<void> update({
    String? displayName,
    String? name,
    int? birthYear,
    int? birthMonth,
    int? birthDay,
    String? gender,
    String? photoUrl,
    String? stateMessage,
    String? statePhotoUrl,
  }) async {
    final data = <String, dynamic>{
      field.updatedAt: ServerValue.timestamp,
      if (displayName != null) field.displayName: displayName.trim(),
      if (displayName != null) field.caseInsensitiveDisplayName: displayName.toLowerCase().trim(),
      if (name != null) field.name: name.trim(),
      if (name != null) field.caseInsensitiveName: name.toLowerCase().trim(),
      if (birthYear != null) field.birthYear: birthYear,
      if (birthMonth != null) field.birthMonth: birthMonth,
      if (birthDay != null) field.birthDay: birthDay,
      if (gender != null) field.gender: gender,
      if (photoUrl != null) field.photoUrl: photoUrl,
      if (stateMessage != null) field.stateMessage: stateMessage,
      if (statePhotoUrl != null) field.statePhotoUrl: statePhotoUrl,
    };

    await ref.update(data);
  }

  /// Delete the specified fields of user doc.
  ///
  /// Purpose: To delete the values of the fields.
  ///
  /// Why: Using the update method wont work in deletion in RTDB.
  ///
  /// Reason: If we set "null" in the update, it won't do anything
  ///         since de check it like (fieldName != null).
  Future<void> deleteFields(List<String> fieldNames) async {
    final data = <String, dynamic>{};
    for (final fieldName in fieldNames) {
      data[fieldName] = null;
    }
    await ref.update(data);
  }

  /// delete user
  ///
  /// User `delete` delete the user document if its there own uid
  Future delete() async {
    if (uid != my.uid) {
      throw 'user-delete/not-your-document You dont have permission to delete other user';
    }
    await ref.set(null);
  }
}
