import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// This is the user service class that will be used to manage the user's authentication and user data management.
class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();

  UserService._();

  bool initialized = false;

  /// Collection name of the user's collection.
  String collectionName = 'users';
  CollectionReference get col =>
      FirebaseFirestore.instance.collection(collectionName);

  User? user;
  BehaviorSubject<User?> changes = BehaviorSubject();

  /// Enable anonymous sign in, by default it is false.
  ///
  /// If it is true, the user will automatically sign in (as anonymous) when
  /// the user signs out. This may lead confusion!
  ///
  bool enableAnonymousSignIn = false;

  /// to replace the fireflutter public profile screen, you can provide
  /// your own public profile screen in user initialization
  /// ex.
  /// ```dart
  /// UserService.intance.init(
  ///  publicProfileScreen: (user) {
  ///     return MyPublicProfileScreen(user: user);
  ///   }
  /// );
  /// ```
  Widget Function(User? user)? publicProfileScreen;
  Widget Function()? profileUpdateScreen;

  init({
    String? collectionName,
    bool enableAnonymousSignIn = false,
    Widget Function(User? user)? publicProfileScreen,
    Widget Function()? profileUpdateScreen,
  }) {
    if (initialized) {
      dog('UserService is already initialized; It will not initialize again.');
      return;
    }
    initialized = true;
    if (collectionName != null) {
      this.collectionName = collectionName;
    }
    this.enableAnonymousSignIn = enableAnonymousSignIn;
    listenUserDocumentChanges();
    this.publicProfileScreen = publicProfileScreen ?? this.publicProfileScreen;
    this.profileUpdateScreen = profileUpdateScreen ?? this.profileUpdateScreen;
  }

  initAnonymousSignIn() async {
    if (enableAnonymousSignIn) {
      final user = fa.FirebaseAuth.instance.currentUser;
      if (user == null) {
        // dog('initAnonymousSignIn: sign in anonymously');
        await fa.FirebaseAuth.instance.signInAnonymously();
      }
    }
  }

  bool get signedIn => fa.FirebaseAuth.instance.currentUser != null;
  bool get notSignedIn => !signedIn;

  /// Listen to my document
  StreamSubscription<fa.User?>? firebaseAuthSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      firestoreMyDocSubscription;
  listenUserDocumentChanges() {
    firebaseAuthSubscription?.cancel();
    firebaseAuthSubscription =
        // .distinct((p, n) => p?.user?.uid == n?.user?.uid)
        fa.FirebaseAuth.instance.authStateChanges().listen((faUser) async {
      /// User state changed
      if (faUser == null) {
        // dog('Firebase User is null. User signed out.');
        user = null;
        changes.add(user);
        initAnonymousSignIn();
      } else {
        if (faUser.isAnonymous) {
          // dog('User signed in. The Firebase User is anonymous');
        } else {
          // dog('User signed in. The Firebase User is NOT anonymous');
        }

        /// User signed in. Listen to the user's document changes.
        firestoreMyDocSubscription?.cancel();

        // 사용자 문서 초기화
        await _initUserDocumentOnLogin(faUser.uid);

        firestoreMyDocSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(faUser.uid)
            .snapshots()
            .listen((snapshot) {
          // 주의: 여기서는 어떤 경우에도 사용자 문서를 업데이트해서는 안된다.
          if (snapshot.exists) {
            user = User.fromSnapshot(snapshot);
          } else {
            user = null;
          }
          changes.add(user);
        });
      }
    });
  }

  Future<void> signOut() async {
    await fa.FirebaseAuth.instance.signOut();
  }

  /// 로그인 시, 사용자 문서 초기화
  ///
  /// Firebase 로그인을 하고, 사용자 문서가 존재 할 수 있고, 존재하지 않을 수 있다.
  /// 사용자 문서가 존재하지 않거나, createdAt 이 null 이면, createdAt 을 생성한다.
  /// 즉, createdAt 은 최초 1회만 생성되므로, 사용자 문서 생성 시, 최초 1회 동작이 필요하다면,
  /// 이 루틴에서 하면 된다.
  ///
  /// lastLoginAt 은 로그인 할 때 마다 업데이트한다.
  ///
  _initUserDocumentOnLogin(String uid) async {
    /// 나의 정보를 가져온다.
    final got = await User.get(uid, cache: false);

    final data = {
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    if (got == null || got.createdAt == null) {
      // dog('최초 1회 문서를 생성하고, 코드를 실행.');
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await User.fromUid(uid).doc.set(
          data,
          SetOptions(merge: true),
        );
  }

  // to display public profile user `UserService.intance.showPublicProfile`
  // this will display publicProfile from fireflutter
  showPublicProfile(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return UserService.instance.publicProfileScreen == null
            ? UserPublicProfileScreen(user: user!)
            : UserService.instance.publicProfileScreen!.call(user);
      },
    );
  }

  showProfileUpdaeScreen(BuildContext context) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (context, _, __) {
          return UserService.instance.profileUpdateScreen == null
              ? const UserProfileUpdateScreen()
              : UserService.instance.profileUpdateScreen!.call();
        });
  }
}
