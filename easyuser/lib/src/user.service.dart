import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easy_engine/easy_engine.dart';

/// This is the user service class that will be used to manage the user's authentication and user data management.
class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();

  UserService._();

  bool initialized = false;

  CollectionReference get col => FirebaseFirestore.instance.collection('users');
  CollectionReference get metaCol => col.doc(myUid).collection('user-meta');

  /// Reference of the block document.
  DocumentReference get blockDoc => metaCol.doc('blocks');

  User? user;
  BehaviorSubject<User?> changes = BehaviorSubject();

  /// List of blocked users by the login user.
  ///
  ///
  /// The document of `users/user-meta/block` that holds the block information
  /// of other users.
  /// This data is updated in real-time.
  Map<String, dynamic> blocks = {};

  /// Fires whenever the user blocking data changes.
  BehaviorSubject<Map<String, dynamic>> blockChanges =
      BehaviorSubject.seeded({});

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
  Widget Function(BuildContext, User?)? $showPublicProfileScreen;
  Widget Function()? $showProfileUpdateScreen;

  init({
    bool enableAnonymousSignIn = false,
    Widget Function(BuildContext, User?)? showPublicProfileScreen,
    Widget Function()? showProfileUpdateScreen,
  }) {
    if (initialized) {
      dog('UserService is already initialized; It will not initialize again.');
      return;
    }
    initialized = true;
    this.enableAnonymousSignIn = enableAnonymousSignIn;
    listenDocumentChanges();
    $showPublicProfileScreen = showPublicProfileScreen;
    $showProfileUpdateScreen = showProfileUpdateScreen;
  }

  initAnonymousSignIn() async {
    if (enableAnonymousSignIn) {
      final user = fa.FirebaseAuth.instance.currentUser;
      if (user == null) {
        dog('initAnonymousSignIn: sign in anonymously');
        await fa.FirebaseAuth.instance.signInAnonymously();
      }
    }
  }

  /// Returns true if user is signed in including anonymous login.
  bool get signedIn => fa.FirebaseAuth.instance.currentUser != null;
  bool get notSignedIn => !signedIn;
  bool get anonymous =>
      fa.FirebaseAuth.instance.currentUser?.isAnonymous ?? false;

  /// Returns true if user is registered and not anonymous.
  ///
  /// It excludes anonymous users.
  bool get registered => signedIn && !anonymous;

  /// Listen to my document
  StreamSubscription<fa.User?>? firebaseAuthSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      firestoreMyDocSubscription;

  StreamSubscription<DocumentSnapshot>? firestoreBlockingSubscription;

  listenDocumentChanges() {
    firebaseAuthSubscription?.cancel();
    firebaseAuthSubscription =
        // .distinct((p, n) => p?.user?.uid == n?.user?.uid)
        fa.FirebaseAuth.instance.authStateChanges().listen((faUser) async {
      /// User state changed
      ///
      ///

      /// User signed out
      if (faUser == null) {
        // dog('Firebase User is null. User signed out.');
        user = null;
        changes.add(user);

        /// Clear user blocking data
        blocks = {};
        blockChanges.add(blocks);
        initAnonymousSignIn();
      } else {
        /// User signed in
        ///

        /// User is anonymous
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

        firestoreBlockingSubscription?.cancel();
        firestoreBlockingSubscription = blockDoc.snapshots().listen(
          (snapshot) {
            if (snapshot.exists) {
              blocks = snapshot.data() as Map<String, dynamic>;
            } else {
              blocks = {};
            }
            // dog('updated blocks: $blocks');
            blockChanges.add(blocks);
          },
        );
      }
    });
  }

  /// Get my user document
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
  showPublicProfileScreen(
    BuildContext context, {
    required User user,
  }) {
    return $showPublicProfileScreen?.call(context, user) ??
        showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) {
            return UserPublicProfileScreen(user: user);
          },
        );
  }

  showProfileUpdaeScreen(BuildContext context) {
    return $showProfileUpdateScreen?.call() ??
        showGeneralDialog(
          context: context,
          pageBuilder: (context, _, __) => const UserProfileUpdateScreen(),
        );
  }

  /// To easily display userSearchDialog you can use
  /// `UserService.intance.showUserSearchDialog`
  Future<User?> showUserSearchDialog(
    BuildContext context, {
    Widget Function(bool)? emptyBuilder,
    EdgeInsetsGeometry? padding,
    Widget Function(User, int)? itemBuilder,
    bool exactSearch = true,
    bool searchName = false,
    bool searchNickname = false,
  }) {
    return showDialog<User?>(
      context: context,
      builder: (context) => UserSearchDialog(
        emptyBuilder: emptyBuilder,
        padding: padding,
        itemBuilder: itemBuilder,
        exactSearch: exactSearch,
        searchName: searchName,
        searchNickname: searchNickname,
      ),
    );
  }

  /// Blocks other user.
  ///
  /// User can block other user and the block button may appear in different
  /// places in the app.
  ///
  /// Since the block has some logic of displaying the confirmation dialog,
  /// it is better to use this method to unify the block logic.
  ///
  /// This method toggles the block status.
  ///
  /// TODO: Display the other user's name and photo in the confirmation dialog.
  /// TODO: Dispaly error on blocking himself.
  Future block({
    required BuildContext context,
    required String otherUid,
  }) async {
    /// Display user info as subtitle in the confirmation dialog.
    Widget userInfoSubtitle = UserDoc(
      uid: otherUid,
      builder: (user) => user == null
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                UserAvatar(user: user),
                DisplayName(user: user),
              ],
            ),
    );

    /// The user is alredy blocked?
    if (blocks.containsKey(otherUid)) {
      /// Ask if the login-user want to un-block the user.
      final re = await confirm(
        context: context,
        title: Text('un-block confirm title'.t),
        subtitle: userInfoSubtitle,
        message: Text('un-block confirm message'.t),
      );
      if (re != true) return false;

      await blockDoc.update({
        otherUid: FieldValue.delete(),
      });
      if (context.mounted) {
        toast(context: context, message: Text('user is un-blocked'.t));
      }
      return;
    }

    final re = await confirm(
        context: context,
        title: Text('block confirm title'.t),
        subtitle: userInfoSubtitle,
        message: Text(
          'block confirm message'.t,
        ));
    if (re != true) return false;

    await blockDoc.set(
      {
        otherUid: {
          'blockedAt': FieldValue.serverTimestamp(),
        },
      },
      SetOptions(merge: true),
    );

    if (context.mounted) {
      toast(context: context, message: Text('user is blocked'.t));
    }
  }

  showBlockListScreen(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => const UserBlockListScreen(),
    );
  }

  /// when user resign the user document, user auth, and photo from storage will be deleted.
  Future<void> resign() async {
    try {
      if (my.photoUrl != null) {
        await StorageService.instance.delete(my.photoUrl);
      }
      await my.delete();
    } catch (e) {
      dog('UserService.resign Error--->$e');
      throw 'UserSerive.resign/failed-to-delete-document Failed to delete user document';
    }
    try {
      await engine.deleteAccount();
    } catch (e) {
      dog('UserService.resign Error--->$e');
      throw 'UserSerive.resign/failed-to-delete-document Failed to delete user Auth Credentials';
    }
    i.signOut();
  }
}
